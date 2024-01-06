-- Note: For simplicity here we are going to work with only 4 datasets that are:
--dailyActivity_merged.csv : to analyze Steps, Intensites and Calories Burn--
--sleepDay_merged.csv : to analyze Time in Bed and Total Minutes Asleep
--hourlyIntensities_merged.csv : to analyze the average Intensity
--heartrate_seconds_merged.csv : to analyze the heart rate per second for each user


-- Step 1: Data Consistency
-- Checking if all the datasets has same  number of unique identities or not
---------CODE------------
SELECT distinct id FROM `data-analysis-project-2-bella.BellaBeat.dailyActivity_merged` 
SELECT distinct id FROM `data-analysis-project-2-bella.BellaBeat.sleepDay_merged` 
SELECT distinct id FROM `data-analysis-project-2-bella.BellaBeat.hourlyIntensities_merged` 
SELECT distinct id FROM `data-analysis-project-2-bella.BellaBeat.heartrate_seconds_merged` 

-- Step2: Checking for Null values
-------CODE------------------
SELECT SUM(CASE WHEN 
Id is null and 
ActivityDate is null and
TotalSteps is null and
VeryActiveMinutes is null and
FairlyActiveMinutes is null and
LightlyActiveMinutes is null and
SedentaryMinutes is null and
Calories is null
  THEN 1
  ELSE 0
  END)  AS Number_Of_Null_Values
   FROM `data-analysis-project-2-bella.BellaBeat.dailyActivity_merged` limit 1000

SELECT SUM
(CASE WHEN 
Id is null and
SleepDay is null and
TotalSleepRecords is null and
TotalMinutesAsleep is null and
TotalTimeInBed is null
  THEN 1
  ELSE 0
  END)  AS Number_Of_Null_Values
   FROM `data-analysis-project-2-bella.BellaBeat.sleepDay_merged` LIMIT 1000

SELECT SUM(CASE WHEN 
Id is null and 
ActivityHour is null 
TotalIntensity is null and
AverageIntensity is null
  THEN 1
  ELSE 0
  END)  AS Number_Of_Null_Values FROM `data-analysis-project-2-bella.BellaBeat.hourlyIntensities_merged` LIMIT 1000

SELECT SUM(CASE WHEN 
Id is null and 
Time is null and
Value is null 
  THEN 1
  ELSE 0
  END)  AS Number_Of_Null_Values
   FROM `data-analysis-project-2-bella.BellaBeat.heartrate_seconds_merged` LIMIT 1000

-- Step 3: Data Manupilation
--a) For daily_activity: We will also calculate the total for each Active Minutes (Very Active,Fairly Active, Lightly Active, Sedentary) and Calories Burned per user.
-------------CODE---------------------------------------
SELECT  DISTINCT Id,
 SUM(TotalSteps) as total_steps,
 SUM(VeryActiveMinutes) as very_active ,
 SUM(FairlyActiveMinutes) as fairly_active,
 SUM(LightlyActiveMinutes) as light_active,
 SUM(SedentaryMinutes) as sedentary,
 SUM(Calories) as calories_burned
FROM `data-analysis-project-2-bella.BellaBeat.dailyActivity_merged` 
group by id
order by 1
--b) Now we wil save this output in another table as a summary table: use save results->BigQuery Table-> dataset=BellaBeat->table=daily_activity_summary
--c) Download this data as a daily_activity_summary.csv -> upload in tableau -> create scatter plots for burned calories vs total steps and active minutes

--Step 4: a)we will find the average of each variables for each user
----------CODE---------------
SELECT 
DISTINCT Id,
AVG(TotalSteps) as avg_steps,
AVG(VeryActiveMinutes) as avg_avery_ctive ,
AVG(FairlyActiveMinutes) as avg_fairly_active,
AVG(LightlyActiveMinutes) as avg_light_active,
AVG(SedentaryMinutes) as avg_sedentary,
AVG(Calories) as avg_calories_burned
 FROM `data-analysis-project-2-bella.BellaBeat.dailyActivity_merged` 
 group by Id
 order by avg_steps DESC
--b) Now we will save this output in another table as a summary table: use save results->BigQuery Table-> dataset=BellaBeat->table=daily_activity_summary2


--Step 5:a)we will do further classification for all users based on below benchmark:
--Sedentary - Less than 5000 steps a day.
--Low active - Between 5000 and 7499 steps a day.
--Fairly active - Between 7500 and 9999 steps a day.
--Very active - More than 10000 steps a day.
------CODE-------------

  SELECT user_type, COUNT(user_type) as TOTAL_USERS FROM
( SELECT Id,avg_steps,
CASE
  WHEN avg_steps < 5000 THEN "Sedentary"
  WHEN avg_steps BETWEEN 5000 AND 7499 THEN "Low Active"
  WHEN avg_steps BETWEEN 7500 AND 9999 THEN "Fairly Active"
  WHEN avg_steps >= 10000 THEN "Very Active"
  ELSE "not active"
  END AS user_type

FROM 
 `data-analysis-project-2-bella.BellaBeat.daily_acitivity_summary2`

 GROUP BY Id, avg_steps
 ORDER BY 
user_type
)
GROUP BY 
user_type
-- b) Download the output data as a daily_activity_summary2 -> upload in tableau -> create a piechart for percentage of users

-- Step 6: a)we will analyze the daily_sleep datasets
--------CODE---------------
-- to calculate total sleep records, minutes sleep and time in bed for each user-- 

SELECT DISTINCT Id,
SUM(TotalSleepRecords) as total_sleep_records,
SUM(TotalMinutesAsleep) as total_minutes_asleep,
SUM(TotalTimeInBed) as total_time_in_bed
FROM  `data-analysis-project-2-bella.BellaBeat.sleepDay_merged`
GROUP BY Id 
ORDER BY
total_sleep_records

--b)Download this data as sleep_day_summary.csv and import it in tableau and create bargraph : avg hrs of sleep vs weekday

--Step 7: a) we will analyze the hourly_intensity dataset
---CODE------------
SELECT  
DISTINCT Id,
SUM(TotalIntensity) as total_intensity_record,
SUM(AverageIntensity) as average_intensity_record

FROM `data-analysis-project-2-bella.BellaBeat.hourlyIntensities_merged` 
GROUP BY Id 
ORDER BY
total_intensity_record

--b)Download this data as hourly_intensity_summary and import it in tableau to create bargraph :

--Step 8: a) we will analyze the heart_rate dataset
-------------CODE-------------

SELECT
DISTINCT Id,
Sum(Value) as value_record,
FROM `data-analysis-project-2-bella.BellaBeat.heartrate_seconds_merged`
group by Id
order by value_record
--b) Download this data as heart_rate_summary.csv and upload it in tableau.







