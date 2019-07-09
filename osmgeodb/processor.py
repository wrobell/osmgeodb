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
import logging
import time
import zlib

from .osm_proto import PrimitiveBlock
from .parser import parse_dense_nodes
from .posindex import create_index_entry
from .socket import recv_messages

logger = logging.getLogger(__name__)

async def process_messages(socket, q_index, q_store, q_stats):
    async for file_pos, data in recv_messages(socket):
        stats = {}
        ts = time.monotonic()
        data = zlib.decompress(data)
        stats['decompression'] = time.monotonic() - ts

        ts = time.monotonic()
        block = PrimitiveBlock.FromString(data)
        stats['parse blocks'] = time.monotonic() - ts

        items = (item for item in block_groups(block) if item)
        ts = time.monotonic()
        items = [(t, g, s, f(block, g)) for t, g, s, f in items]
        stats['parse groups'] = time.monotonic() - ts
        if not items:
            continue

        types, groups, sizes, data = zip(*items)
        stats['size'] = sum(sizes)

        await q_store.put((v for item in data for v in item))
        await q_index.put(create_index_entry(types[0], file_pos, groups[0]))
        await q_stats.put(stats)

    await q_index.put(None)
    await q_store.put(None)
    await q_stats.put(None)

def detect_group(group):
    if len(group.dense.id):
        result = 'dense_nodes', group.dense, len(group.dense.id), parse_dense_nodes
    else:
        result = None

    return result

def block_groups(block):
    items = (detect_group(g) for g in block.primitivegroup)
    yield from items


# vim: sw=4:et:ai
