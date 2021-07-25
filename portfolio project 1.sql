select *
from [portfolio project 1]..coviddeaths



select *
from [portfolio project 1]..['covid vaccinations$']

--select *
--from [portfolio project 1]..coviddeaths
--order by 3,4

--select *
--from [portfolio project 1]..['covid vaccinations$']
--order by 3,4

--SELECT THE IMPORTANT DATA TO BE USED

select location,total_cases, new_cases, total_deaths, population
from [portfolio project 1]..coviddeaths
where continent is not null
order by 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
--DEATH PERCENTAGE SHOWS LIKELIHOOD OF DYING WHEN YOU CONTRACT COVID.

select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where continent is not null
order by 1,2

select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where location like '%states%'
order by 1,2

select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where location like '%kenya%'
order by 1,2

select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where location like '%united kingdom%'
order by 1,2

-- LOOKING AT THE TOTAL CASES VS POPULATION.
-- SHOWS POPULATION PERCENTAGE THAT GOT COVID.

select location, DATE, population, total_cases, (total_cases/population)*100 as PopulationPercentage
from [portfolio project 1]..coviddeaths
where location like '%united kingdom%'
order by 1,2

select location, DATE, population, total_cases, (total_cases/population)*100 as PopulationPercentage
from [portfolio project 1]..coviddeaths
where location like '%STates%'
order by 1,2

select location, DATE, population, total_cases, (total_cases/population)*100 as PopulationPercentage
from [portfolio project 1]..coviddeaths
where location like '%kenya%'
order by 1,2

--LOOKING AT THE TOTAL COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION.

select location, population, Max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PopulationPercentage
from [portfolio project 1]..coviddeaths
--where location like '%kenya%'
group by location,population
order by PopulationPercentage desc


--SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project 1]..coviddeaths
where continent is not null
group by location,population
order by TotalDeathCount desc

--LETS BREAKDOWN BY CONTINENT

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project 1]..coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc


--SHOWING CONTINENT WITH HIGHEST DEATH COUNT PER POPULATION

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project 1]..coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where continent is not null
order by 1,2


select  DATE, SUM(NEW_cases) as total_cases, SUM(CAST(NEW_deaths AS int)) as total_deaths, SUM(CAST(NEW_deaths AS int))/ SUM(NEW_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where continent is not null
group by date
order by 1,2

select SUM(NEW_cases) as total_cases, SUM(CAST(NEW_deaths AS int)) as total_deaths, SUM(CAST(NEW_deaths AS int))/ SUM(NEW_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where continent is not null
order by 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATIONS.

select *
from [portfolio project 1]..coviddeaths dea
join [portfolio project 1]..['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
from [portfolio project 1]..coviddeaths dea
join [portfolio project 1]..['covid vaccinations$'] vac
on dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
order by 2,3

--USING CTE

with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)

with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select *
from PopvsVacc



with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%china%'


with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%spain%'


with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%states%'



with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%kenya%'



with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%nigeria%'



with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%south africa%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%Ghana%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%egypt%'



with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%canada%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%israel%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%kuwait%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%russia%'




with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%som%'





with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%kenya%'





with PopvsVacc (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3
)
select continent, location, date, population, new_vaccinations, PeopleVaccinated, (peopleVaccinated/population)*100 as percentageofpeoplevaccinated
from PopvsVacc
where location like '%isr%'



--TEMP TABLE


Drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
--where dea.continent is not null
--order by 2,3

select *, (peopleVaccinated/population)*100 as PercentofPopulationVaccinated
from #PercentPopulationVaccinated



--CREATING VIEWS TO STORE DATA FOR LATER VISUALIZATION


CREATE VIEW PercentOFPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from [portfolio project 1]..coviddeaths dea 
join [portfolio project 1]..['covid vaccinations$'] vac
    on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3


CREATE VIEW Globalnumbers as
select location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project 1]..coviddeaths
where continent is not null
--order by 1,2

