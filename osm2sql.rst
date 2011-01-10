The osm2sql script
==================
The osm2sql script converts OpenStreetMap data (OSM files) into SQL spatial
data. Both, uncompressed and compressed with bzip2 OpenStreetMap files are
supported.

The script supports 2nd step of the following workflow

- obtain spatial data
- upload spatial data into database
- convert spatial data from initial schema to database schema supported by
  an application

The advantage of the script is that very small amount of memory is being
used while uploading large OpenStreetMap files.

At the moment it was tested only with PostgreSQL 9.0.2 and Postgis 1.5.2.

Requirements
------------
The osm2sql Script
^^^^^^^^^^^^^^^^^^
#. Python 3.
#. The lxml library.

Database System
^^^^^^^^^^^^^^^
#. Database system has to support hstore datatype.
#. Database system has to be OpenGIS Simple Features specification compliant.

License
-------
The script is distributed under GPL version 3 license.

Usage
=====
#. Download OpenStreetMap data. The data can be obtained using instructions at

    http://wiki.openstreetmap.org/wiki/Planet.osm

#. Create spatial database.
#. Use osm2sql to upload the data.

For example, if using PostgreSQL and Postgis::

    createdb db
    psql -f $PGCONTRIB/hstore.sql
    psql -f $PGCONTRIB/postgis.sql
    psql -f $PGCONTRIB/spatial_ref_sys.sql 
    osm2sql data/planet.osm.bz2 | psql db

Database Schema
===============

osm_point
    OpenStreetMap point (node) data.

osm_line
    OpenStreetMap waypoint data.

Indices
-------
idx_osm_point_t
    Tags index for point (node) data.
    
idx_osm_line_t
    Tags index for line (waypoint) data.

.. vim: sw=4:et:ai
