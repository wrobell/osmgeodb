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

from zmq.asyncio import Poller
from zmq.utils.monitor import parse_monitor_message

from .mpack import m_pack, m_unpack

logger = logging.getLogger(__name__)

SOCKET_EVENT = zmq.EVENT_DISCONNECTED | zmq.EVENT_CLOSED

async def monitor_socket(name, socket):
    """
    Monitor socket for both being closed and disconnected by other side.

    :param name: Process name. Used for logging.
    :param socket: 0MQ socket.
    """
    title = name

    monitor = socket.get_monitor_socket(SOCKET_EVENT)
    data = await monitor.recv_multipart()
    monitor.disable_monitor()
    data = parse_monitor_message(data)
    event = data['event']

    if __debug__:
        logger.debug('{}: received event {}' .format(title, event))

    assert event & SOCKET_EVENT == event

    await wait_empty_socket(title, socket)

    # no message, so close the socket immediately
    socket.close(0)
    logger.info('{}: exit monitor'.format(title))

async def wait_empty_socket(title, socket):
    """
    Wait for all the message to be received from socket.

    There can be still messages to be received on our side, after other
    side closed socket. Wait until our side receives all of them.
    """
    poller = Poller()
    poller.register(socket)
    logger.info('{}: wait for all messages to be received'.format(title))
    while True:
        data = await poller.poll(2)
        if not data:
            break

async def recv_messages(socket):
    """
    Iterate over messages received from 0MQ socket.

    The messages are received until socket is closed.

    :param socket: 0MQ socket.
    """
    try:
        while not socket.closed:
            # no need to copy message data as it is immediately unpacked by
            # msgpack
            yield m_unpack(await socket.recv(copy=False))
    except asyncio.CancelledError as ex:
        # if socket.recv call is cancelled, the socket is closed,
        # therefore exit gracefuly
        pass

async def send_messages(socket, messages):
    for msg in messages:
        await socket.send(m_pack(msg))

# vim: sw=4:et:ai
