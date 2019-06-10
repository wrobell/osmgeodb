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
import os
import zmq

from .mpack import m_pack

async def monitor_socket(socket, event):
    monitor = socket.get_monitor_socket(event)
    data = await monitor.recv_multipart()
    data = parse_monitor_message(data)
    print(data)
    assert data['event'] == event
    monitor.disable_monitor()
    socket.close()
    print(os.getpid(), 'closed')

async def send_messages(messages):
    ctx = zmq.asyncio.Context()
    socket = ctx.socket(zmq.PUSH)
    socket.bind('tcp://127.0.0.1:5557')

    try:
        for msg in messages:
            await socket.send(m_pack(msg))
    finally:
        socket.close()

async def exit_on_cancel(task):
    try:
        result = await task
    except asyncio.CancelledError:
        result = None

    return result

# vim: sw=4:et:ai
