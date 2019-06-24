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
import zmq

from zmq.utils.monitor import parse_monitor_message

from .mpack import m_pack

logger = logging.getLogger(__name__)

async def monitor_socket(socket, event):
    monitor = socket.get_monitor_socket(event)
    data = await monitor.recv_multipart()
    data = parse_monitor_message(data)

    if __debug__:
        logger.debug(
            'waiting for event {}, got {}'.format(event, data['event'])
        )

    assert data['event'] == event

    monitor.disable_monitor()
    socket.close()
    logger.info('socket closed')

async def send_messages(messages):
    ctx = zmq.asyncio.Context()
    socket = ctx.socket(zmq.PUSH)
    socket.bind('tcp://127.0.0.1:5557')

    try:
        t1 = _send_messages(socket, messages)
        t2 = monitor_socket(socket, zmq.EVENT_DISCONNECTED)
        await asyncio.gather(t1, t2)
    finally:
        socket.close()
        logger.info('sent all messages')

async def _send_messages(socket, messages):
    for msg in messages:
        await socket.send(m_pack(msg))

async def exit_on_cancel(task):
    try:
        result = await task
    except asyncio.CancelledError:
        result = None

    return result

# vim: sw=4:et:ai
