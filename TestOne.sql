  --Checking if data got imported Correctly
SELECT
  *
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NOT NULL;

SELECT
  *
FROM
  `covidtests-396717.Covid.CovidVacinations`
WHERE
  continent IS NOT NULL;
  --Likely hood of you dying if you contracted Covid in india
SELECT
  location date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS DeathPercentage
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  location="India"
ORDER BY
  2;
  --Likely hood of you contracting covid in india
SELECT
  location date,
  population,
  total_cases,
  (total_cases/population)*100 AS CovidPercentage
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  location="India"
ORDER BY
  2;
  -- looking at contries with high infection rate
SELECT
  location population,
  MAX(total_cases) AS HighestInfectionCount,
  MAX((total_cases/population)*100) AS CovidPercentage
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  population,
  location ORDER BY population DESC;
  --showing countries with highest death count
SELECT
  location,
  MAX(CAST(total_deaths AS int))AS TotalDeathCount
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  location
ORDER BY
  TotalDeathCount DESC;
  --Breakdown based on continent
SELECT
  location,
  MAX(CAST(total_deaths AS int))AS TotalDeathCount
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NULL
  AND location NOT LIKE '%income%'
  AND location !='World'
GROUP BY
  location
ORDER BY
  TotalDeathCount DESC;
  --Global Number based on continent
SELECT
  continent,
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int)) AS total_deaths,
  SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  DeathPercentage DESC;
  --Across the world
SELECT
  MAX(date) AS AsOff,
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int)) AS total_deaths,
  SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
FROM
  `covidtests-396717.Covid.CovidDeaths`
WHERE
  continent IS NOT NULL
ORDER BY
  1,
  2;
  --Joining Vacination Table and Death tables
SELECT
  *
FROM
  `covidtests-396717.Covid.CovidDeaths` death
JOIN
  `covidtests-396717.Covid.CovidVacinations` vac
ON
  death.location=vac.location
  AND death.date=vac.date;
  --population vs people vacinated
SELECT
  death.continent,
  death.location,
  death.date,
  death.population,
  vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingPeopleVacinated
FROM
  `covidtests-396717.Covid.CovidDeaths` death
JOIN
  `covidtests-396717.Covid.CovidVacinations` vac
ON
  death.location=vac.location
  AND death.date=vac.date
WHERE
  death.continent IS NOT NULL-- AND death.location='India'
ORDER BY
  2;
  --Using CTE (Common Table Expression)
WITH
  NewVac AS (
  SELECT
    death.continent,
    death.location,
    death.date,
    death.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingPeopleVacinated
  FROM
    `covidtests-396717.Covid.CovidDeaths` death
  JOIN
    `covidtests-396717.Covid.CovidVacinations` vac
  ON
    death.location=vac.location
    AND death.date=vac.date
  WHERE
    death.continent IS NOT NULL
    --AND death.location='India'
    )
SELECT
  *,
  (RollingPeopleVacinated/population)*100
FROM
  NewVac
ORDER BY
  location;
  --Using View for countires with highest DeathCount
  --DROP VIEW IF EXISTS
  --CountryWithHighestDeathCount
  --CREATE VIEW
  -- CountryWithHighestDeathCount AS
  --SELECT
  --location
  --,MAX(cast(total_deaths as int)) AS TotalDeathCount
  --FROM
  --`covidtests-396717.Covid.CovidDeaths`
  --WHERE
  --continent IS NOT NULL
  --GROUP BY
  --location
  --SELECT
  -- *
  --FROM
  -- `covidtests-396717.Covid.TestView`
  --ORDER BY
  --TotalDeathCount DESC