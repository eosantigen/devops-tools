#!/usr/bin/python3

import glob
from distutils.version import LooseVersion

rclib_packages = glob.glob('/home/metis/rlib/metisrclib_*')

rclib_packages_versions = list(map(lambda x: x.replace('metisrclib_','').replace('.tar.gz','').replace('/home/metis/rlib/',''),rclib_packages))

rclib_packages_sorted = sorted(rclib_packages_versions, key=lambda x: LooseVersion(x), reverse=True)

print(rclib_packages_sorted[0])