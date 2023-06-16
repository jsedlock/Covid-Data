SELECT *
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 3, 4

-- SELECT *
-- FROM CovidVaccinations
-- ORDER BY 3, 4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths
-- shows the likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths * 1.0/total_cases)*100 as DeathPercentage 
FROM CovidDeaths
Where Location like '%states%'
ORDER BY 1, 2

-- Looking at the Total Cases vs. Population
-- Shows what percentage of population got Covid

SELECT Location, date, total_cases, population, (total_cases * 1.0/population)*100 as PercentagePopulationInfected
FROM CovidDeaths
-- Where Location like '%states%'
ORDER BY 1, 2

-- Looking at Countries with Highest Infectio Rate compared to Population
SELECT Location,  population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases) * 1.0/population)*100 as PercentagePopulationInfected 
FROM CovidDeaths
-- Where Location like '%states%'
GROUP BY Location, population
ORDER BY PercentagePopulationInfected DESC

-- Showing the Countries with the Highest Death Count per Population
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not NULL
-- Where Location like '%states%'
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- LETS BREAK THINGS DOWN BY CONTINENT

-- Showing the continents with the highest death counts

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, (SUM(new_deaths)*1.0/ NULLIF(SUM(new_cases), 0))*100 as DeathPercentage
FROM CovidDeaths
-- Where Location like '%states%'
where continent is not NULL
--GROUP BY date
ORDER BY 1, 2

-- Looking at Total Population vs. Vaccinations

SELECT dea.continent, dea.location, dea.date, population
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
