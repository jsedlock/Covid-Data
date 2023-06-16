/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


*/

SELECT *
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 3, 4


-- Select data that we are going to be starting with

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

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


-- Looking at Countries with Highest Infection Rate compared to Population

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



-- BREAKING THINGS DOWN BY CONTINENT

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



-- Total Population vs. Vaccinations
-- Shows Percentage of Population that has recieved at least on Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER  (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- Rolling count of vaccinations
, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
Where dea.continent is not NULL
order by 2, 3



-- Using CTE to perform Calculation on Partition by in previous query

With PopvsVac (continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER  (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- Rolling count of vaccinations
-- , (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
Where dea.continent is not NULL
-- order by 2, 3
)
Select *, (RollingPeopleVaccinated*1.0/population) * 100 as PecentVaccinated
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

Drop TABLE if EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
    continent NVARCHAR(255), 
    location NVARCHAR(255), 
    date DATETIME, 
    population NUMERIC, 
    new_vaccinations NUMERIC, 
    RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER  (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- Rolling count of vaccinations
-- , (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
Where dea.continent is not NULL
-- order by 2, 3

Select *, (RollingPeopleVaccinated*1.0/population) * 100 as PecentVaccinated
From #PercentPopulationVaccinated





-- Creating view to store data for later visualizations
-- Creating a view of percent Vaccinated vs 

Drop View if EXISTS PercentPopulationVaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

