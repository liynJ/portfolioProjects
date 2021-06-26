/*
Queries used for Tableau Project
*/



-- 1. 
USE portfolio1;

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	   ROUND(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,2) as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2;


-- 2. 

-- We take these out as they are not inCluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent IS NULL
		AND location NOT IN ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  ROUND(Max((total_cases/population))*100,2) as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  ROUND(Max((total_cases/population))*100,2) as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


-- 1.

Select cd.continent, cd.location, cd.date, cd.population
, MAX(cv.total_vaccinations) as RollingPeopleVaccinated
From CovidDeaths cd
Join CovidVaccination cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
group by cd.continent, cd.location, cd.date, cd.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ROUND(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,3) as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2




-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  ROUND(Max((total_cases/population))*100,3) as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From CovidDeaths
where continent is not null 
order by 1,2
