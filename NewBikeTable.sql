-- SQLite
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from(
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "May 22 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "April 22 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "March 22 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "February 22 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "January 22 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "December 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "November 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "October 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "September 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "August 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "July 21 Trip"
    union all
    select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual from "June 21 Trip")