Database Schema
===============

osm_point
    OpenStreetMap point (node) data.
        id
            Point id.
        tags
            Point tags stored as hstore.
        location
            Point coordinates in WGS84.

osm_line
    OpenStreetMap line data (based on OSM waypoints).
        id
            Waypoint id.
        tags
            Waypoint tags stored as hstore.
        shape
            Waypoint linestring in WGS84.

osm_area
    OpenStreetMap area data (based on OSM waypoints).
        id
            Area id.
        tags
            Area tags stored as hstore.
        shape
            Area polygon in WGS84.

Indices
-------
idx_osm_point_t
    Tags index for point (node) data.
   
idx_osm_line_t
    Tags index for line (waypoint) data.

idx_osm_area_t
    Tags index for area (closed waypoint) data.

.. vim: sw=4:et:ai
