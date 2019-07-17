Performance
===========
To process OpenStreetMap XML file format point index is created on a disk
by osm2sql script. This allows to create lines and areas from OSM waypoint
data.

The amount of RAM affects the performance of the processing. More memory
allows to cache more of the data contained in the point index and therefore
faster access to items in the index.

With commodity hardware (i.e. up to 4GB of RAM) big part of point index
cannot be cached and has to be read from a disk. The **disk latency** (seek
time) greatly affects the performance of the osm2sql script. A typical
IDE/SATA hard drive is one of the worst solutions.  SCSI hard drives in
RAID-O configuration might help (not tested). Simple, 16GB USB key (flash
memory) can speed up the processing 4-5 times, i.e. during performance
testing with European dataset, the processing time was reduced from 24h
(SATA HDD) to 5.5 hours (USB key). SSD hard drive probably will be even
better.

While the script is single threaded, the amount of CPUs (CPUs cores) and
their capabilities (i.e. HyperThreading) affect the performance of the
whole workflow, i.e. each of the steps like the decompression of OSM data,
osm2sql processing and upload to a database are performed in separate
processes and will utilize multicore or/and multiprocessor hardware
architecture.

.. vim: sw=4:et:ai
