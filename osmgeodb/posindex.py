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

import operator
import time
import zmq
import zmq.asyncio

from collections import Counter
from sortedcontainers import SortedKeyList

from osmgeodb.mpack import m_pack, m_unpack

DATA_COUNTER = Counter()

async def receive_pos_index(socket: zmq.Socket, pos_index: SortedKeyList):
    """
    Receive OSM position index item from ZMQ socket and update the index.

    :param socket: ZMQ socket.
    :param pos_index: OSM position index.
    """
    ts = time.time()
    k = 0
    while True:
        k += 1
        data = await socket.recv()
        item = m_unpack(data)
        pos_index.add(item)

        DATA_COUNTER['nodes'] += 8000
        if k % 1000 == 0:
            td = time.time() - ts
            count = DATA_COUNTER['nodes'] / 1e6
            print('nodes[m]: {:,.1f} {:.3f}/s,  index len={}'.format(count, count / td, len(pos_index)))

async def send_pos_index(queue):
    ctx = zmq.asyncio.Context()
    socket = ctx.socket(zmq.PUSH)
    socket.connect('tcp://127.0.0.1:5558')
    while True:
        pos, group = await queue.get()
        await socket.send(m_pack((pos, group.id[0])))

def create_pos_index() -> SortedKeyList:
    """
    Create OSM position index.

    The new index is empty.
    """
    return SortedKeyList([], key=operator.itemgetter(1))

# vim: sw=4:et:ai
