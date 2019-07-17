.. contents::

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

The advantage of the script is that appropriate amount of memory is being
used for given hardware configuration while uploading large OpenStreetMap
files by the script itself.

At the moment it was tested only with PostgreSQL 9.0.2 and Postgis 1.5.2.

*The script is distributed under version 3 of GPL license.*

Requirements
------------
Software
^^^^^^^^
#. Python 3.
#. The lxml library.

Database System
^^^^^^^^^^^^^^^
#. Database system has to support hstore-like datatype.
#. Database system has to be OpenGIS Simple Features specification compliant.

Hardware
^^^^^^^^
10GB of disk space is required to create an index for osm2sql processing.
This does not specify amount of space required for database being a result
of such processing.

.. vim: sw=4:et:ai
