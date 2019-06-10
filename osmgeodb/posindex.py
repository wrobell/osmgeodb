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

import time
import zmq
import zmq.asyncio

from collections import Counter

from osmgeodb.mpack import m_pack, m_unpack

DATA_COUNTER = Counter()

async def receive_pos_index(socket):
    ts = time.time()
    k = 0
    while True:
        k += 1
        data = await socket.recv()
        pos, data = m_unpack(data)
        DATA_COUNTER['nodes'] += 8000
        if k % 1000 == 0:
            td = time.time() - ts
            count = DATA_COUNTER['nodes'] / 1e6
            print('nodes[m]: {:,.1f} {:.3f}/s  pos: {}'.format(count, count / td, pos))

async def send_pos_index(queue):
    ctx = zmq.asyncio.Context()
    socket = ctx.socket(zmq.PUSH)
    socket.connect('tcp://127.0.0.1:5558')
    while True:
        pos, group = await queue.get()
        await socket.send(m_pack((pos, group.id[0])))

# vim: sw=4:et:ai
