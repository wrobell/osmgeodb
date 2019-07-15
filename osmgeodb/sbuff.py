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
Buffer to efficiently cache data and synchronize producer and consumer.

Producer extends buffer and blocks when the buffer is full. Consumer
consumes data when buffer becomes full and clears the buffer once the data
is processed. When producer is finished, then it closes the buffer allowing
consumer to finish as well.

It supports the following operations on producer side

extend
    Extend buffer with data items. Blocks buffer is full.
close
    Close buffer. Disallow the buffer to be extended anymore.

It supports the following operations and properties on consumer side

wait
    Block until buffer is full.
clear
    Clear buffer once its data is processed by consumer.
is_active
    Property indicating if buffer is *not* closed or still has data.
__iter__
    Iterate over buffer data.
"""

import asyncio
import typing as tp

T = tp.TypeVar('T')

class SynchronizedBuffer(tp.Generic[T]):
    """
    Synchronized buffer with maximum size.

    Buffer to efficiently cache data and synchronize producer and consumer.
    """
    def __init__(self, max_size: int):
        """
        Create instance of synchronized buffer.

        :param max_size: Maximum size of the buffer.
        """
        self.max_size = max_size
        self._data: tp.List[T] = []

        self._can_process = asyncio.Event()

        self._can_extend = asyncio.Event()
        self._can_extend.set()

        self._is_active: bool = True

    async def extend(self, items: tp.Iterator[T]):
        """
        Extend buffer with data.
        """
        await self._can_extend.wait()

        self._data.extend(items)
        if len(self._data) >= self.max_size:
            self._can_extend.clear()
            self._can_process.set()

    async def wait(self):
        """
        Wait until buffer is full.
        """
        await self._can_process.wait()
        self._can_process.clear()

    def clear(self):
        """
        Clear data from buffer.
        """
        self._data.clear()
        self._can_extend.set()

    @property
    def is_active(self) -> bool:
        """
        Check if buffer is active.
        """
        return self._is_active or bool(self._data)

    def close(self):
        """
        Close buffer.
        
        .. note::
           Buffer is active until it is cleared.
        """
        self._is_active = False
        self._can_process.set()

    def __iter__(self):
        return iter(self._data)

# vim: sw=4:et:ai
