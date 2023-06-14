SELECT *
FROM CovidDeaths
ORDER BY 3, 4

-- SELECT *
-- FROM CovidVaccinations
-- ORDER BY 3, 4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM CovidDeaths
ORDER BY 1, 2


