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
# cython: language_level=3str
#

cdef set BLACKLIST = {'source', 'created_by'}

def parse_tags(indexes, strings) -> list:
    cdef size_t i = 0
    cdef list result = []
    cdef size_t max_idx = len(indexes) - 1
    cdef dict current

    strings = [s.decode('utf-8') for s in strings]

    while i <= max_idx:
        current = {}
        while i < max_idx and indexes[i] != 0:
            assert i + 1 <= max_idx
            current[strings[indexes[i]]] = strings[indexes[i + 1]]
            i += 2
        result.append({} if BLACKLIST.issuperset(current) else current)
        i += 1

    return result
