/*
Queries used for covid project - Tableau dashboard
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

