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

then the data can be uploaded with following command::

    bzip2 -dc < planet.osm.bz2 | osm2sql | psql db

Uploading can be performed while downloading the dataset::

    wget -O http://.../planet.osm.bz2 | tee planet.osm.bz2 | bzip2 -dc | osm2sql | psql db

.. vim: sw=4:et:ai
