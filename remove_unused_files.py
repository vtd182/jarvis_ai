import os
import re
import subprocess
import sys

os.chdir(os.path.dirname(os.path.abspath(__file__)))

is_windows = sys.platform == "win32"

while True:
    unused_files = subprocess.run("fvm dart run dart_code_metrics:metrics check-unused-files lib", stdout=subprocess.PIPE, shell=True).stdout.decode("utf-8")
    unused_files = re.findall('unused file: (.*\.dart)', unused_files)
    if not unused_files:
        break
    for file in unused_files:
        os.remove(file)
