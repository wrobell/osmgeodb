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


cimport pyrobuf_list

cpdef pyrobuf_list.Int64List cumsum(data: pyrobuf_list.Int64List):
    cdef size_t i

    for i in range(1, data._n_items):
        data._data[i] += data._data[i - 1]
    return data

def decode_coord(pyrobuf_list.Int64List data, double granularity, double offset) -> list:
    cdef long v
    return [(v * granularity + offset) / 1e9 for v in cumsum(data)]

def parse_tags(tags, pyrobuf_list.Int32List indexes, strings) -> list:
    cdef size_t i = 0
    cdef list result = []
    cdef size_t max_idx = indexes._n_items
    cdef dict current
    cdef str key

    strings = [s.decode('utf-8') for s in strings]

    while i <= max_idx:
        current = {}
        while i < max_idx and indexes._data[i] != 0:
            assert i + 1 <= max_idx
            key = strings[indexes._data[i]]
            if key in tags:
                current[key] = strings[indexes._data[i + 1]]
            i += 2
        result.append(current)
        i += 1

    return result

# vim: sw=4:et:ai
