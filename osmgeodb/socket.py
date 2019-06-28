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

async def monitor_socket(name, socket):
    """
    Monitor socket for both being closed and disconnected by other side.

    :param name: Process name. Used for logging.
    :param socket: 0MQ socket.
    """
    title = name

    event = zmq.EVENT_DISCONNECTED | zmq.EVENT_CLOSED
    monitor = socket.get_monitor_socket(event)
    data = await monitor.recv_multipart()
    monitor.disable_monitor()
    data = parse_monitor_message(data)

    if __debug__:
        logger.debug(
            '{}: waiting for event {}, got {}'
            .format(title, event, data['event'])
        )

    assert data['event'] & event == data['event']

    linger = 0 if data['event'] == zmq.EVENT_DISCONNECTED else -1
    socket.close(linger)
    if __debug__:
        logger.debug('{}: socket closed with linger {}'.format(title, linger))
    logger.info('{}: exit monitor'.format(title))

async def send_messages(socket, messages):
    for msg in messages:
        await socket.send(m_pack(msg))

async def exit_on_cancel(task):
    try:
        result = await task
    except asyncio.CancelledError:
        result = None

    return result

# vim: sw=4:et:ai
