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

from osmgeodb.mpack import m_pack
from osmgeodb.socket import wait_empty_socket, recv_messages

import pytest
from unittest import mock
from asynctest import CoroutineMock

@pytest.mark.asyncio
async def test_wait_empty_socket():
    """
    Test waiting for all messages of a socket to be received.
    """
    with mock.patch('osmgeodb.socket.Poller') as mock_cls:
        poller = mock_cls()
        poller.poll = CoroutineMock(side_effect=[[1], []])
        await wait_empty_socket('test', mock.MagicMock())

        # `wait_empty_socket` exits on 2nd loop
        assert 2 == poller.poll.call_count

@pytest.mark.asyncio
async def test_recv_messages():
    """
    Test receiving 0MQ messages until socket is closed.
    """
    async def recv(v):
        return v

    socket = mock.MagicMock()
    socket.recv.side_effect = [
        recv(m_pack(['a', 'b'])),
        recv(m_pack([1, 2])),
        ValueError('shall not happen')
    ]
    socket.closed = False

    items = recv_messages(socket)
    result = await items.__anext__()
    assert ['a', 'b'] == result

    result = await items.__anext__()
    assert [1, 2] == result

    socket.closed = True
    with pytest.raises(StopAsyncIteration):
        await items.__anext__()

@pytest.mark.asyncio
async def test_recv_messages_cancel():
    """
    Test receiving 0MQ messages until socket is closed and `recv` call is
    cancelled.
    """
    async def recv(v):
        return v

    socket = mock.MagicMock()
    socket.recv.side_effect = [
        recv(m_pack(['a', 'b'])),
        recv(m_pack([1, 2])),
        asyncio.CancelledError(),
    ]
    socket.closed = False

    items = recv_messages(socket)
    result = await items.__anext__()
    assert ['a', 'b'] == result

    result = await items.__anext__()
    assert [1, 2] == result

    with pytest.raises(StopAsyncIteration):
        await items.__anext__()

    # test post-condition
    assert not socket.closed

# vim: sw=4:et:ai
