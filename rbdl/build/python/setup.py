#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

import os
import numpy as np

BASEDIR = os.path.dirname(os.path.abspath(__file__))

extra_params = {}
extra_params['include_dirs'] = [
    '/usr/include',
    BASEDIR,
    np.get_include(),
    '',
    '/usr/include/eigen3',
    '/home/utec/ros_ws/src/rbdl/python',
    '/home/utec/ros_ws/src/rbdl/include',
    '/home/utec/ros_ws/src/rbdl/build/include',
    '/usr/include/eigen3/'
]

extra_params['language'] = 'c++'
extra_params['extra_compile_args'] = ["-O3", "-Wno-unused-variable", "-std=c++11"]
extra_params['libraries'] = ['rbdl']
extra_params['library_dirs'] = [
  '/home/utec/ros_ws/src/rbdl/build/python/../',
  '/home/utec/ros_ws/install/lib/',
  '/usr/lib',
  BASEDIR
  ]
extra_params['extra_link_args'] = [
  "-Wl,-O1",
  "-Wl,--as-needed", 
  ]

if os.name == 'posix':
    extra_params['runtime_library_dirs'] = extra_params['library_dirs']

ext_modules = [
    Extension("rbdl",  ["crbdl.pxd", "rbdl.pyx"], **extra_params),
]

setup(
    name='rbdl',
    author='Martin Felis',
    author_email='martin@fysx.org',
    description='Python wrapper for RBDL - the Rigid Body Dynamics Library',
    license='zlib',
    version='2.6.0',
    url='http://rbdl.bitbucket.org/',
    cmdclass={'build_ext': build_ext},
    ext_modules=cythonize(ext_modules),
)
