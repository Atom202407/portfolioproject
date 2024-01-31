----Select *
----from CovidVaccinations$
----order by 3,4

Select *
from CovidDeaths$
order by 3,4



Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2


-- looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like '%Nigeria%'
and continent is not null
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like '%State%'
and continent is not null
order by 1,2


-- Looking Total cases vs Population density
-- Shows what percentage of populations got Covid

Select location, date, Population, total_cases, (total_cases/Population)*100 as  PercentpopulationInfected
from CovidDeaths$
--where location like '%Nigeria%'
order by 1,2


Select location, date, Population, total_cases, (total_cases/Population)*100 as PercentpopulationInfected
from CovidDeaths$
--where location like '%state%'
order by 1,2



-- Looking at countries qwith highest infection rate compared to population 



Select location, Population, Max(total_cases) as HighestInfectionCount, max((total_cases/Population))*100 
as PercentpopulationInfected
from CovidDeaths$
--where location like '%state%'
Group by continent ,population
order by  PercentpopulationInfected DESC

-- Showing countries with the highest deatth count per population 

Select location, max(cast(total_deaths as int)) as Totaldeaths
from CovidDeaths$
--where location like '%state%'
where continent is not null
Group by continent
order by Totaldeaths DESC




-- breaking it down by continent

Select location , max(cast(total_deaths as int)) as Totaldeaths
from CovidDeaths$
--where location like '%state%'
where continent is null
Group by location
order by Totaldeaths DESC
                 
				 --OR

Select continent , max(cast(total_deaths as int)) as Totaldeaths
from CovidDeaths$
--where location like '%state%'
where continent is not null
Group by continent
order by Totaldeaths DESC

--SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

Select continent, max(cast(total_deaths as int)) as Totaldeaths
from CovidDeaths$
--where location like '%state%'
where continent is not null
Group by continent
order by Totaldeaths DESC



-- Global Numbers
 select  date, sum(new_cases)--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
   from CovidDeaths$
    --where location like '%State%'
  where continent is not null
  group by date
  order by 1,2

   select  date, sum(new_cases), sum(cast(new_deaths as int))--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
   from CovidDeaths$
    --where location like '%State%'
  where continent is not null
  group by date
  order by 1,2

  select  date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
   from CovidDeaths$
    --where location like '%State%'
  where continent is not null
  group by date
  order by 1,2

  
  select  sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
   from CovidDeaths$
    --where location like '%State%'
  where continent is not null
  --group by date
  order by 1,2

  --Looking at Total Population vs Total Vaccinations

  Select *
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date


 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 
 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over (partition by dea.location) 
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3
                        ---same result just that we are using "convert(int,  )" instead of "cast(   as int)" 
 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
  dea.date) as RollingVaccinatedPeople,
--(RollingVaccinatedPeople/population)*100
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --Using CTE


 with popvsvac(continent, location,date, population, new_vaccinations, RollingVaccinatedPeople)
 as 
 (
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
  dea.date) as RollingVaccinatedPeople
--,(RollingVaccinatedPeople/population)*100
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )

 select*, (RollingVaccinatedPeople/population)*100
 from popvsvac

  Select dea.continent, dea.location, dea.population, vac.new_vaccinations,
  max(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
  dea.date) as RollingVaccinatedPeople
--,(RollingVaccinatedPeople/population)*100
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 
 where dea.continent is not null
  --order by 2,3


 --USING TEMP TAMPLE
 Drop table if exists #PercentPopulatonVaccinated2
 Create table #PercentPopulatonVaccinated2
 (
 continent nvarchar(255),
 location nvarchar (255),
 date datetime,
 Population numeric,
 new_vaccinations numeric,
 RollingVaccinatedPeople numeric
 )


 
 INSERT INTO #PercentPopulatonVaccinated2
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
  dea.date) as RollingVaccinatedPeople
--,(RollingVaccinatedPeople/population)*100
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 --order by 2,3

 
 select*, (RollingVaccinatedPeople/population)*100
 from #PercentPopulatonVaccinated2




 --- Creating view to store data for visualization


 create view  PercentPopulatonVaccinated2 as
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
  dea.date) as RollingVaccinatedPeople
--,(RollingVaccinatedPeople/population)*100
 from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3


 select *
 from  PercentPopulatonVaccinated2