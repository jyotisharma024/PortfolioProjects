use newdb;
select * from coviddeaths1 order by 3,4;
select * from covidvaccinations order by 3,4;
select location, date, total_cases, new_cases, total_deaths,population from coviddeaths1 order by 1,2;
   
/*UPDATE coviddeaths1
SET weekly_hosp_admissions_per_million = NULL
WHERE TRIM(weekly_hosp_admissions_per_million) = ''; */


# looking at the total cases vs total deaths
# shows likelyhood of dying if you contract the infection

select location, date, total_cases, 
new_cases, total_deaths, 
round((total_deaths/total_cases)*100,2) as percentageofDeaths
from coviddeaths1 
where location like '%state%'
order by 1,2;

# looking at total cases vs population
# it will show what percentage of population gotton covid
select location, date, total_cases, population, 
round((total_cases/population)*100,2) as percentageofcontraction
from coviddeaths1 
order by 1,2;


# looking at the countries with highest infection rate compared to population
select location,   population, max(total_cases) as HighestInfectionCount,
max(round((total_cases/population)*100,2)) as percentageofcontraction
from coviddeaths1 
group by location,population
order by percentageofcontraction desc;

# showing countries with highest death_counts per population

select location,
max(cast(total_deaths as signed)) as TotalDeathCount
from coviddeaths1
where continent is not null
group by location
order by TotalDeathCount desc;

UPDATE coviddeaths1
SET continent = NULL
WHERE TRIM(continent) = '';

UPDATE coviddeaths1
SET total_cases = NULL
WHERE TRIM(total_cases) = '';


#total death count per continent

select continent, max(cast(total_deaths as signed)) as TotalDeathCount from coviddeaths1
where continent is not null
group by continent
order by TotalDeathCount desc;


# showing continents with highest death count

select location, max(cast(total_deaths as signed)) as TotalDeathCount from coviddeaths1
where continent is null
group by location
order by TotalDeathCount desc;

-- global numbers

select date, sum(new_cases) as TotalNewCasesOndate,
sum(cast(new_deaths as signed)) as TotalNewDeathsOndate,
(sum(cast(new_deaths as signed))/sum(new_cases))*100 as percentageOfNewDeaths from coviddeaths1
where continent is not null
group by date
order by 1,2;


select  sum(new_cases) as TotalNewCases,
sum(cast(new_deaths as signed)) as TotalNewDeaths,
(sum(cast(new_deaths as signed))/sum(new_cases))*100 as percentageOfNewDeaths from coviddeaths1
where continent is not null
-- group by date
order by 1,2;

select * from coviddeaths1 cd
join covidvaccinations cv
on cd.location=cv.location
and cd.date=cv.date;

UPDATE coviddeaths1
SET iso_code = NULL
WHERE TRIM(iso_code) = '';


SELECT weekly_hosp_admissions_per_million, LENGTH(weekly_hosp_admissions_per_million)
FROM coviddeaths1
WHERE LENGTH(TRIM(weekly_hosp_admissions_per_million)) = 0;

/*UPDATE coviddeaths1
SET continent = NULL
WHERE trim(continent)='';*/


# looking at new_vaccination done on each day in a location

select cd.continent,cd.location, cd.date,cv.new_vaccinations
 from coviddeaths1 cd
join covidvaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3;

# looking for total population vs total vaccination
# using CTE
with popvsvac(continent,location,date,population, new_vaccinations,RollingPeopleVaccinated) 
as
(select cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
sum(convert(cv.new_vaccinations, unsigned integer))over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from  coviddeaths1 cd
join covidvaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
)
select *,(RollingPeopleVaccinated/population)*100 as PercentofpeopleVaccinated from popvsvac;

# doing the same as abouve but now with Temp table

create temporary table povvsvac
(continent varchar(255),
location varchar(255),
date datetime,
population bigint,
new_vaccinations bigint,
RollingPeopleVaccinated bigint
);
insert into povvsvac
(select cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
sum(convert(cv.new_vaccinations, unsigned integer))over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from  coviddeaths1 cd
join covidvaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null);
select *,(RollingPeopleVaccinated/population)*100 as PercentofpeopleVaccinated from povvsvac;

DROP TEMPORARY TABLE IF EXISTS povvsvac;

# looking for maximum no of vaccination done in a day in each continent

SELECT location, MAX(new_vaccinations) 
FROM covidvaccinations 
WHERE continent IS NULL OR continent = '' 
GROUP BY location 
ORDER BY 1, 2;


#select location, date, new_vaccinations from covidvaccinations where continent is not null;
 ##select location,max(new_vaccinations) from covidvaccinations where location='Asia';
 
 # creating view to store data for later visualization
 
 create view PercentofpeopleVaccinated as
 select cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
sum(convert(cv.new_vaccinations, unsigned integer))over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from  coviddeaths1 cd
join covidvaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
 
 