import sys
import os
import sh
import subprocess
import shutil
from sh import Command, git
import tempfile
from os.path import realpath, dirname, basename, join, exists
import platform


class change_dir():
    
    def __init__(self, path: str):
        self.temporary_path = path
    
    def __enter__(self):
        self.last = os.getcwd()
        os.chdir(self.temporary_path)
        
    def __exit__(self, *args):
        os.chdir(self.last)

class InstallSwiftonize:
    
    def __init__(self):
        pass
    
    
    def list_dir(self,dir: str):
        print(dir)
        print(sh.ls(dir))
        
    def __call__(self, **kwds):
        if kwds.get("source", False):
            self.from_src()
        
    def from_src(self):
        package = "Swiftonize"
        tmp_dir = tempfile.mkdtemp()
        machine = platform.machine()
        with change_dir(tmp_dir):
            git("clone", "-b", "development", "https://github.com/PythonSwiftLink/Swiftonize")
            subprocess.run([
                "swift", "build",
                "--package-path", package,
                "--product", "Swiftonize",
                "-c", "release"
            ])
            
            build_dir = join(package, ".build")
            arch_dir = join(build_dir, "x86_64-apple-macosx")
            release_dir = join(build_dir, "release")
            
            #self.list_dir(build_dir)
            #self.list_dir(arch_dir)
            #self.list_dir(release_dir)
            
            binary = join(release_dir, package)
            if machine == "x86_64":
                local_bin = "/usr/local/bin"
            else:
                local_bin = "/opt/local/bin"
            
            if exists(join(local_bin, package)):
                os.remove(join(local_bin, package))
                
            shutil.copy(
                binary,
                local_bin
            )
            
        shutil.rmtree(tmp_dir)