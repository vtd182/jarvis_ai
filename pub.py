import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

os.system("""
    fvm flutter pub get
    fvm dart run build_runner build --delete-conflicting-outputs
    fvm dart run easy_localization:generate -f keys -O lib -o locale_keys.g.dart --source-dir ./assets/langs
    fvm dart format  lib/* test/* -l 150
    fvm dart run dependency_validator
""")
