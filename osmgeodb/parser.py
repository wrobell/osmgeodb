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

import cytoolz.itertoolz as itz
import numpy as np

from itertools import takewhile
from shapely.geometry import Point

from ._parser import parse_tags

def parse_dense_nodes(block, data):
    granularity = block.granularity
    lon_offset = block.lon_offset
    lat_offset = block.lat_offset

    ids = np.array(data.id, dtype=np.int64).cumsum()

    lons = np.array(data.lon, dtype=np.float64).cumsum()
    lons = (lons * granularity + lon_offset) / 1e9

    lats = np.array(data.lat, dtype=np.float64).cumsum()
    lats = (lats * granularity + lat_offset) / 1e9

    tags = parse_tags(data.keys_vals, block.stringtable.s)

    items = zip(ids, lons, lats, tags)

    # store those positions, which have tags
    return [(id, Point(lon, lat), meta) for id, lon, lat, meta in items if meta]

# vim: sw=4:et:ai
