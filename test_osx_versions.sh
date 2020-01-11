# Test OSX version munging
if [ "$(osx_version2version_name 10.6)" != "10.6-SnowLeopard" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.7)" != "10.7-Lion" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.8)" != "10.8-MountainLion" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.9)" != "10.9-Mavericks" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.10)" != "10.10-Yosemite" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.11)" != "10.11-ElCapitan" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.12)" != "10.12-Sierra" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.13)" != "10.13-HighSierra" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.9.5)" != "10.9-Mavericks" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.10.2)" != "10.10-Yosemite" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.11.1)" != "10.11-ElCapitan" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.12.7)" != "10.12-Sierra" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.13.4)" != "10.13-HighSierra" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.14.1)" != "10.14-Mojave" ]; then RET=1; fi
if [ "$(osx_version2version_name 10.15.2)" != "10.15-Catalina" ]; then RET=1; fi
