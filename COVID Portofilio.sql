 SELECT *
FROM dbo.CovidDeaths
order by 3,4

--SELECT *
--FROM dbo.CovidVactination
--order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--looking Death Precentage by total cases 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
FROM PortfolioProject..CovidDeaths
where location = 'Serbia'
order by 1,2

-- looking TOTAL CASES VS POPULATION

SELECT location, date, total_cases, population, (total_cases/population)*100 as CovidPopulationEffection
FROM PortfolioProject..CovidDeaths
where location = 'Serbia'
order by 1,2

-- Looking at countries with highest Infection rate compered to population

SELECT location,population, max (total_cases) as HighestInfectionCount, max((total_cases/population))*100 as MaxPopulationEffection
FROM PortfolioProject..CovidDeaths
Group by population, location
order by MaxPopulationEffection desc

--Showing highest Death Count per population

--SELECT location,population, max (total_deaths) as TotalDeathCount, max((total_deaths/population))*100 as MaxDeathCasesPrecentage
--FROM PortfolioProject..CovidDeaths
--Group by population, location
--order by MaxDeathCasesPrecentage desc

SELECT location, max(cast(total_deaths as int))  as TotalDeathCount
from CovidDeaths
Where continent is not NULL
Group by location
order by TotalDeathCount desc

-- Showing highest Death Count per Continent

SELECT continent, max(cast(total_deaths as int))  as TotalDeathCount
from CovidDeaths
Where continent is not NULL
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

SELECT   SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 
 as DeathPrecentage
FROM PortfolioProject..CovidDeaths
where continent is not NULL
--group by date 
order by 1,2


--Looking at Total Population vs  Vactination

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths	dea
join PortfolioProject.dbo.CovidVactination vac
on	vac.location = dea.location 
and vac.date = dea.date
where dea.continent is not null
order by 2,3



--Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)

as
(
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths	dea
join PortfolioProject.dbo.CovidVactination vac
on	vac.location = dea.location 
and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- TEMP TABLE


DROP TABLE IF EXISTS #PrecentPopulationVaccinated
Create table #PrecentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PrecentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths	dea
join PortfolioProject.dbo.CovidVactination vac
on	vac.location = dea.location 
and vac.date = dea.date
--where dea.continent is not null
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PrecentPopulationVaccinated



-- Creating View to store data for later visualization

Create View PrecentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM (CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths	dea
join PortfolioProject.dbo.CovidVactination vac
on	vac.location = dea.location 
and vac.date = dea.date
where dea.continent is not null
--order by 2,3

Select *
FROM PrecentPopulationVaccinated
