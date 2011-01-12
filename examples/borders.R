require(RPostgreSQL)
library(rgeos)

q = sprintf("
select 
    id,
    st_astext(shape) as shape
from osm_line ol
where ((tags->'admin_level') = '2')")

cn = dbConnect(PostgreSQL(), dbname='pl')
d = dbGetQuery(cn, q)
coords = readWKT(paste("GEOMETRYCOLLECTION(", paste(d$shape, collapse=","), ")", sep=""))
data = SpatialLinesDataFrame(coords, d)

pdf('borders.pdf', title='Borders')
plot(data)
dev.off()

# vim: sw=4:et:ai
