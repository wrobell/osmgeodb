Introduction
============
The osm2sql script converts OpenStreetMap data (OSM files) into SQL spatial
data.

The script supports 2nd step of the following workflow

- obtain spatial data
- upload spatial data into database
- convert spatial data from initial schema to database schema supported by
  an application

The advantage of the script is that very small amount of memory is being
used while uploading large OpenStreetMap files.

At the moment it was tested only with PostgreSQL 9.0.2 and Postgis 1.5.2.

Database Schema
===============

osm_point
    OpenStreetMap point (node) data.

_osm_line
    OpenStreetMap waypoint data. Point are referenced via point identifier.

osm_line
    OpenStreetMap line (waypoint) spatial data. Points (nodes) are not referenced.

Indices
-------
idx_osm_point_t
    Tags index for point (node) data.
    
idx_osm_line_t
    Tags index for line (waypoint) data.

.. vim: sw=4:et:ai
