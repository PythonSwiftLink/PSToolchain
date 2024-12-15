from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
import subprocess
import os
from os.path import join, exists
import shutil
import sys
from pathlib import Path

class SPWExtension(Extension):
    def __init__(self, name: str):
        super().__init__(name, sources=[])
        self.sources = os.fspath(Path(name).resolve())

class BuildSwiftPackage(build_ext):
    
    def build_extension(self, ext: SPWExtension):
        print("QWERTY", ext.sources, sys.prefix)
        cwd = ext.sources
        
        # build swift executable
        subprocess.run([
            "swift", "build",
            "--package-path", cwd,
            "-c", "release"
            
        ])
        
        # copy to venv/bin
        bin = join(sys.prefix, "bin")
        if exists(join(bin, "PSToolchain")):
            os.remove(join(bin, "PSToolchain"))
        shutil.copy(
            join(cwd, ".build", "release", "PSToolchain"),
            bin
        )
setup(
    name="PSToolchain",
    #scripts=["bin/SwiftPackageWriter",],
    # entry_points={
    #     "scripts": ["bin/SwiftPackageWriter"]
    # },
    ext_modules=[SPWExtension("PSToolchain")],
    cmdclass={"build_ext": BuildSwiftPackage}
)
