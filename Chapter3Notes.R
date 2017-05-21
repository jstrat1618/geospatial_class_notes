library(geospatial)
library(raster)
library(tmap)
library(ggplot2)
library(RColorBrewer)
library(viridisLite)
library(classInt)
data("pop")
data("pop_by_age")
data("preds")
data("migration")
data("land_cover")

# Print pop
print(pop)

# Call str() on pop, with max.level = 2
str(pop, max.level = 2)

# Call summary on pop
summary(pop)

#NEXT EXCERCISE
# Call plot() on pop
plot(pop)

# Call str() on values(pop)
str(values(pop))

# Call head() on values(pop)
head(values(pop))

#The raster package provides the RasterLayer object, but also a couple of more complicated objects: RasterStack and RasterBrick.
#These two objects are designed for storing many rasters, all of the same extents and dimension (a.k.a. multi-band, or multi-layer rasters).

#You can think of RasterLayer like a matrix, but RasterStack and RasterBrick objects are more like three dimensional arrays.

#You can use $ or [[ subsetting on a RasterStack or RasterBrick to grab one layer and return a new RasterLayer object
#For example, if x is a RasterStack, x$layer_name or x[["layer_name"]] will return a RasterLayer with only the layer called layer_name in it.

#Let's look at a RasterStack object called pop_by_age that covers the same area as pop but now contains layers for population broken into few different age groups.

#NEXT EXCERCISE
# Print pop_by_age
print(pop_by_age)

# Subset out the under_1 layer using [[
pop_by_age[['under_1']]

# Plot the under_1 layer
plot(pop_by_age[['under_1']])


#tmap also works with the raster package too.
#You simply pass your Raster___ object as the shp argument to the tm_shape() function, and then add a tm_raster() layer like this:
#there is also another package called rasterVis that is useful for plotting raster objects

#NEXT EXCERCISE
library(tmap)

# Specify pop as the shp and add a tm_raster() layer
tm_shape(pop) +
  tm_raster()

# Plot the under_1 layer in pop_by_age
tm_shape(pop_by_age)+
  tm_raster(col = "under_1")


library(rasterVis)
# Call levelplot() on pop
levelplot(pop)

#NEXT EXCERCISE
library(RColorBrewer)
# 9 steps on the RColorBrewer "BuPu" palette: blups
blups <- brewer.pal(n = 9, name = 'BuPu')

# Add scale_fill_gradientn() with the blups palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8)+
  scale_fill_gradientn(colors = blups)


library(viridisLite)
# viridisLite viridis palette with 9 steps: vir
vir <- viridis(n = 9)

# Add scale_fill_gradientn() with the vir palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8) +
  scale_fill_gradientn(colors = vir)

# mag: a viridisLite magma palette with 9 steps
mag <- magma(9)

# Add scale_fill_gradientn() with the mag palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8)+
  scale_fill_gradientn(colors = mag)

#NEXT EXCERCISE
# Generate palettes from last time
library(RColorBrewer)
blups <- brewer.pal(9, "BuPu")

library(viridisLite)
vir <- viridis(9)
mag <- magma(9)

# Use the blups palette
tm_shape(prop_by_age) +
  tm_raster("age_18_24",palette = blups) +
  tm_legend(position = c("right", "bottom"))

# Use the vir palette
tm_shape(prop_by_age) +
  tm_raster("age_18_24",palette = vir) +
  tm_legend(position = c("right", "bottom"))

# Use the mag palette but reverse the order
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = rev(mag)) +
  tm_legend(position = c("right", "bottom"))

#Let's look at this plot
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = vir) +
  tm_legend(position = c("right", "bottom"))
#Your plot was problematic because most of the proportions fell in the lowest color level and consequently you didn't see much detail in your plot. 

#NEXT EXCERCISE
mag <- viridisLite::magma(7)

library(classInt)

# Create 5 "pretty" breaks with classIntervals()
classIntervals(values(prop_by_age[["age_18_24"]]), n = 5, style = 'pretty')


# Create 5 "quantile" breaks with classIntervals()
classIntervals(values(prop_by_age[["age_18_24"]]), n = 5, style = 'quantile')



# Use 5 "quantile" breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag, n = 5, style = 'quantile') +
  tm_legend(position = c("right", "bottom"))

# Create histogram of proportions
hist(values(prop_by_age[["age_18_24"]]))

# Use fixed breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag,
            style = "fixed", breaks = c(0.025, 0.05, 0.1, 0.2, 0.25, 0.3, 1))

# Save your plot to "prop_18-24.html"
save_tmap(filename = 'prop_18-24.html')


#tmap chooses a diverging scale when there are both positive and negative values in the mapped variable and chooses zero as the midpoint. 
#This isn't always the right approach. 
#For example, Imagine you are mapping a relative change as percentages; 100% might be the most intuitive midpoint. 
#If you need something different, the best way to proceed is to generate a diverging palette (with an odd number of steps, so there is a middle color) and specify the breaks yourself.

#NEXT EXCERCISE
# Print migration
print(migration)

# Diverging "RdGy" palette
red_gray <- brewer.pal(n = 7, name = 'RdGy')

# Use red_gray as the palette 
tm_shape(migration) +
  tm_raster(palette = red_gray) +
  tm_legend(outside = TRUE, outside.position = c("bottom"))

# Add fixed breaks 
tm_shape(migration) +
  tm_raster(palette = red_gray, breaks = c(-5e6, -5e3, -5e2, -5e1, 5e1, 5e2, 5e3, 5e6), 
            style = "fixed") +
  tm_legend(outside = TRUE, outside.position = c("bottom"))

#NEXT EXCERCISE
library(raster)

# Plot land_cover
tm_shape(land_cover)+
  tm_raster()


# Palette like the ggplot2 default
hcl_cols <- hcl(h = seq(15, 375, length = 9), 
                c = 100, l = 65)[-9]

# Use hcl_cols as the palette
tm_shape(land_cover)+
  tm_raster(palette = hcl_cols)


# Examine levels of land_cover
levels(land_cover@data$cover_cls)

# A set of intuitive colors
intuitive_cols <- c(
  "darkgreen",
  "darkolivegreen4",
  "goldenrod2",
  "seagreen",
  "wheat",
  "slategrey",
  "white",
  "lightskyblue1"
)

# Use intuitive_cols as palette
tm_shape(land_cover)+
  tm_raster(palette = intuitive_cols)+
  tm_legend(position = c("left", "bottom"))


