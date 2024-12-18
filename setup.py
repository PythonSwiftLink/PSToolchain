from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
import subprocess
import os
from os.path import join, exists, basename
import shutil
import sys
from pathlib import Path
import platform

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
    
    def build_extension(self, ext: SwiftPackageExtension):
        name = ext.name
        src = ext.source
        print("Building", name, ext.swift_build_args)
        print(platform.machine())
        subprocess.run(ext.swift_build_args)
        #exit(0)
        product = ext.product
        tools_path = ext.tools_path
        bin = join(tools_path, basename(product))
        remove_file(bin)
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
    package_data={
        "tools": ["PSProjectCLI"]
    },
    #include_package_data=True,
    ext_modules=[
            PSProjectCLI()
        ],
    cmdclass={"build_ext": BuildSwiftPackage}
)
