import os
import sys
import subprocess
from subprocess import DEVNULL

out = "{\"no\":\"output\"}"


def create_package():
    try:
        os.chdir = sys.argv[1]
        source_code_path = sys.argv[2]

        pkg_dir = '/tmp/lambda_dist_pkg'
        req_file = source_code_path + '/requirements.txt'

        """Abort if requirements file doesn't exist"""
        if not os.path.exists(req_file):
            raise SystemExit

        """Create a temp directory if it doesn't exist"""
        if not os.path.exists(pkg_dir) and not os.path.isdir(pkg_dir):
            os.mkdir(pkg_dir)

        """Installing dependencies from requirements file"""
        subprocess.check_call(["pip", "install", "-r", req_file, "--target", pkg_dir], stdout=DEVNULL, stderr=DEVNULL)

        """Copying files to the temp folder"""
        subprocess.check_call(["cp", "-r", source_code_path + '/.', pkg_dir], stdout=DEVNULL, stderr=DEVNULL)

        sys.stdout.write(out)
    except ValueError as e:
        sys.exit(e)


if __name__ == "__main__":
    create_package()
