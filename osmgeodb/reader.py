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
import msgpack
import struct
import uvloop
import zlib
import zmq

from functools import partial
from zmq.asyncio import Context

from osmgeodb.osm_pb2 import BlobHeader, Blob, HeaderBlock
from osmgeodb.mpack import m_pack

def read_data(f):
    result = None

    pos = f.tell()
    size_raw = f.read(4)
    if size_raw:
        assert len(size_raw) == 4
        size = struct.unpack('!L', size_raw)[0]

        header = BlobHeader()
        header.ParseFromString(f.read(size))
        msg = Blob()
        msg.ParseFromString(f.read(header.datasize))

        result = pos, msg.zlib_data

    return result

def read_messages(f):
    pos, data = read_data(f)
    header = HeaderBlock()
    header.ParseFromString(zlib.decompress(data))
    assert 'OsmSchema-V0.6' in header.required_features
    assert 'DenseNodes' in header.required_features

    read = partial(read_data, f)
    messages = iter(read, None)
    yield from messages

# vim: sw=4:et:ai
