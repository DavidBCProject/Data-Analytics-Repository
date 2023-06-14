

SELECT *
FROM PortafolioProject..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortafolioProject..CovidVaccinations
--ORDER BY 3,4

-- Seleccionar datos que se va a usar

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortafolioProject..CovidDeaths
ORDER BY 1,2

-- Observando Total Cases VS Total Deaths
-- Muestra la probabilidad de muerte tras contraer COVID por país
SELECT Location, date, total_cases, total_deaths, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
FROM PortafolioProject..CovidDeaths
WHERE location = 'Peru'
ORDER BY 1,2

-- Observando Total Cases VS Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage
FROM PortafolioProject..CovidDeaths
WHERE location = 'Peru'
ORDER BY 1,2

-- Observando Total Cases VS Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS InfectionRate
FROM PortafolioProject..CovidDeaths
WHERE location = 'Peru'
ORDER BY 1,2

-- Observando los países con las tasas de infección más altas de acuerdo a su población
SELECT location, POPULATION, MAX(total_cases) as HighestInfestionCount,MAX((total_cases/population)*100) as PercentagePopulationInfected
FROM PortafolioProject..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

-- Mostrando países con la mayor cantidad de muertes por población
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortafolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Por continente

-- Mostrando países con la mayor cantidad de muertes por población
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortafolioProject..CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortafolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as death_percentage--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as death_percentage--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Observando a la población total VS vacunados

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortafolioProject..CovidDeaths d
JOIN PortafolioProject..CovidVaccinations v
ON d.location = v.location and d.date = v.date
WHERE d.continent is not null --and d.location = 'Peru'
ORDER BY 2,3

-- USE CTE

WITH PopVSVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortafolioProject..CovidDeaths d
JOIN PortafolioProject..CovidVaccinations v
ON d.location = v.location and d.date = v.date
WHERE d.continent is not null --and d.location = 'Peru'
--ORDER BY 2,3
)
SELECT * ,(RollingPeopleVaccinated/population)*100
FROM PopVSVac


-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortafolioProject..CovidDeaths d
JOIN PortafolioProject..CovidVaccinations v
ON d.location = v.location and d.date = v.date
WHERE d.continent is not null --and d.location = 'Peru'
--ORDER BY 2,3

SELECT * ,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated
ORDER BY 2,3

-- creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortafolioProject..CovidDeaths d
JOIN PortafolioProject..CovidVaccinations v
ON d.location = v.location and d.date = v.date
WHERE d.continent is not null --and d.location = 'Peru'
--ORDER BY 2,3

SELECT * FROM PercentPopulationVaccinated


