USE portfolio1;

SELECT *
FROM covidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths,population
FROM CovidDeaths
ORDER BY 1,2;


--Looking at total cases vs total deaths
--shows the likelihood of dying due to covid19 in Kuwait

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS death_percent
FROM CovidDeaths
WHERE location = 'Kuwait' AND continent IS NOT NULL
ORDER BY 1,2;


--Looking at total cases vs population; shows the % of the population that got covid in Kuwait 

SELECT location, date, population, total_cases, ROUND((total_cases/population)*100,2) AS infection_percent
FROM CovidDeaths
WHERE location = 'Kuwait' AND continent IS NOT NULL
ORDER BY 1,2;


--Countries with the highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection, MAX(ROUND((total_cases/population)*100,2)) AS infection_percent
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;


--Countries with the highest death count per population (cast is applied because total_deaths data type is nvarchar)

SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;


--highest death count by continent 

SELECT continent, MAX(cast(total_deaths as int)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;


--Global numbers

SELECT SUM(new_cases) AS global_new_cases, SUM(cast(new_deaths as int)) global_new_deaths, 
			ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100, 2) AS deaths_percent --,date 
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1;


--total population vs vaccinations
-- Showing the Percentage of Population that has recieved at least one Covid Vaccine

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_people_vaccinated
FROM CovidDeaths cd
JOIN CovidVaccination cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null 
ORDER BY 2,3;


--Using CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) 
AS 
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(CONVERT(int, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM covidVaccination cv
JOIN CovidDeaths cd ON cv.location = cd.location
					AND cv.date = cd.date
WHERE cd.continent IS NOT NULL
)

SELECT *, ROUND((rolling_people_vaccinated/population*100),2) AS vaccinated_population
FROM popvsVac;


--TEMP table
DROP TABLE IF EXISTS #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated 
			(continent nvarchar(255),
			 location nvarchar(255),
			 date datetime,
			population numeric,
			new_vaccinations numeric,
			rolling_people_vaccinated numeric)

INSERT INTO #percent_population_vaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(CONVERT(int, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM covidVaccination cv
JOIN CovidDeaths cd ON cv.location = cd.location
					AND cv.date = cd.date
WHERE cd.continent IS NOT NULL

SELECT *, ROUND((rolling_people_vaccinated/population*100),2) AS vaccinated_population
FROM #percent_population_vaccinated;


--Creating view for visualization 
CREATE VIEW percent_population_vaccinated AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
    SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
	FROM CovidDeaths cd
	JOIN CovidVaccination cv
		ON cd.location = cv.location
		AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL; 

SELECT *
FROM percent_population_vaccinated	;