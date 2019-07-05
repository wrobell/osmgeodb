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

from shapely.geometry import Point

from ._parser import parse_tags, cumsum, decode_coord

# list of tags copied from osm2pgsql project default style
TAGS = {
    'abandoned:aeroway',
    'abandoned:amenity',
    'abandoned:building',
    'abandoned:landuse',
    'abandoned:power',
    'access',
    'addr:housename',
    'addr:housenumber',
    'addr:interpolation',
    'admin_level',
    'aerialway',
    'aeroway',
    'amenity',
    'area',
    'area:highway',
    'barrier',
    'bicycle',
    'boundary',
    'brand',
    'bridge',
    'building',
    'capital',
    'construction',
    'covered',
    'culvert',
    'cutting',
    'denomination',
    'disused',
    'ele',
    'embankment',
    'foot',
    'generator:source',
    'harbour',
    'highway',
    'historic',
    'horse',
    'intermittent',
    'junction',
    'landuse',
    'layer',
    'leisure',
    'lock',
    'man_made',
    'military',
    'motorcar',
    'name',
    'natural',
    'office',
    'oneway',
    'operator',
    'place',
    'population',
    'power',
    'power_source',
    'public_transport',
    'railway',
    'ref',
    'religion',
    'route',
    'service',
    'shop',
    'sport',
    'surface',
    'toll',
    'tourism',
    'tower:type',
    'tracktype',
    'tunnel',
    'water',
    'waterway',
    'way_area',
    'wetland',
    'width',
    'wood',
    'z_order',
}


def parse_dense_nodes(block, data):
    granularity = block.granularity
    lon_offset = block.lon_offset
    lat_offset = block.lat_offset

    ids = cumsum(data.id)
    lons = decode_coord(data.lon, granularity, lon_offset)
    lats = decode_coord(data.lat, granularity, lat_offset)

    tags = parse_tags(TAGS, data.keys_vals, block.stringtable.s)

    items = zip(ids, lons, lats, tags)

    # store those positions, which have tags
    return [(id, Point(lon, lat), meta) for id, lon, lat, meta in items if meta]

# vim: sw=4:et:ai
