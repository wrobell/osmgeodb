require(RPostgreSQL)
library(rgeos)

q = sprintf("
select 
    id,
    (tags->'name'),
    st_astext(shape) as shape
from osm_area
where ((tags->'natural') = 'water')")

cn = dbConnect(PostgreSQL(), dbname='pl')
d = dbGetQuery(cn, q)
coords = readWKT(paste('GEOMETRYCOLLECTION(', paste(d$shape, collapse=','), ')', sep=''))
data = SpatialPolygonsDataFrame(coords, d)

pdf('water.pdf', title='Water')
plot(data)
dev.off()

# vim: sw=4:et:ai
