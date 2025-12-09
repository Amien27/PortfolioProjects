select * 
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

--SELECT DATA THAT WE ARE GOING TO BE USING 
SELECT location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where location like '%states%'

--LOOKING AT TOTAL CASES VS POPULATION
select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'

--LOOKING AT COUNTRIES WITH HIGHEST InfectionPercentage
select location, date, max(total_cases) as HighestInfecCount, population,max((total_cases/population))*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
group by location, date, population
order by InfectionPercentage desc

--Show countries with Highest death count per population
select location, max(total_deaths) as HighestDeathCount, population,max((total_deaths/population))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
group by location, population
order by DeathPercentage desc

select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

--BREAK THINGS DOWN BY CONTINENT
select continent, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc
--this is corrected one
select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by HighestDeathCount desc

--LOOKING AT TOTAL POPULATION VS VACCINATION (nombor biasa)
select v.continent, v.location, v.date, population, new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by v.location order by v.location, v.date) as rollpeoplevacc
from PortfolioProject..CovidDeaths d
Join PortfolioProject..CovidVaccinations v
on d.location= v.location and d.date=v.date
where v.continent is not null
order by 2,3

--LOOKING AT TOTAL POPULATION VS VACCINATION (percentage)
with PopvsVac (continent, location, date, population, new_vaccinations, rollpeoplevacc) as
(
select v.continent, v.location, v.date, population, new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by v.location order by v.location, v.date) as rollpeoplevacc
from PortfolioProject..CovidDeaths d
Join PortfolioProject..CovidVaccinations v
on d.location= v.location and d.date=v.date
where v.continent is not null
--order by 2,3
)
select * , (rollpeoplevacc/population)*100 as rollpeoplevac_percentage
from PopvsVac

--TEMPORARY TABLE(TEMP TABLE)
DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollpeoplevacc numeric
)
Insert into #PercentPopulationVaccinated
select v.continent, v.location, v.date, population, new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by v.location order by v.location, v.date) as rollpeoplevacc
from PortfolioProject..CovidDeaths d
Join PortfolioProject..CovidVaccinations v
on d.location= v.location and d.date=v.date
--where v.continent is not null
--order by 2,3

select * , (rollpeoplevacc/population)*100 as rollpeoplevac_percentage
from #PercentPopulationVaccinated

--CRETING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

Create view PercentPopulationVaccinated as 
select v.continent, v.location, v.date, population, new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by v.location order by v.location, v.date) as rollpeoplevacc
from PortfolioProject..CovidDeaths d
Join PortfolioProject..CovidVaccinations v
on d.location= v.location and d.date=v.date
where v.continent is not null
--order by 2,3

select* from PercentPopulationVaccinated



