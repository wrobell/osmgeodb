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

import numpy as np
import zlib

from osmgeodb.osm_pb2 import BlobHeader, Blob, HeaderBlock, PrimitiveBlock
from osmgeodb.mpack import m_pack, m_unpack

async def process_messages(socket, processor_queue):
    while True:
        data = await socket.recv()
        pos, data = m_unpack(data)

        data = zlib.decompress(data)
        block = PrimitiveBlock()
        block.ParseFromString(data)

        for type, group in detect_block_groups(block):
            queue = processor_queue[type]
            await queue.put((pos, group))

def detect_group(group):
    if len(group.dense.id):
        result = 'dense_nodes', group.dense
    elif group.nodes:
        result = 'nodes', group.nodes
    elif group.ways:
        result = 'ways', group.ways
    else:
        assert group.relations
        result = 'relations', group.relations

    return result

def detect_block_groups(block):
    items = (detect_group(g) for g in block.primitivegroup)
    yield from items

def parse_dense_nodes(block, data):
    granularity = block.granularity
    lon_offset = block.lon_offset
    lat_offset = block.lat_offset

    ids = np.array(data.id, dtype=np.int64).cumsum()

    lons = np.array(data.lon, dtype=np.float64).cumsum()
    lons = (lons * granularity + lon_offset) / 1e9

    lats = np.array(data.lat, dtype=np.float64).cumsum()
    lats = (lats * granularity + lat_offset) / 1e9
#    return {
#        'type': 'dense_nodes',
#        'ids': ids.tobytes(),
#        'lons': lons.tobytes(),
#        'lats': lats.tobytes(),
#    }

# vim: sw=4:et:ai
