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

import zlib

from .osm_pb2 import BlobHeader, Blob, HeaderBlock, PrimitiveBlock
from .mpack import m_pack, m_unpack
from .parser import parse_dense_nodes
from .posindex import create_index_entry

async def process_messages(socket, q_index, q_store):
    while not socket.closed:
        data = await socket.recv()
        file_pos, data = m_unpack(data)

        data = zlib.decompress(data)
        block = PrimitiveBlock()
        block.ParseFromString(data)

        for type, group in detect_block_groups(block):
            f = PARSERS.get(type)
            if f:
                data = f(block, group)
                await q_index.put(create_index_entry(type, file_pos, group))
                await q_store.put(data)

    await q_index.put(None)
    await q_store.put(None)

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

PARSERS = {
    'dense_nodes': parse_dense_nodes,
}

# vim: sw=4:et:ai
