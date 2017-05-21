library(sp)
library(geospatial)
library(tmap)
data("countries_sp")
data("countries_spdf")
data('Europe')

# Print countries_sp
print(countries_sp)

# Call summary() on countries_sp
summary(countries_sp)

# Call plot() on countries_sp
plot(countries_sp)


class(countries_sp)

# Call str() on countries_sp
str(countries_sp)

# Call str() on countries_sp with max.level = 2
str(countries_sp, max.level = 2)


#sp classes are S4 objects and hence their elements are accessed via the "@" sign

data("countries_spdf")

# Call summary() on countries_spdf and countries_sp
summary(countries_spdf)


# Call str() with max.level = 2 on countries_spdf
str(countries_spdf, max.level = 2)

# Plot countries_spdf
plot(countries_spdf)



#NEXT EXCERCISE
# 169th element of countries_spdf@polygons: one
one <- countries_spdf@polygons[[169]]

# Print one
print(one)

# Call summary() on one
summary(one)

# Call str() on one with max.level = 2
str(one, max.level = 2)

#NEXT EXCERCISE
one <- countries_spdf@polygons[[169]]

# str() with max.level = 2, on the Polygons slot of one
str(one@Polygons, max.level = 2)

# str() with max.level = 2, on the 6th element of the one@Polygons
str(one@Polygons[[6]], max.level = 2)

# Call plot on the coords slot of 6th element of one@Polygons
plot(one@Polygons[[6]]@coords)


#NEXT EXCERCISE
# Subset the 169th object of countries_spdf: usa
usa <- countries_spdf[169, ]

# Look at summary() of usa
summary(usa)

# Look at str() of usa
str(usa, max.level = 2)

# Call plot() on usa
plot(usa)

#NEXT EXCERCISE
# Call head() and str() on the data slot of countries_spdf
head(countries_spdf@data)
str(countries_spdf@data)

# Pull out the name column using $
countries_spdf$name

# Pull out the subregion column using [[
countries_spdf[['subregion']]


#NEXT EXCERCISE
# Create logical vector: is_nz
is_nz <- countries_spdf$name == 'New Zealand'

# Subset countries_spdf using is_nz: nz
nz <- countries_spdf[is_nz,]

# Plot nz
plot(nz)

#NEXT EXCERCISE
library(tmap)
qtm(shp = countries_spdf, fill = "population")


tm_shape(Europe)+ #Specfifies the data without displaying it (like ggplot function)
  tm_borders() #Add layer to draw borders of each country

  
tm_shape(Europe)+ #Specfifies the data without displaying it (like ggplot function)
  tm_borders()+ #Add layer to draw borders of each country
  tm_fill(col = 'part')+ #Unlike ggplot2 variables are referenced in quotes
  tm_compass()+ #Non-data variables - just adds a compass
  tmap_style('cobalt')

#other useful functions include: tm_fill(), tm_borders(), tm_polygons(), 
#tm_bubbles(), tm_dots(), tm_lines, tm_raster(), tm_text()


#NEXT EXCERCISE
# Add style argument to the tm_fill() call
tm_shape(countries_spdf) +
  tm_fill(col = "population", style = 'quantile') +
  # Add a tm_borders() layer 
  tm_borders(col = 'burlywood4')
  
  
# New plot, with tm_bubbles() instead of tm_fill()
tm_shape(countries_spdf) +
  tm_bubbles(size  = "population") +
  # Add a tm_borders() layer 
  tm_borders(col = 'burlywood4')

#NEXT EXCERCISE
# Switch to a Hobo–Dyer projection
tm_shape(countries_spdf, projection = 'hd') +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Switch to a Robinson projection
tm_shape(countries_spdf, projection = 'robin') +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Add tm_style_classic() to your plot
tm_shape(countries_spdf, projection = 'robin') +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") +
  tm_style_classic()

#NEXT EXCERCISE
#Saving maps
save_tmap(filename = 'population.png')
save_tmap(filename = "population.html")

