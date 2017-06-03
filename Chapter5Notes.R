library(sp)
library(rgdal)
library(geospatial)
library(tmap)

# Use dir() to find directory name
dir()

# Call dir() with directory name
dir("nynta_16c")

# Read in shapefile with readOGR(): neighborhoods
neighborhoods <- readOGR('nynta_16c','nynta')

# summary() of neighborhoods
summary(neighborhoods)

# Plot neighboorhoods
plot(neighborhoods)

#NEXT EXCERCISE- I've modified this due to location of the data

library(raster) 

#Looks like the data is here
fldr <- 'C:/Users/JustinandAbigail/Desktop/GeoSpatialCourse/geospatial-master/data-raw'

# Call dir()
dir(fldr)

# Call dir() on the directory
nyc_grid_data_fldr <- paste(fldr,"nyc_grid_data", sep = '/')
dir(nyc_grid_data_fldr)

# Use raster() with file path: income_grid
rstr <- paste(nyc_grid_data_fldr, "m5602ahhi00.tif", sep = '/')
income_grid <- raster(rstr)

# Call summary() on income_grid
summary(income_grid)

# Call plot() on income_grid
plot(income_grid)

library(sp)
library(tigris)

# Call tracts(): nyc_tracts
nyc_tracts <- tracts(state = 'NY', county = "New York", cb = TRUE)

# Call summary() on nyc_tracts
summary(nyc_tracts)

# Plot nyc_tracts
plot(nyc_tracts)


proj4string(countries_spdf)

proj4string(water)

#NEXT EXCERCISE
library(sp)

# proj4string() on nyc_tracts and neighborhoods
proj4string(neighborhoods)
proj4string(nyc_tracts)


# coordinates() on nyc_tracts and neighborhoods
coordinates(head(neighborhoods))
coordinates(head(nyc_tracts))


# plot() neighborhoods and nyc_tracts
plot(neighborhoods)
plot(nyc_tracts, col='red', add = TRUE)

#NEXT EXCERCISE
library(sp)
library(raster)

# Use spTransform on neighborhoods: neighborhoods
spTransform(neighborhoods, CRS = proj4string(nyc_tracts))


# head() on coordinates() of neighborhoods
head(coordinates(neighborhoods))

# Plot neighborhoods, nyc_tracts and water
plot(neighborhoods)
plot(nyc_tracts, col = 'red', add = TRUE)
plot(water, add = TRUE, col = 'blue')

#NEXT EXCERCISE
library(sp)

# Use str() on nyc_income and nyc_tracts@data
str(nyc_income)
str(nyc_tracts@data)


# Highlight tract 002201 in nyc_tracts
plot(nyc_tracts)
plot(nyc_tracts[nyc_tracts$tract == "002201", ], 
     col = "red", add = TRUE)

#NEXT EXCERCISE
# Check for duplicates in nyc_income
any(duplicated(nyc_income$tract))

# Check for duplicates in nyc_tracts
any(duplicated(nyc_tracts$TRACTCE))

# Check nyc_tracts in nyc_income
all(nyc_tracts$TRACTCE %in% nyc_income$tract)

# Check nyc_income in nyc_tracts
all(nyc_income$tract %in% nyc_tracts$TRACTCE)


#NEXT EXCERCISE
library(sp)
library(tmap)

# Merge nyc_tracts and nyc_income: nyc_tracts_merge
nyc_tracts_merge <- merge(nyc_tracts, nyc_income, by.x = "TRACTCE", by.y = "tract")

# Call summary() on nyc_tracts_merge
summary(nyc_tracts_merge)

# Choropleth with col mapped to estimate
tm_shape(nyc_tracts_merge)+
  tm_fill(col = "estimate")

library(tmap)

tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  # Add a water layer, tm_fill() with col = "grey90"
  tm_shape(water)             +
  tm_fill(col = "grey90")              +
  # Add a neighborhood layer, tm_borders()
  tm_shape(neighborhoods)+
  tm_borders()

#NEXT EXCERCISE
library(tmap)

# Find unique() nyc_tracts_merge$COUNTYFP
unique(nyc_tracts_merge$COUNTYFP)

# Add logical expression to pull out New York County
manhat_hoods <- neighborhoods[neighborhoods$CountyFIPS == unique(nyc_tracts_merge$COUNTYFP) , ]

tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  # Edit to use manhat_hoods instead
  tm_shape(manhat_hoods) +
  tm_borders() +
  # Add a tm_text() layer
  tm_text("NTAName")

#NEXT EXCERCISE
library(tmap)

# gsub() to replace " " with "\n"
manhat_hoods[['name']] <- gsub(" ", '\n', manhat_hoods$NTAName) 

# gsub() to replace "-" with "/\n"
manhat_hoods[['name']] <- gsub("-", '/\n', manhat_hoods$name) 



# Edit to map text to name, set size to 0.5
tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  tm_shape(manhat_hoods) +
  tm_borders() +
  tm_text(text = "name", size = 0.5)


#NEXT EXCERCISE
tm_shape(nyc_tracts_merge) +
  # Add title and change palette
  tm_fill(col = "estimate", 
          title = "Median Income",
          palette = "Greens") +
  # Add tm_borders()
  tm_borders(col = "grey60", lwd = 0.5) +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  tm_shape(manhat_hoods) +
  # Change col and lwd of neighborhood boundaries
  tm_borders(col = 'grey40', lwd = 2) +
  tm_text(text = "name", size = 0.5) +
  # Add tm_credits()
  tm_credits("Source: ACS 2014 5-year Estimates, \n accessed via acs package",
             position = c("right", "bottom") )



# Save map as "nyc_income_map.png"
save_tmap(filename = "nyc_income_map.png", width = 4, height = 7)
