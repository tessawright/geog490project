install.packages("raster")
install.packages("ncdf4")
install.packages("rasterVis")
install.packages("ggplot2")

library(rasterVis)
library(raster)
library(ncdf4)
library(ggplot2)

setwd("/Users/tessawright/Documents/geog490/data/")

veg_data <- nc_open("sage_veg30.nc")
fire_data <- nc_open("us_fires.nc")

#ncin <- nc_open(veg_data)
print(veg_data)
#ncin <- nc_open(fire_data)
print(fire_data)

veg_data <- raster("sage_veg30.nc")
fire_data <- raster("us_fires.nc")

levelplot(veg_data, main = "Vegetation Data")
levelplot(fire_data, main = "Fire Data")

us_extent <- extent(-125, -66.5, 24, 49) 
veg_data_us <- crop(veg_data, us_extent)
fire_data_us <- crop(fire_data, us_extent)

fire_data_binary <- as.integer(fire_data_us > 0)

##plot(affected_veg, main = "Areas of Reduced Vegetation due to Fires in the US") 
#add GGPLOT MAPS 2

affected_veg_df <- as.data.frame(affected_veg, xy = TRUE)
names(affected_veg_df) <- c("x", "y", "affected_veg")

ggplot(affected_veg_df, aes(x = x, y = y, fill = affected_veg)) +
  geom_raster() +
  scale_fill_gradient(name = "Affected Vegetation", low = "green", high = "red") +
  labs(title = "Areas of Reduced Vegetation due to Fires in the US", 
       x = "Longitude (degrees)",
       y = "Latitude (degrees)") +
  theme_minimal()

coord_fixed(ratio = 5.5) 
ggsave("map_plot.png", width = 10, height = 6, units = "in", dpi = 300)
