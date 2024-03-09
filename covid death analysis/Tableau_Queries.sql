-- Tableau Project Queries

-- 1.
-- Total cases Vs Total Deaths per continent

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- 2.
-- Total Death Count per Continent

SELECT location, SUM(new_deaths) AS total_death_count
FROM CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC;

-- 3.
-- Counrtries with highest population rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population)*100) AS infected_pop_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY infected_pop_percentage DESC;

-- 4.

SELECT location, population, date, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population)*100) AS infected_pop_percentage
FROM CovidDeaths
GROUP BY location, population, date
ORDER BY infected_pop_percentage DESC;