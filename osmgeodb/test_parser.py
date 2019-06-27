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

from osmgeodb.parser import parse_tags

def test_parse_node_tags():
    """
    Test parsing node tags.
    """
    indexes = [0, 2, 3, 4, 5, 0, 0, 2, 5, 0, 0]
    strings = [b'', b'', b'b1', b'b2', b'b3', b'b4']
    tags = parse_tags(indexes, strings, 5)

    expected = [{}, {'b1': 'b2', 'b3': 'b4'}, {}, {'b1': 'b4'}, {}]
    assert expected == tags

# vim: sw=4:et:ai
