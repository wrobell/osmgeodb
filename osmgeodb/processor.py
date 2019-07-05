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

import asyncio
import time
import zlib
from collections import Counter

from .osm_proto import PrimitiveBlock
from .parser import parse_dense_nodes
from .posindex import create_index_entry
from .socket import recv_messages

async def process_messages(socket, q_index, q_store):
    counter = Counter()
    async for file_pos, data in recv_messages(socket):
        ts = time.monotonic()
        data = zlib.decompress(data)
        counter['decompression'] = time.monotonic() - ts

        ts = time.monotonic()
        block = PrimitiveBlock.FromString(data)
        counter['parse blocks'] = time.monotonic() - ts

        counter['parse groups'] = 0
        type, group, f = detect_block_group(block)
        if f:
            ts = time.monotonic()
            data = f(block, group)
            counter['parse groups'] += time.monotonic() - ts
            await q_index.put(create_index_entry(type, file_pos, group, counter))
            await q_store.put(data)

    await q_index.put(None)
    await q_store.put(None)

def detect_block_group(block):
    assert len(block.primitivegroup) == 1, len(block.primitivegroup)

    group = block.primitivegroup[0]
    if len(group.dense.id):
        result = 'dense_nodes', group.dense, parse_dense_nodes
    elif group.nodes:
        result = 'nodes', group.nodes, None
    elif group.ways:
        result = 'ways', group.ways, None
    else:
        assert group.relations
        result = 'relations', group.relations, None

    return result

# vim: sw=4:et:ai
