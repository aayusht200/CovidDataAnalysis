# CovidDataAnalysis
Performing simple quries on data from Offical Covid world Data base.
Main Data - owid-covid-data.csv.zip 
Separate Data CovidVacinations.csv.zip, CovidDeaths.zip
Main file with Code - Main.ipynb

Inspiration From:
https://youtu.be/qfyynHBFOsM?si=M8LpGWnNXA78wi05 

Code: -
--Used to display name of colomns for refrence
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths'
ORDER BY ORDINAL_POSITION

-- Looking at data of india and likelyhood of covid leading to Death
Select [location],[date],total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage 
from CovidDeaths 
where [location]='india'

--Looking for percentage of people who got covid
Select [location],[date],total_cases,population, (total_cases/population)*100 as percentage 
from CovidDeaths 
where [location]='india' ORDER By [date]

--Looking for data of people who got covid in United States and India
Select [location],[date],total_cases,population, (total_cases/population)*100 as percentage 
from CovidDeaths 
where ([location]='india' or [location]='United States' )AND total_cases !=0 ORDER by [date]

