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
    format='[%(levelname)s] %(message)s',
    #datefmt='%Y-%m-%d:%H:%M:%S',
    level=logging.INFO
)


# Quiet the loggers we don't care about
sh_logging = logging.getLogger('sh')
sh_logging.setLevel(logging.WARNING)

logger = logging.getLogger(__name__)

def log_info(message: str, *args):
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
        return join(self.release_folder, self.__class__.__name__)
    
    @property
    def release_folder(self) -> str:
        return join(self.source, ".build", self.release_folder_name)
    
    @property
    def tools_path(self) -> str:
        return os.fspath(Path("pstoolchain/tools").resolve())
    
    bundles = []
    
    def __init__(self, name: str):
        super().__init__(name, [os.fspath(Path(name).resolve())])
        
def remove_file(file: str):
    if exists(file):
        os.remove(file)



##############################################################################
##############################################################################
##############################################################################
        
class PSProjectCLI(SwiftPackageExtension):
    
    bundles = [
        "PythonSwiftProject_PSProjectGen.bundle"
    ]
    
    def __init__(self):
        super().__init__("PSProjectGenerator")
        
class AstExporter(SwiftPackageExtension):
    
    release_folder_name = "release"
    
    def __init__(self):
        super().__init__(self.__class__.__name__)
        
##############################################################################
##############################################################################
##############################################################################

class BuildSwiftPackage(build_ext):
    
    def build_extension(self, ext: SwiftPackageExtension):
        name = ext.name
        
        toolchain_build_dir = join(
            self.build_lib,
            "pstoolchain",
        )
        
        log_info("building", name)
        log_info("platform", platform.machine())
        log_info("build args", *ext.swift_build_args)
        log_info("list <toolchain_build_dir folder> before build\n", sh.ls(toolchain_build_dir))
        
        subprocess.run(ext.swift_build_args)
        
        product = ext.product
        tools_path = join(
            toolchain_build_dir,
            "tools"
        )
        #bin = join(tools_path, basename(product))
        #remove_file(bin)
        os.makedirs(tools_path, exist_ok=True)
        shutil.copy(
            product,
            tools_path
        )
        for bundle in ext.bundles:
            shutil.copytree(
                join(ext.release_folder, bundle),
                join(tools_path, bundle)
            )

##############################################################################
##############################################################################
##############################################################################            
requires = [
    "sh"
]

setup(
    name="pstoolchain",
    
    entry_points={
        "console_scripts": ["pstoolchain=pstoolchain.toolchain:main"]
    },
    packages=["pstoolchain", "pstoolchain.tools"],
    install_requires=requires,
    ext_modules=[
            PSProjectCLI()
        ],
    cmdclass={"build_ext": BuildSwiftPackage},
)
