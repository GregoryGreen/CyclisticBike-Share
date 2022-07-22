library(tidyverse)
library(skimr)
library(lubridate)
library(janitor)
library(scales)
library(ggplot2)
library(mapview)

# Combine every dataset to consolidate analysis

trip22_June <- read.csv("/Users/gregorygreen/Downloads/202206-divvy-tripdata.csv")
trip22_May <- read.csv("/Users/gregorygreen/Downloads/202205-divvy-tripdata.csv")
trip22_Apr <- read.csv("/Users/gregorygreen/Downloads/202204-divvy-tripdata.csv")
trip22_Mar <- read.csv("/Users/gregorygreen/Downloads/202203-divvy-tripdata.csv")
trip22_Feb <- read.csv("/Users/gregorygreen/Downloads/202202-divvy-tripdata.csv")
trip22_Jan <- read.csv("/Users/gregorygreen/Downloads/202201-divvy-tripdata.csv")
trip21_Dec <- read.csv("/Users/gregorygreen/Downloads/202112-divvy-tripdata.csv")
trip21_Nov <- read.csv("/Users/gregorygreen/Downloads/202111-divvy-tripdata.csv")
trip21_Oct <- read.csv("/Users/gregorygreen/Downloads/202110-divvy-tripdata.csv")
trip21_Sept <- read.csv("/Users/gregorygreen/Downloads/202109-divvy-tripdata.csv")
trip21_Aug <- read.csv("/Users/gregorygreen/Downloads/202108-divvy-tripdata.csv")
trip21_July <- read.csv("/Users/gregorygreen/Downloads/202107-divvy-tripdata.csv")

BikeShareTable <- rbind(trip22_June, trip22_May, trip22_Apr, trip22_Mar, trip22_Feb, trip22_Jan, trip21_Dec, 
trip21_Nov, trip21_Oct, trip21_Sept, trip21_Aug, trip21_July)

write.csv(BikeShareTable, "/Users/gregorygreen/BikeShareTable.csv", row.names = FALSE)

View(BikeShareTable)

# Understand data types of the newly created data frame
glimpse(BikeShareTable)

# Statistical evaluation
#BikeShareTable %>%
#  skim()

# Data Cleaning:


BikeShareTableClean = BikeShareTable %>% 
  remove_empty(which = c("cols", "rows")) %>% 
  clean_names()

# Transforming data types
BikeShareTable_1 = BikeShareTable %>% 
  mutate(
    start_lat = as.numeric(start_lat),
    start_lng = as.numeric(start_lng),
    end_lat = as.numeric(end_lat),
    end_lng = as.numeric(end_lng)
  )

glimpse(BikeShareTable_1)


colSums(is.na(BikeShareTable_1))

# Evaluate statistical summary
BikeShareTable_1 %>%
  summary()

# Format date-time columns
BikeShareTable_2 = BikeShareTable_1 %>%
  mutate(
    started_at = ymd_hms(as_datetime(started_at)),
    ended_at = ymd_hms(as_datetime(ended_at))
  )
glimpse(BikeShareTable_2)

# Creating additional columns from started_at dat-time column

BikeShareTable_3 = BikeShareTable_2 %>%
  mutate(
    hour_start = hour(started_at),
    weekday = wday(started_at, label = T, abbr = F),
    month = month(started_at, label = T, abbr = F),
    day = day(started_at),
    week = strftime(started_at, format = "%V"),
    trip_time = difftime(ended_at, started_at, units = "mins")
  )

glimpse(BikeShareTable_3)

# Convert bike and ride types

BikeShareTable_4 = BikeShareTable_3 %>%
  mutate(
    rideable_type = recode(as_factor(rideable_type),
                           "classic_bike" = "classic",
                           "electric_bike" = "electric",
                           "docked_bike" = "docked"),
    member_casual = as_factor(member_casual)
  )
glimpse(BikeShareTable_4)

BikeShareTable_4 = BikeShareTable_4 %>%
  rename(
    bikes = rideable_type,
    users = member_casual
  )

#BikeShareTable_4 %>% 
  #get_dupes(ride_id) %>% 
  #tally()
View(BikeShareTable_4)

# Create new data frame
BikeShareTable_5 = BikeShareTable_4 %>%
  filter(
    between(trip_time, 1, 1440)
  )

str(BikeShareTable_5)

head(BikeShareTable_5, 10)

trips_time_df = BikeShareTable_5 %>%
  drop_na(
    end_lat, end_lng
  ) %>% 
  select(
    ride_id, users, bikes, hour_start, weekday, month, day, week, trip_time
  )
colSums(is.na(trips_time_df))
View(trips_time_df)

# Create dataframe with location variables

trips_location_df = BikeShareTable_5 %>% 
  select(
    ride_id, start_station_name, end_station_name, start_lat, start_lng,
    end_lat, end_lng, users, trip_time
  ) %>% 
  drop_na(
    start_station_name, end_station_name
  )

colSums(is.na(trips_location_df))


# Data Visualization

newtheme <- theme_light() + 
  theme(plot.title = element_text(color = "#002949", face = 'bold', size =12),
        plot.subtitle = element_text(color = "#890000", size = 10),
        plot.caption = element_text(color = '#890000', face = 'italic', size =8),
        panel.border = element_rect(color = "#002949", size = 1),
        legend.position = "right",
        legend.text = element_text(colour="blue", size=10, face="bold"),
        legend.title = element_text(colour="blue", size=10, face="bold"),
        #legend.position='none',
        axis.title.x = element_text(colour = "#890000"),
        axis.title.y = element_text(colour = "#002949"),
        axis.text.x = element_text(angle = 45, hjust = 1, color = '#890000'),
        axis.text.y = element_text(angle = 45, hjust = 1, color = '#002949'),
        axis.line = element_line(color = "#002949", size =1),
  )

theme_set(newtheme)

# Create new summarisation variables nr_rides, average_trip, total trip grouped by users type and start hour

ride_hours = 
  trips_time_df %>% 
  group_by(
    users, hour_start
  ) %>% 
  summarise(
    nr_rides = n(),
    average_trip = mean(trip_time),
    total_trip = sum(trip_time)
  )

# Visualize average number of trips per hour
ride_hours %>% 
  ggplot(aes(hour_start, average_trip, fill = users))+ 
  geom_col(position = "dodge")+ 
  scale_y_continuous()+
  labs(
    title = "Average Number of Trips per Hour",
    subtitle = "Number of trips for every hour segmented by users",
    caption = "Figure 2",
    x = "hour of the day",
    y = "average trips duration",
  )+
  theme()

# Analysis: days of the week

ride_week = trips_time_df %>% 
  group_by(
    users, weekday
  ) %>% 
  summarise(
    nr_rides_week = n(),
    avg_rides_week = mean(trip_time),
    total_duration_week = sum(trip_time)
  )

# Visualize average trips time by day of the week
ride_week %>% 
  ggplot(aes(weekday, avg_rides_week, fill = users))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(
    title = "Average Trips Time by Week Days and Segmented by Users",
    subtitle = "Average Number of trips for every week of the year",
    caption = "Fig 5",
    x = "day of the week",
    y = " avg number of trips"
  )+
  theme()

# Visualize total trips time by day of the week
ride_week %>% 
  ggplot(aes(weekday, total_duration_week, fill = users))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(
    title = "Total Time Trips by Week Days and Segmented by Users",
    subtitle = "Total Trips Time for every week of the year",
    caption = "Fig 6",
    x = "day of the week",
    y = " total time trips"
  )+
  theme()

# Analysis: trip time by month
ride_month = trips_time_df %>% 
  group_by(
    users, month
  ) %>% 
  summarise(
    nr_rides_month = n(),
    avg_rides_month = mean(trip_time),
    total_time_month = sum(trip_time)
  )

# Visualize Total trips time by month
ride_month %>% 
  ggplot(aes(month, nr_rides_month, fill = users))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(
    title = "Number of Trips by Month and Segmented by Users",
    subtitle = "Number Trips Time for every Month",
    caption = "Fig 7",
    x = "month",
    y = " number of trips"
  )+
  theme()


# Analysis: type of bikes

ride_bikes = trips_time_df %>% 
  group_by(
    users, bikes
  ) %>% 
  summarise(
    nr_bike_ride = n(),
    avg_bike_ride = mean(trip_time),
    total_time_month = sum(trip_time)
  )

# Visualize number of rides by bike type
ride_bikes %>% 
  ggplot(aes(bikes,nr_bike_ride, fill = users))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(
    title = "Number of Trips per Bike Type and Segregated by Users",
    subtitle = "Number of trips per bike type",
    caption = "Fig 15",
    x = "bike type",
    y = "number of trips"
  )+
  theme()

# Visualize average trip time by bike type
ride_bikes %>% 
  ggplot(aes(bikes, avg_bike_ride, fill = users))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(
    title = "Average trip time per Bike Type and Segregated by Users",
    subtitle = "Average trip time per bike type",
    caption = "Fig 16 - Paul Juverdeanu",
    x = "bike type",
    y = "average trip time"
  )+
  theme()

# Analysis: Popular start stations
pop_start_station = trips_location_df %>% 
  group_by(
    users, start_station_name, start_lat, start_lng
  ) %>% 
  summarise(
    nr_rides_start = n()
  ) %>% 
  arrange(-nr_rides_start)

head(pop_start_station)

# Visualize the most popular 10 start stations
pop_start_station[1:10, ] %>% 
  ggplot(aes(start_station_name, nr_rides_start, fill = users))+
  geom_col(position = "dodge")+
  coord_flip()+
  labs(
    title = "Most Popular Start Stations",
    subtitle = "Top 10 most popular start stations",
    caption = "Fig 18 - Paul Juverdeanu",
    x = "station name",
    y = "number of trips"
  )+
  theme()


# Visualize the most popular 10 end stations
pop_end_station = trips_location_df %>% 
  group_by(
    users, end_station_name, end_lat, end_lng
  ) %>% 
  summarise(
    nr_rides_end = n()
  ) %>% 
  arrange(-nr_rides_end)

# Visualize the most popular 10 end stations
pop_end_station[1:10,] %>% 
  ggplot(aes(end_station_name, nr_rides_end, fill = users))+
  geom_col(position = "dodge")+
  coord_flip()+
  labs(
    title = "Most Popular End Stations Segmented by Users",
    subtitle = "Top 10 most popular end stations",
    caption = "Fig 19",
    x = "station name",
    y = "number of trips"
  )+
  theme()


# Mapview of the most popular 30 start stations
pop_start_station[1:30, ] %>%
  mapview(
    xcol = "start_lng", 
    ycol = "start_lat",
    cex = "nr_rides_start",
    alpha = 0.9, 
    crs = 4269,
    color = "#8b0000",
    grid = F, 
    legend = T,
    layer.name = "30 Most Popular Start Stations"
  )

# Mapview of the most popular 30 end stations
pop_end_station[1:30,] %>% 
  mapview(
    xcol = "end_lng",
    ycol = "end_lat",
    cex = "nr_rides_end", # size of circle based on value size
    alpha = 0.9,
    crs = 4269,
    color = "#8b0000",
    grid = F,
    legend = T,
    layer.name = "30 Most Popular End Stations"
  )


