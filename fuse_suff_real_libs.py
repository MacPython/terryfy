""" Fuse real (not symlinks to) libraries with same name, given suffix
"""

from __future__ import print_function

USAGE = """\
fuse_suff_real_libs.py <lib_dir> <lib_suffix>
"""

import os
from os.path import splitext, join as pjoin, islink, isfile
import sys
import shutil
from subprocess import check_call

LIB_EXTS = ('.a', '.so', '.dylib')


def main():
    try:
        lib_dir, suffix = sys.argv[1:]
    except (IndexError, ValueError):
        print(USAGE)
        sys.exit(-1)
    for fname in os.listdir(lib_dir):
        if not splitext(fname)[1] in LIB_EXTS:
            continue
        lib_path = pjoin(lib_dir, fname)
        if islink(lib_path):
            continue
        lib_path_suff = lib_path + suffix
        if not isfile(lib_path_suff):
            continue
        check_call(['lipo', '-create', lib_path, lib_path_suff,
                    '-output', lib_path])


if __name__ == '__main__':
    main()
