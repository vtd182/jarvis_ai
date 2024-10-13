import json
import os
import re
import subprocess
import sys

os.chdir(os.path.dirname(os.path.abspath(__file__)))

is_window = sys.platform == "win32"

file = open('pubspec.yaml', mode='r', encoding="utf-8")
pubspec = file.read()
file.close()
used_version = re.search('flutter:.*(\\d+\\.\\d+)\\.\\d+.*', pubspec).group(1)

installed_versions = subprocess.run(["fvm", "api", "list", "-s"], stdout=subprocess.PIPE,
                                    shell=is_window)
installed_versions = installed_versions.stdout.decode('utf-8')
data = json.loads(installed_versions)
matched_versions = [version['name'] for version in data['versions'] if
                    version['name'].startswith(used_version) if not version['name'].endswith('pre')]
if len(matched_versions) > 0:
    matched_version = matched_versions[0]
else:
    matched_version = f"{used_version}.0"
    subprocess.run(["fvm", "install", matched_version], shell=is_window)

subprocess.run(["fvm", "use", matched_version], shell=is_window)
