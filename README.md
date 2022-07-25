# CASE STUDY: BIKE-SHARE

**Background**

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geo-tracked and locked into a network of 692 stations across Chicago.

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.


**Scenario**

“You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members.
But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.”
Riders who pay for an annual membership are more profitable than casual riders, according to data research.
The marketing department is considering developing a campaign to entice casual passengers to become members.
The team wants to look at the Cyclistic historical bike trip data to see whether there are any patterns in how casual and member users use bikes.


**Business Objective**

Through a targeted marketing approach, to improve revenue by converting casual riders into annual members.

**Business Task**

The junior analyst has been tasked with answering the following question:
“How do annual members and casual riders use Cyclistic bikes differently?”

**Data sources**

User data from the past 12 months, July 2021 - June 2022 has been made available. Each data set is in csv format and details every ride logged by Cyclistic customers. This data has been made publicly available via license by Motivate International Inc. and the city of Chicago available here. All user’s personal data has been scrubbed for privacy.

The data used in this project can be found here:
https://divvy-tripdata.s3.amazonaws.com/index.html


**What tools I choosed and Why**

I used SQL to combine all 12 datasets and removed some columns that won't be needed. I used RStudio Desktop to analyse, clean and perform summarisations for this project was too large for RStudio Cloud. Tableau was the perfect tool to create several meaningful visualizations.

Identified the following abnormalities:

Missing values in the start and end stations variables


**What does the data tell us?**

Casual riders tended to ride more so in the warmer months of Chicago as expected, namely June- August. Their participation exceeded that of the long term members.

The days of the week also further shows that causal riders prefer to use the service during the weekends as their usage peaked then. The long term members conversly utilised the service more-so throughout the typical work week i.e (Monday- friday). The plot also shows that the top starting and destination stations for casual cyclists cluster around tourist locations within about 1 km of the lakefront. Top stations for member riders are more dispersed and reflect office locations.


![BikeShareRplot](https://github.com/GregoryGreen/CyclisticBike-Share/issues/1#issue-1313988777)




**Suggestions**

Introducing plans could attract casuals for the summer months. This marketing should be done during the winter months in preperation.

Membership rates during the warmer months as well as for those who only ride on the weekends would help in targeting the casual riders more specifically.

**Points that should be examined**

Age and gender: This would add a dynamic to whether or not customers are being targeted across demograpic lines

Pricing structure: The pricing not included in the  data would have give further insight to which plans are the most popular and by (how much) when comparing them. It would also be very effective to understanding the spending behaviour of casual user.
