from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
import subprocess
import os
from os.path import join, exists, basename
import shutil
import sys
from pathlib import Path
import platform
import sh
import logging

logging.basicConfig(
    format='#### [%(levelname)-8s] %(message)s ####',
    #datefmt='%Y-%m-%d:%H:%M:%S',
    level=logging.INFO
)


# Quiet the loggers we don't care about
sh_logging = logging.getLogger('sh')
sh_logging.setLevel(logging.WARNING)

logger = logging.getLogger(__name__)

def log_info(message: str, args: list):
    logger.info(f"{message} {' '.join(args)}")

#/Volumes/CodeSSD/GitHub/PSToolchain/packages/PSProjectGenerator/.build/x86_64-apple-macosx

class SwiftPackageExtension(Extension):
    
    @property
    def swift_build_args(self) -> list[str]:
        return [
            "swift", "build",
            "--package-path", self.source,
            "-c", "release"
        ]
    
    @property
    def source(self) -> str:
        return os.fspath(Path(f"packages/{self.name}").resolve())
    
    release_folder_name = f"{platform.machine()}-apple-macosx/release"
    
    @property
    def product(self) -> str:
        return join(self.source, ".build", self.release_folder_name, self.__class__.__name__)
    
    @property
    def tools_path(self) -> str:
        return os.fspath(Path("pstoolchain/tools").resolve())
    
    def __init__(self, name: str):
        super().__init__(name, [os.fspath(Path(name).resolve())])
        
def remove_file(file: str):
    if exists(file):
        os.remove(file)
        
class PSProjectCLI(SwiftPackageExtension):
    
    def __init__(self):
        super().__init__("PSProjectGenerator")
        
class AstExporter(SwiftPackageExtension):
    
    release_folder_name = "release"
    
    def __init__(self):
        super().__init__(self.__class__.__name__)

class BuildSwiftPackage(build_ext):
    
    def get_src_dir(self, ext) -> str:
        build_py = self.get_finalized_command('build_py')
        fullname = self.get_ext_fullname(ext.name)
        filename = self.get_ext_filename(fullname)
        modpath = fullname.split('.')
        package = '.'.join(modpath[:-1])
        return build_py.get_package_dir(package)
    
    def build_extension(self, ext: SwiftPackageExtension):
        name = ext.name
        src = ext.source
        current_dir = os.getcwd()
        log_info("building", name)
        log_info("platform", platform.machine())
        log_info("build args", ext.swift_build_args)
        log_info("current dir", current_dir)

        subprocess.run(ext.swift_build_args)
        #exit(0)
        product = ext.product
        tools_path = ext.tools_path
        tools_path = join(
            os.path.dirname(self.get_ext_fullpath("_")),
            "pstoolchain",
            "tools"
        )
        logger.info("list folder after build", sh.ls(current_dir))
        
        bin = join(tools_path, basename(product))
        #remove_file(bin)
        os.makedirs(tools_path, exist_ok=True)
        shutil.copy(
            product,
            bin
        )
setup(
    name="pstoolchain",
    
    entry_points={
        "console_scripts": ["pstoolchain=pstoolchain.toolchain:main"]
    },
    packages=["pstoolchain", "pstoolchain.tools"],
    # package_data={
    #     "pstoolchain.tools": ["PSProjectCLI"]
    # },
    #include_package_data=True,
    ext_modules=[
            PSProjectCLI()
        ],
    cmdclass={"build_ext": BuildSwiftPackage}
)
