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

import asyncpg
import shapely.geometry
import shapely.wkb

async def store_data(dsn, queue):
    conn = await asyncpg.connect(dsn)
    await setup_types(conn)

    try:
        async with conn.transaction():
            while True:
                items = await queue.get()
                if items is None:
                    break

                await conn.copy_records_to_table(
                    'osm_point',
                    columns=('id', 'location', 'tags'),
                    records=items
                )
    finally:
        await conn.close()

async def setup_types(conn):
    # hstore type support
    await conn.set_builtin_type_codec('hstore', codec_name='pg_contrib.hstore')

    # PostGIS support
    await conn.set_type_codec(
        'geometry',  # also works for 'geography'
        encoder=encode_geometry,
        decoder=decode_geometry,
        format='binary',
    )

def encode_geometry(geometry):
    return shapely.wkb.dumps(geometry, srid=4326)

def decode_geometry(wkb):
    return shapely.wkb.loads(wkb)

# vim: sw=4:et:ai
