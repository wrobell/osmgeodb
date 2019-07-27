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

"""
Unit tests for OSM data parsing.
"""

from pyrobuf_list import Int32List, Int64List

from osmgeodb.parser import parse_tags_dense, cumsum

def test_parse_node_tags():
    """
    Test parsing node tags.
    """
    indexes = Int32List()
    indexes.extend([0, 2, 3, 4, 5, 0, 0, 2, 5, 0, 0])
    strings = [b'', b'', b'b1', b'b2', b'b3', b'b4']
    allowed = {'b1', 'b3'}
    tags = parse_tags_dense(allowed, indexes, strings)

    expected = [{}, {'b1': 'b2', 'b3': 'b4'}, {}, {'b1': 'b4'}, {}, {}]
    assert expected == list(tags)

def test_parse_node_tags_with_disallowed():
    """
    Test parsing node tags when disallowed tags are dropped.
    """
    indexes = Int32List()
    indexes.extend([2, 3, 4, 5, 6, 7, 0, 4, 5, 0, 4, 5, 6, 7])
    strings = [b'', b'', b'k1', b'v1', b'k2', b'v2', b'k3', b'v3']
    allowed = {'k1', 'k3'}
    tags = parse_tags_dense(allowed, indexes, strings)

    expected = [
        {'k1': 'v1', 'k3': 'v3'},
        {},
        {'k3': 'v3'},
    ]
    assert expected == list(tags)

def test_cumsum():
    """
    Test cumulative sum.
    """
    data = Int64List()
    data.extend(range(4))
    result = cumsum(data)
    assert [0, 1, 3, 6] == result

# vim: sw=4:et:ai
