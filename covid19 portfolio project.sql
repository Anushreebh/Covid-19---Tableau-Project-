/* table creation coviddeaths*/

create table coviddeaths (
iso_code varchar,
continent varchar,
location varchar,
date date,
population float,
total_cases float,
new_cases float,
new_cases_smoothed float,
total_deaths float,
new_deaths float,
new_deaths_smoothed float,
total_cases_per_million float,
new_cases_per_million float,
new_cases_smoothed_per_million float,
total_deaths_per_million float,
new_deaths_per_million float, 
new_deaths_smoothed_per_million float,
reproduction_rate float,
icu_patients float,
icu_patients_per_million float,
hosp_patients float,
hosp_patients_per_million float,
weekly_icu_admissions float,
weekly_icu_admissions_per_million float,
weekly_hosp_admissions float,
weekly_hosp_admissions_per_million float
);
	
/* import table coviddeaths*/

COPY coviddeaths(iso_code,continent,location,date,population,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,	
new_deaths_smoothed,total_cases_per_million,new_cases_per_million, new_cases_smoothed_per_million,total_deaths_per_million,	
new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,	hosp_patients,
hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,	
weekly_hosp_admissions_per_million)
FROM 'D:\Desktop\Data analyst\SQL\Covid 19\coviddeaths.csv'
DELIMITER ','
CSV HEADER;

/* table creation covidvaccinations*/

create table covidvaccinations(
iso_code varchar,
continent varchar,
location varchar,
date date,
total_tests float,
new_tests float,
total_tests_per_thousand float,
new_tests_per_thousand float,
new_tests_smoothed float,
new_tests_smoothed_per_thousand float,
positive_rate  float,
tests_per_case float,
tests_units varchar,
total_vaccinations float,
people_vaccinated float,
people_fully_vaccinated float,
total_boosters float,
new_vaccinations float,
new_vaccinations_smoothed float,
total_vaccinations_per_hundred float,
people_vaccinated_per_hundred float,
people_fully_vaccinated_per_hundred float,
total_boosters_per_hundred float,
new_vaccinations_smoothed_per_million float,
new_people_vaccinated_smoothed float,
new_people_vaccinated_smoothed_per_hundred float,
stringency_index float,
population_density float,
median_age float,
aged_65_older float,
aged_70_older float,
gdp_per_capita float,
extreme_poverty float,
cardiovasc_death_rate float,
diabetes_prevalence float,
female_smokers float,
male_smokers float,
handwashing_facilities float,
hospital_beds_per_thousand float,
life_expectancy float,
human_development_index float,
excess_mortality_cumulative_absolute float,
excess_mortality_cumulative float,
excess_mortality float,
excess_mortality_cumulative_per_million float
);

/* import table covidvaccinations*/

COPY covidvaccinations(
iso_code,
continent,
location,
date,
total_tests ,
new_tests,
total_tests_per_thousand,
new_tests_per_thousand,
new_tests_smoothed,
new_tests_smoothed_per_thousand,
positive_rate,
tests_per_case,
tests_units ,
total_vaccinations,
people_vaccinated,
people_fully_vaccinated,
total_boosters,
new_vaccinations,
new_vaccinations_smoothed,
total_vaccinations_per_hundred,
people_vaccinated_per_hundred,
people_fully_vaccinated_per_hundred,
total_boosters_per_hundred,
new_vaccinations_smoothed_per_million,
new_people_vaccinated_smoothed,
new_people_vaccinated_smoothed_per_hundred,
stringency_index,
population_density,
median_age ,
aged_65_older,
aged_70_older,
gdp_per_capita,
extreme_poverty,
cardiovasc_death_rate,
diabetes_prevalence,
female_smokers,
male_smokers,
handwashing_facilities,
hospital_beds_per_thousand,
life_expectancy,
human_development_index ,
excess_mortality_cumulative_absolute ,
excess_mortality_cumulative,
excess_mortality,
excess_mortality_cumulative_per_million
)
FROM 'D:\Desktop\Data analyst\SQL\Covid 19\covidvaccinations.csv'
DELIMITER ','
CSV HEADER;
 
select * from  covidvaccinations;
select * from coviddeaths;

/* Looking at Total Cases vs Total Deaths*/
/* Shows likelihood of dying if you contract covid in your country.*/

select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as "DeathPercentage" 
from coviddeaths 
where location like '%States%' and continent is not null and total_cases is not null and total_deaths is not null
order by 1,2;

select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as "DeathPercentage" 
from coviddeaths 
where location='India' and continent is not null and total_cases is not null and total_deaths is not null
order by 1,2;


/* Looking at Total Cases vs Population*/
/* Shows what percentage of population got covid*/

select location, date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from coviddeaths 
where location='India' and continent is not null and total_cases is not null
order by 1,2;

/* Looking at Countries with Highest Infection Rate compared to Population*/

select location, population, max(total_cases) as HighestInfectionCount , 
max((total_cases/population))* 100 as PercentPopulationInfected from coviddeaths 
where continent is not null and total_cases is not null
group by location, population 
order by PercentPopulationInfected desc;


/* Showing Countries with Highest Death Count*/

select location, max(total_deaths) as HighestDeathCount
from coviddeaths
where continent is not null and total_deaths is not null
group by location
order by HighestDeathCount desc;


/* Breaking things down by Continent*/
/* Showing Continent with Highest Death Count*/

select continent, max(total_deaths) as HighestDeathCount
from coviddeaths
where continent is not null
group by continent
order by HighestDeathCount desc;

/* Global Numbers*/
Showing New Deaths and New Cases

select date, sum(new_cases) as "TotalNewCases", sum(new_deaths) as "TotalNewDeaths"
from coviddeaths
where continent is not null
group by date
order by date;

/* Global New Death percentage in relation to new cases  */
select date, sum(new_cases) as "TotalNewCases", sum(new_deaths) as "TotalNewDeaths", 
 sum(new_deaths) / sum(new_cases) *100 as "PercentDeathCases"
from coviddeaths
where continent is not null 
group by date
having sum(new_cases) > 0
order by 1;

/* globally Covid-19 Cases, Death Cases and Death Percentage */
select sum(new_cases) as "TotalNewCases", sum(new_deaths) as "TotalNewDeaths",
sum(new_deaths) / sum(new_cases) *100 as "DeathPercentage"
from coviddeaths
where continent is not null;


/* Joining tables coviddeaths and covidvaccinations to get insights*/

select * from coviddeaths as dea join covidvaccinations as vac on dea.location = vac.location
and dea.date = vac.date;

/* Total population vs vaccinations*/

select dea.continent,dea.location,DATE_PART('Year',dea.date),sum(dea.population) as TotalPopulation, 
sum(new_vaccinations) as TotalNewVaccinations, sum(new_vaccinations)/ sum(dea.population) *100 as NewVaccinationsPercent
from coviddeaths as dea join covidvaccinations as vac on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null and new_vaccinations is not null
group by dea.continent, dea.location, DATE_PART('Year', dea.date)
order by 1,2;

/* Create view to store data for later visualization*/

create view TotalCases_vs_TotalDeaths as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as "DeathPercentage" 
from coviddeaths 
where location like '%States%' and continent is not null and total_cases is not null and total_deaths is not null
order by 1,2;

create view TotalCases_vs_Population as
select location, date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from coviddeaths 
where location='India' and continent is not null and total_cases is not null
order by 1,2;

create view HighestInfectionRate_vs_Population as
select location, population, max(total_cases) as HighestInfectionCount , 
max((total_cases/population))* 100 as PercentPopulationInfected from coviddeaths 
where continent is not null and total_cases is not null
group by location, population 
order by PercentPopulationInfected desc;


/* Queries used for Tableau Project */


/* globally Covid-19 Cases, Death Cases and Death Percentage */
select sum(new_cases) as "TotalNewCases", sum(new_deaths) as "TotalNewDeaths",
sum(new_deaths) / sum(new_cases) *100 as "DeathPercentage"
from coviddeaths
where continent is not null;

/* Total Death count per continent */
select continent, sum(new_deaths) as "TotalDeathCount"
from coviddeaths
where continent is not null
and location not in ('World','European Union','International')
group by continent
order by sum(new_deaths) desc;


/* Looking at Countries with Highest Infection Rate compared to Population*/

select location, population, max(total_cases) as HighestInfectionCount , 
max((total_cases/population))* 100 as PercentPopulationInfected from coviddeaths 
where continent is not null and total_cases is not null
group by location, population 
order by PercentPopulationInfected desc;

/* Looking at Monthly data of PercentPopulationInfected */

select location, population,date, max(total_cases) as HighestInfectionCount , 
max((total_cases/population))* 100 as PercentPopulationInfected from coviddeaths 
where continent is not null
group by location, population, date
order by PercentPopulationInfected desc;













