require(RPostgreSQL)
require(rpostgis)
library(sp)

cn = dbConnect(PostgreSQL(), dbname='osmgeodb-planet', port=6432)
data = pgGetGeom(
    cn,
    gid='id',
    geom='location',
    query="select id, tags -> 'name' as name, location from osm_point where tags @> 'capital => yes'"
)

cairo_pdf('borders.pdf', width=16, height=8)
plot(data, pch=16, col='blue', cex=0.75)
invisible(text(
    coordinates(data),
    labels=as.character(data$name),
    cex=0.5,
    pos=4,
    offset=0.3
))
dev.off()

# vim: sw=4:et:ai
