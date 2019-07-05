#
# osmgeodb - GIS database for OpenStreetMap data
#
# Copyright (C) 2011-2019 by Artur Wroblewski <wrobell@riseup.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import ast
from setuptools import setup, find_packages, Extension
from Cython.Build import cythonize

VERSION = ast.parse(
    next(l for l in open('osmgeodb/__init__.py') if l.startswith('__version__'))
).body[0].value.s

try:
    from Cython.Build import cythonize
except:
    sys.exit(
        '\ncython is required, please install it with: pip install cython'
    )

setup(
    name='osmgeodb',
    packages=find_packages('.'),
    version=VERSION,
    description='osmgeodb is GIS database for OpenStreetMap data',
    author='Artur Wroblewski',
    author_email='wrobell@riseup.net',
    url='https://wrobell.dcmod.org/osmgeodb/',
    project_urls={
        'Documentation': 'https://wrobell.dcmod.org/osmgeodb/',
        'Code': 'https://github.com/wrobell/osmgeodb',
        'Issue tracker': 'https://github.com/wrobell/osmgeodb/issues',
    },
    setup_requires = ['setuptools_git >= 1.0', 'pyrobuf'],
    install_requires=[
        'cytoolz >= 0.8.2',
        'setproctitle',
        'sortedcontainers',
        'pyrobuf',
    ],
    classifiers=[
        'Topic :: Software Development :: Libraries',
        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
        'Programming Language :: Python :: 3',
        'Development Status :: 4 - Beta',
    ],
    ext_modules=cythonize([
        Extension('osmgeodb._parser', ['osmgeodb/_parser.pyx']),
        # until the following bug fixed:
        #
        #     https://github.com/appnexus/pyrobuf/issues/132
        Extension('osmgeodb.osm_proto', ['osmgeodb/osm_proto.pyx']),
    ]),
    license='GPLv3+',
)

# vim: sw=4:et:ai
