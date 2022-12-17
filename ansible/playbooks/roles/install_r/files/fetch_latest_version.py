#!/usr/bin/env python

import glob
from distutils.version import LooseVersion

rlib_packages = glob.glob('/home/eosantigen/rlib/rlib_*')

rlib_packages_versions = list(map(lambda x: x.replace('rlib_','').replace('.tar.gz','').replace('/home/eosantigen/rlib/',''),rlib_packages))

rlib_packages_sorted = sorted(rlib_packages_versions, key=lambda x: LooseVersion(x), reverse=True)

print(rlib_packages_sorted[0])