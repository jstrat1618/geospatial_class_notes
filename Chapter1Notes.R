library(geospatial)
data(sales)
head(sales)


library(ggplot2)

#Ploting (lons, lats) doesn't really look all that great because they are  missing terriain
ggplot(sales, aes(lon, lat))+
  geom_point()#Not that great of a plot

#Instead we will use the ggmap package
library(ggmap)
#Get a map of NYC 
nyc <- c(lon = -74.0059, lat = 40.7128)

#Download the relevant map
nyc_map <- get_map(location = nyc, zoom = 10)

ggmap(nyc_map, extent = "normal")


#Excercise
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Get map at zoom level 5: map_5
map_5 <- get_map(corvallis, zoom = 5, scale = 1)

# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
corvallis_map <- get_map(corvallis, zoom = 13, scale = 1)

# Plot map at zoom level 13
ggmap(corvallis_map)


#NEXT Excercise
# Look at head() of sales
head(sales)


# Swap out call to ggplot() with call to ggmap()
# Look at head() of sales
head(sales)

# Swap out call to ggplot() with call to ggmap()
ggmap(corvallis_map) +
  geom_point(aes(lon, lat), data = sales)

#Next Excercise
# Map color to year_built
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Map size to bedrooms
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, size = bedrooms ), data = sales)

# Map color to price / finished_squarefeet
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, color = price / finished_squarefeet), data = sales)

#There are a variety of map types, you can see them in ?get_map under map type
#Note that certain map types come from certain sources. And no one sources provides all types.
#Google: "terrain", "terrain-background", "satellite", "roadmap", "hybrid"
#"stamen: "terrain", "toner", "watercolor", "terrain-labels", "terrain-lines","toner-2010", "toner-2011", "toner-background", "toner-hybrid","toner-labels", "toner-lines", "toner-lite"
#osm: stands for "Open Street Map" and  only has 1 map type and does need a type specified


#NEXT EXCERCISE
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add a maptype argument to get a satellite map
corvallis_map_sat <- get_map(corvallis, zoom = 13, maptype = 'satellite')

# Edit to display satellite map
ggmap(corvallis_map_sat) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Add source and maptype to get toner map from Stamen Maps
corvallis_map_bw <- get_map(corvallis, zoom = 13, source = 'stamen', maptype = 'toner')

# Edit to display toner map
ggmap(corvallis_map_bw) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

## Use base_layer argument to ggmap() to specify data and x, y mappings
ggmap(corvallis_map_bw,
      base_layer = ggplot(sales, aes(lon, lat)))+
        geom_point(aes(color = year_built))

# Use base_layer argument to ggmap() and add facet_wrap()
ggmap(corvallis_map_bw,
      base_layer = ggplot(sales, aes(lon, lat)))+
  facet_wrap(~class)+
  geom_point(aes(color = class))

#Next excercise
# Plot house sales using qmplot()
qmplot(lon, lat, color = bedrooms, geom = 'point',  data = sales)+
  facet_wrap(~month)

#New data set
data("ward_sales")
head(ward_sales) #This is polygon data data
#Note the summary data (num_sales, avg_price, avg_finished_squarefeet) is repeated for points within the polygon


# Add a point layer with color mapped to ward
ggplot(ward_sales, aes(lon, lat)) +
  geom_point(aes(color = ward))

# Add a point layer with color mapped to group
ggplot(ward_sales, aes(lon, lat))+
  geom_point(aes(color = group))

# Add a path layer with group mapped to group
ggplot(ward_sales, aes(lon, lat))+
  geom_path(aes(group = group))

# Add a polygon layer with fill mapped to ward, and group to group
ggplot(ward_sales, aes(lon, lat))+
  geom_polygon(aes(fill = ward, group = group))

#Mapping the wards on top of the corvalis map- the WRONG WAY
ggmap(corvallis_map_bw,
      base_layer = ggplot(ward_sales,
                          aes(lon, lat))) +
  geom_polygon(aes(group = group, fill = ward))
#Uh oh, things don't look right. Wards 1, 3 and 8 look jaggardy and wrong. What's happened? Part of the ward boundaries are beyond the map boundary. Due to the default settings in ggmap(), any data off the map is dropped before plotting, so some polygon boundaries are dropped and when the remaining points are joined up you get the wrong shapes.
#Don't worry, there is a solution: ggmap() provides some arguments to control this behaviour. Arguments extent = "normal" along with maprange = FALSE force the plot to use the data range rather than the map range to define the plotting boundaries.


#Next excercise
# Fix the polygon cropping
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = ward))

# Repeat, but map fill to num_sales
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = num_sales))

# Repeat again, but map fill to avg_price
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = avg_price), alpha = 0.8)


#New data set 
data("preds")
head(preds)

# Add a geom_point() layer
ggplot(preds, aes(lon, lat))+
  geom_point()

# Add a tile layer with fill mapped to predicted_price
ggplot(preds, aes(lon, lat))+
  geom_tile(aes(fill = predicted_price))

# Use ggmap() instead of ggplot()
ggmap(corvallis_map_bw)+
  geom_tile(mapping = aes(x = lon, y = lat, fill = predicted_price),  
            alpha = 0.8, data = preds)
  


