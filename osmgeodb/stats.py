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

from collections import Counter

from .mpack import m_pack
from .socket import recv_messages

logger = logging.getLogger(__name__)

FMT_STATS = '{0}[m]: {1:,.3f} {2:.3f}/s, time[s]:' \
    ' decompression: {3[decompression]:.1f}' \
    ' block parse: {3[parse blocks]:.1f}' \
    ' group parse: {3[parse groups]:.1f}'.format

STATS_INTERVAL = 60

async def receive_stats(socket: zmq.Socket):
    """
    Receive OSM position index item from ZMQ socket and update the index.

    :param socket: ZMQ socket.
    :param pos_index: OSM position index.
    """
    stats = {
        'dense_nodes': Counter(),
        'ways': Counter(),
    }
    show_task = asyncio.create_task(asyncio.wait([
        show_stats('nodes', stats['dense_nodes']),
        show_stats('ways', stats['ways']),
    ]))

    async for item in recv_messages(socket):
        t, st = item
        if t not in stats:
            continue

        stats[t] += st

        if 'start' not in stats[t]:
            stats[t]['start'] = time.monotonic()
        stats[t]['end'] = time.monotonic()

    show_task.cancel()

async def send_stats(socket: zmq.Socket, queue: asyncio.Queue):
    while not socket.closed:
        item = await queue.get()
        if item is None:
            break

        await socket.send(m_pack(item))

def print_stats(type, stats):
    td = stats['end'] - stats['start']
    count = stats['size'] / 1e6
    logger.info(FMT_STATS(type, count, count / td, stats))

async def show_stats(type, stats: Counter):
    try:
        while True:
            await asyncio.sleep(STATS_INTERVAL)
            if time.monotonic() - stats.get('end', 0) > STATS_INTERVAL:
                continue
            print_stats(type, stats)
    finally:
        print_stats(type, stats)

# vim: sw=4:et:ai
