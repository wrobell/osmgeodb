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

"""
Unit tests for synchronized buffer.
"""

from ..sbuff import SynchronizedBuffer

import pytest

@pytest.mark.asyncio
async def test_buffer_extend():
    """
    Test extending buffer with data. Buffer is not full.
    """
    buff = SynchronizedBuffer(5)
    await buff.extend(range(1, 4))
    assert [1, 2, 3] == buff._data
    assert buff.is_active
    assert not buff._can_process.is_set()
    assert buff._can_extend.is_set()

@pytest.mark.asyncio
async def test_buffer_extend_full():
    """
    Test extending buffer with data. Buffer is full
    """
    buff = SynchronizedBuffer(5)
    await buff.extend(range(5))
    assert [0, 1, 2, 3, 4] == buff._data
    assert buff.is_active
    assert buff._can_process.is_set()
    assert not buff._can_extend.is_set()

@pytest.mark.timeout(3)
@pytest.mark.asyncio
async def test_buffer_process_on_close():
    """
    Test if buffer data can be processed after it was closed.
    """
    buff = SynchronizedBuffer(5)
    await buff.extend(range(5))
    buff.close()

    # there is still data in the buffer, so it is active
    assert buff.is_active
    # ... processing data...

    # clear to fully close the buffer
    buff.clear()
    assert not buff.is_active

# vim: sw=4:et:ai
