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

from osmgeodb.socket import wait_empty_socket

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

# vim: sw=4:et:ai
