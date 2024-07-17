
--total coviddeaths data
Select *
FROM CovidDeaths
ORDER BY 1,2
 --total vaccination data
 Select *
 FROM CovidVaccinations
 ORDER BY 1,2

 --Random data from CovidDeaths

Select location,date,total_cases,new_cases,total_deaths
FROM CovidDeaths
ORDER BY 1,2
 
 --Looking for Totalcases Vs TotalDeaths
 Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
 FROM CovidDeaths
 ORDER BY 1,2

 -- if we want to access any particular country data
  Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
 FROM CovidDeaths
 WHERE location like '%India%'
 ORDER BY 1,2
  

  --Now we will look at countries with  Highest Infection Rate Compared to population
  Select location,population,MAX(total_cases) as HighestInfectionRate ,MAX((total_cases/population))*100 as percentagepopulationinfected
 FROM CovidDeaths
GROUP BY Location,Population
 ORDER BY 1,2
 
 -- showing countries with Highest death count
 Select Location, MAX(cast(total_deaths as int)) as Highestdeathcount
 FROM CovidDeaths
 GROUP BY Location
 ORDER BY 1,2

-- join coviddeaths and covidvaccination
--ON Total vaccination vs population
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM CovidDeaths  dea
JOIN CovidVaccinations vac
On dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

-- Now we will use temp table
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
INSERT INTO #PercentPopulationVaccinated
Select dea.continent,dea.Location,dea.Date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY dea.Location ORDER BY dea.Location,dea.Date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location =vac.location
and dea.date=vac.date
WHERE dea.continent is not null
Select *,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated





