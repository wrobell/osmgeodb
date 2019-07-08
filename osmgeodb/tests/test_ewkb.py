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
Unit tests for EWKB serialization functions.
"""

from binascii import unhexlify

from ..ewkb import to_ewkb

def test_point_ewkb():
    """
    Test serialization of geographic points into EWKB format.
    """
    result = to_ewkb(-6.2602732, 53.3497645)
    expected = unhexlify('0101000020e6100000e019c80e850a19c0a1664815c5ac4a40')
    assert expected == result

# vim: sw=4:et:ai
