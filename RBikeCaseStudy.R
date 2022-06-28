library(tidyverse)
library(lubridate)
library(janitor)
library(dplyr)
library(ggplot2)

DivvyTable <- DivvyTable %>%  
  select(-c(end_station_name)) #remove irrelevant columns not vital for analysis

View(DivvyTable)

colnames(DivvyTable) #List column names
head(DivvyTable) #First 6 rows of data frame
summary(DivvyTable) #inspect date and dimensions before moving onto cleaning
str(DivvyTable) #view columns and datatypes


DivvyTable <- DivvyTable[complete.cases(DivvyTable), ] #remove any null values

#Adding columns for date and time
DivvyTable$date <- as.Date(DivvyTable$started_at)
DivvyTable$month <- format(as.Date(DivvyTable$date), "%m")
DivvyTable$day <- format(as.Date(DivvyTable$date), "%d")
DivvyTable$year <- format(as.Date(DivvyTable$date), "%Y")
DivvyTable$day_of_week <- format(as.Date(DivvyTable$date), "%A")
DivvyTable$time <- format(DivvyTable$started_at, format= "%H:%M")
DivvyTable$time <- as.POSIXct(DivvyTable$time, format= "%H:%M") # date-time conversion

#isolating time spent on every ride
DivvyTable$ride_length <- (as.double(difftime(DivvyTable$ended_at, DivvyTable$started_at))) / 60

str(DivvyTable)

summary(DivvyTable) #observing new column

#Analyze data
aggregate(DivvyTable$ride_length ~ DivvyTable$member_casual, FUN = mean)
aggregate(DivvyTable$ride_length ~ DivvyTable$member_casual, FUN = median)
aggregate(DivvyTable$ride_length ~ DivvyTable$member_casual, FUN = max)
aggregate(DivvyTable$ride_length ~ DivvyTable$member_casual, FUN = min)

#creating days of the week
DivvyTable$day_of_week <- ordered(DivvyTable$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

DivvyTable %>%
  mutate(day_of_week = wday(started_at, label = TRUE)) %>% #create weekday
  group_by(member_casual, day_of_week ) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n())

#Remaining code: Data Visualization

DivvyTable$day_of_week  <- format(as.Date(DivvyTable$date), "%A")
DivvyTable %>%                              #total rides broken down by weekday
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()) %>% 
  arrange(member_casual, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x='Day of Week', y='Total Number of Rides', title='Rides per Day of Week', fill = 'Type of Membership') + 
  scale_y_continuous(breaks = c(250000, 400000, 550000), labels = c("250K", "400K", "550K"))

DivvyTable %>%   #total rides broken down by month
  group_by(member_casual, month) %>%  
  summarise(total_rides = n(),`average_duration_(mins)` = mean(ride_length)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x=month, y=total_rides, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x= "Month", y= "Total Number of Rides", title = "Rides per Month", fill = "Type of Membership") + 
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000), labels = c("100K", "200K", "300K", "400K")) + theme(axis.text.x = element_text(angle = 360))

DivvyTable %>% #observing breakdown of different type of bikes rented
  ggplot(aes(x = rideable_type, fill = member_casual)) + geom_bar(position = "dodge") +
  labs(x= 'Type of Bike', y= 'Number of Rentals', title = 'Which bike works the most', fill= 'Type of Membership') +
  scale_y_continuous(breaks = c(500000, 1000000, 1500000), labels = c("500K", "1Mil", "1.5Mil"))

DivvyTable %>% #Find average time spent riding, each membership  per day
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") + labs(x='Days of the week', y='Average duration - Hrs', title='Average ride time per week', fill='Type of Membership')


View(DivvyTable)



write.csv(DivvyTable, "/Users/gregorygreen/DivvyTable.csv")
