--select * from portfolio_project..[Covid Vaccination]
-----------------------------------------------------------------------------------------------------------------------------------------------
/* alter table portfolio_project..[Covid Vaccination] DROP COLUMN column5,-- removing all the column with no value that got added from excel csv file
           column6,
           column7,
           column8,
           column9,
           column10,
           column11,
           column12,
           column13,
           column14,
           column15,
           column16,
           column17,
           column18,
           column19,
           column20,
           column21,
           column22,
           column23,
           column24,
           column25,
           column26; */
--------------------------------------------------------------------------------------------------------------------------------
--select * from portfolio_project..[Covid Vaccination] --viewing table
--------------------------------------------------------------------------------------------------------------------------------
--select * from portfolio_project..Covid_death-- viewing table
--------------------------------------------------------------------------------------------------------------------------------
-- data that we are using
           --select location,date,total_cases,new_cases,total_deaths, population from portfolio_project..Covid_death order by 1,2
--------------------------------------------------------------------------------------------------------------------------------
--adding new column as death percentage , adding formula, using alias for naming the column, *1.00 is added to ensure that it gives back the floating value , else it is returning every value as 0 
--------------------------------------------------------------------------------------------------------------------------------
           --select location,date,total_cases,total_deaths,(total_deaths*1.00/total_cases)*100 as Death_percentage from portfolio_project..Covid_death order by 1,2
--------------------------------------------------------------------------------------------------------------------------------
--selecting the country which have state in it using like statement(getting the data of specific Country)
           ---select location,date,total_cases,total_deaths,(total_deaths*1.00/total_cases)*100 as Death_percentage from portfolio_project..Covid_death where location like '%state%'
---------------------------------------------------------------------------------------------------------------------------------------------
--looking at total case vs Population (shows total population got covid)
         ---select location,date,total_cases,population,(total_cases*1.00/population)*100 as Covid_effected_people_percentage from portfolio_project..Covid_death where location like '%state%'
 -------------------------------------------------------------------------------------------------------------------------------------------------
--- using group by , order by ; (finding the Highest Infection rate of covid)
      --- select location,population, MAX(total_cases) AS Highest_Infected,MAX((total_cases*1.00/population)*100) as highest_Covid_effected_people_percentage from portfolio_project..Covid_death group by population, location order by highest_Covid_effected_people_percentage desc
--- using group by , order by ; (finding the Highest death rate of covid), using cast 
              /* SELECT 
               location, 
               MAX(CAST(total_deaths AS BIGINT)) AS Highest_death,
               MAX((total_deaths * 1.00 / population) * 100) AS highest_Covid_death_people_percentage 
            FROM 
               portfolio_project..Covid_death 
            WHERE 
               continent IS NOT NULL
            GROUP BY 
               location 
            ORDER BY 
               Highest_death DESC;*/
-------------------------------------------------------------------------------------------------------------------------------------
               /*   SELECT                    (list of continent)
               continent 
            FROM 
               portfolio_project..Covid_death 
            WHERE 
               continent IS  NULL
            GROUP BY 
                 continent */
 -----------------------------------------------------------------------------------------------------------------------------    
            /* SELECT                    --(list of location where continent is null )
               location 
            FROM 
               portfolio_project..Covid_death 
            WHERE 
               continent IS NULL                    --- uswe not null for to get list of country
            group by location  */
------------------------------------------------------------------------------------------------------------------------------
           /* SELECT 
               continent, 
               MAX(CAST(total_deaths AS BIGINT)) AS Highest_death,
               MAX((total_deaths * 1.00 / population) * 100) AS highest_Covid_death_people_percentage 
            FROM 
               portfolio_project..Covid_death 
            WHERE 
               continent IS NOT NULL
            GROUP BY 
               location 
            ORDER BY 
               Highest_death DESC; */
--------------------------------------------------------------------------------------------------------------------------------
    -- Using of join , partiton by, to find the poulation who recieved least vaccine
	/*Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
   SUM(ISNULL(CONVERT(bigint, vac.new_vaccinations), 0)) OVER (Partition by dea.location order by (CONVERT(bigint, vac.new_vaccinations))) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolio_project..Covid_death dea
Join portfolio_project..[Covid Vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null */

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--USing CTE 
/* WITH CTE AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location ORDER BY CONVERT(BIGINT, vac.new_vaccinations)) AS RollingPeopleVaccinated
    FROM 
        portfolio_project..Covid_death dea
    JOIN 
        portfolio_project..[Covid Vaccination] vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
-- Main query using the CTE
Select *, (RollingPeopleVaccinated*1.0/Population)*100 as rolling_vacinating_population_percent
FROM 
    CTE; */
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Create a temporary table to store the intermediate result
 /* CREATE TABLE #Temp_RollingPeopleVaccinated (
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATE,
    population INT,
    new_vaccinations INT,
    RollingPeopleVaccinated BIGINT
);

-- Populate the temporary table with the result of the query
INSERT INTO #Temp_RollingPeopleVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location ORDER BY CONVERT(BIGINT, vac.new_vaccinations)) AS RollingPeopleVaccinated
FROM 
    portfolio_project..Covid_death dea
JOIN 
    portfolio_project..[Covid Vaccination] vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

-- Select from the temporary table
SELECT 
    continent,
    location,
    date,
    population,
    new_vaccinations,
    RollingPeopleVaccinated
FROM 
    #Temp_RollingPeopleVaccinated;

-- Drop the temporary table when no longer needed
DROP TABLE #Temp_RollingPeopleVaccinated; */
------------------------------------------------------------------------------------------------------------------------------------------------
-- Creating View to store data for later visualizations

 /* Create View HighestCovidinfection as 
      select location,population, MAX(total_cases) 
	  AS Highest_Infected,MAX((total_cases*1.00/population)*100) 
	  as highest_Covid_effected_people_percentage from portfolio_project..Covid_death 
	  group by population, location 
	  --order by highest_Covid_effected_people_percentage desc --The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.

	  */

