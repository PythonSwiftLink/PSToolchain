import argparse
import sys
import os
import sh
import subprocess

from sh import Command

from os.path import realpath, dirname, basename, join
from pstoolchain.install_swiftonize import InstallSwiftonize


class ContextTools:
    __tools: str
    
    def __init__(self, root: str):
        self.__tools = join(root, "tools")
    
    @property
    def psproject(self) -> str: 
        return join(self.__tools, "PSProjectCLI")

class Context:
    
    root_dir: str
    tools: ContextTools
    
    def __init__(self):
        root_dir = realpath(dirname(__file__))
        self.root_dir = root_dir
        self.tools = ContextTools(root_dir)
            



class PSToolchainCL:
    
    def __init__(self):
        parser = argparse.ArgumentParser(
            description="Tool for managing the Python+Swift toolchain",
            usage="""toolchain <command> [<args>]

Available commands:

#### Xcode Project ####
    project       xcode project commands

#### Swiftonize ####
    install_swiftonize      install swiftonize to /usr/local/bin
    
#### Tools / Plugins ####
    
""")
        parser.add_argument("command", help="Command to run")
        args = parser.parse_args(sys.argv[1:2])
        if not hasattr(self, args.command):
            print('Unrecognized command', args.command)
            parser.print_help()
            exit(1)
        getattr(self, args.command)()


    def project(self):
        ctx = Context()
        
        subprocess.run(
            [ctx.tools.psproject, *sys.argv[2:]]
            
        )
        
    def install_swiftonize(self):
        ctx = Context()
        parser = argparse.ArgumentParser(
                description="Install Swiftonize")
        parser.add_argument("--source", action="store_true", default=False,
                            help="Install Swiftonize from source")
        
        args = parser.parse_args(sys.argv[2:])
        
        install = InstallSwiftonize()
        
        install(source=args.source)


def main():
    PSToolchainCL()


if __name__ == "__main__":
    main()