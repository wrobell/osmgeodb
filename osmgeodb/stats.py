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
import operator
import time
import zmq
import zmq.asyncio

from collections import Counter

from .mpack import m_pack
from .socket import recv_messages

logger = logging.getLogger(__name__)

FMT_STATS = 'nodes[m]: {0:,.3f} {1:.3f}/s, time[s]:' \
    ' decompression: {2[decompression]:.1f}' \
    ' block parse: {2[parse blocks]:.1f}' \
    ' group parse: {2[parse groups]:.1f}'.format

async def receive_stats(socket: zmq.Socket):
    """
    Receive OSM position index item from ZMQ socket and update the index.

    :param socket: ZMQ socket.
    :param pos_index: OSM position index.
    """
    stats: Counter = Counter()
    show_task = asyncio.create_task(show_stats(stats))

    async for item in recv_messages(socket):
        stats += item

    show_task.cancel()

async def send_stats(socket: zmq.Socket, queue: asyncio.Queue):
    while not socket.closed:
        item = await queue.get()
        if item is None:
            break

        await socket.send(m_pack(item))

async def show_stats(stats: Counter):
    ts = time.monotonic()
    try:
        while True:
            await asyncio.sleep(60)

            td = time.monotonic() - ts
            count = stats['size'] / 1e6
            logger.info(FMT_STATS(count, count / td, stats))

    finally:
        td = time.monotonic() - ts
        count = stats['size'] / 1e6
        logger.info(FMT_STATS(count, count / td, stats))

# vim: sw=4:et:ai
