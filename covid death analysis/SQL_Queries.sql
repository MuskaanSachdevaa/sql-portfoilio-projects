-- SELECT * FROM [CovidDeaths ]
-- order by 3,4;

-- SELECT * FROM CovidVaccinations
-- order by 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2;

-- Total cases VS total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeaths
WHERE location LIKE 'India'
ORDER BY location, date;


-- Total Cases Vs Population

SELECT location, date, total_cases, population, (total_cases/population)*100 as infected_pop_percentage
FROM CovidDeaths
WHERE location LIKE 'India'
ORDER BY location, date;

-- Counrtries with highest population rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population)*100) AS infected_pop_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY infected_pop_percentage DESC;

-- Countries with highest death rate per population size

SELECT location, MAX(total_deaths) AS highest_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY highest_death_count DESC;

-- Continents with highest death rate per population size

SELECT [location], MAX(total_deaths) AS highest_death_count
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY [location]
ORDER BY highest_death_count DESC;

-- Total cases Vs Total Deaths per continent

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY [date]
ORDER BY death_rate DESC;

-- Population Vs Vaccinations

SELECT cd.continent, cd.[location], cd.[date], cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location 
ORDER BY cd.location, cd.date)
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.[location] = cv.[location]
AND cd.[date] = cv.[date]
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;

-- Create CTE 

WITH PopVaccinated(Continents, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS (
SELECT cd.continent, cd.[location], cd.[date], cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location 
ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.[location] = cv.[location]
AND cd.[date] = cv.[date]
WHERE cd.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *, (Rolling_People_Vaccinated/Population)*100 AS Pop_Vaccinated_Percentage
 FROM PopVaccinated;

--  Using TEMP Table

DROP TABLE IF EXISTS #PopVaccinated 
CREATE TABLE #PopVaccinated(
    Continents NVARCHAR(255),
    Location NVARCHAR(255),
    date DATETIME,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    Rolling_People_Vaccinated NUMERIC
)
INSERT INTO #PopVaccinated
SELECT cd.continent, cd.[location], cd.[date], cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location 
ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.[location] = cv.[location]
AND cd.[date] = cv.[date]
WHERE cd.continent IS NOT NULL
-- ORDER BY 2,3

SELECT *, (Rolling_People_Vaccinated/Population)*100 AS Pop_Vaccinated_Percentage
 FROM #PopVaccinated; 