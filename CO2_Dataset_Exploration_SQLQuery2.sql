SELECT TOP 1 * FROM dbo.world_co2_emission_dataset

-- GEt all the header name once...
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'world_co2_emission_dataset' -- Add single quotes
  AND TABLE_SCHEMA = 'dbo' -- Include the schema name

-- Rename the headers name to be well fitted...
EXEC sp_rename 'world_co2_emission_dataset.Year', 'Record (Year)', 'COLUMN'
EXEC sp_rename 'world_co2_emission_dataset.F4', 'Series', 'COLUMN'
EXEC sp_rename 'world_co2_emission_dataset.Values', 'Metric Values', 'COLUMN'
EXEC sp_rename 'world_co2_emission_dataset.F6', 'Footnotes', 'COLUMN'
EXEC sp_rename 'world_co2_emission_dataset.F7', 'Source', 'COLUMN'

-- Delete the First Row since its irrelevant with null values...
DELETE FROM world_co2_emission_dataset
WHERE T26 IS NULL AND "CO2 emission estimates" IS NULL

SELECT * FROM world_co2_emission_dataset

-- Check for null values in all the columns...

SELECT 
    SUM(CASE WHEN T26 IS NULL THEN 1 ELSE 0 END) as T26,
    SUM(CASE WHEN [CO2 emission estimates] IS NULL THEN 1 ELSE 0 END) as [CO2 emission estimates],
    SUM(CASE WHEN [Record (Year)] IS NULL THEN 1 ELSE 0 END) as [Record (Year)],
    SUM(CASE WHEN Series IS NULL THEN 1 ELSE 0 END) as Series,
    SUM(CASE WHEN [Metric Values] IS NULL THEN 1 ELSE 0 END) as [Metric Values],
    SUM(CASE WHEN Footnotes IS NULL THEN 1 ELSE 0 END) as Footnotes,
    SUM(CASE WHEN Source IS NULL THEN 1 ELSE 0 END) as Source
FROM world_co2_emission_dataset;

-- Data Extraction: Extract 'Emissions (thousand metric tons of carbon dioxide)'
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source


-- Data Extraction: Extract 'Emissions per capita (metric tons of carbon dioxide)'
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source

-- Create a Temp Table out of the above...
DROP TABLE IF EXISTS #Temp_thousand_metric_tons_of_co2

CREATE TABLE #Temp_thousand_metric_tons_of_co2(
	T26 int,
	[Co2 emission estimates] varchar(255),
	[Record (Year)] int, 
	Series varchar(255), 
	[Metric Values] int, 
	Footnotes varchar(255),
	Source varchar(255)
)

INSERT INTO #Temp_thousand_metric_tons_of_co2
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source

SELECT TOP 10 * FROM #Temp_thousand_metric_tons_of_co2

-- Create a Temp Table (Emissions per capita (metric tons of carbon dioxide)
DROP TABLE IF EXISTS #Temp_em_per_capita_tons_of_co2

CREATE TABLE #Temp_em_per_capita_tons_of_co2(
	T26 int,
	[Co2 emission estimates] varchar(255),
	[Record (Year)] int, 
	Series varchar(255), 
	[Metric Values] int, 
	Footnotes varchar(255),
	Source varchar(255)
)

INSERT INTO #Temp_em_per_capita_tons_of_co2
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source

SELECT TOP 10 * FROM #Temp_em_per_capita_tons_of_co2


-- Create a view from the "Emissions per capita (metric tons of carbon dioxide)"..
CREATE VIEW em_per_capita_tons_of_co2
AS 
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions per capita (metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source


-- Create a view from the "Emissions per capita (metric tons of carbon dioxide)"..
CREATE VIEW thousand_metric_tons_of_co2
AS 
SELECT T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source FROM world_co2_emission_dataset
WHERE Series = 'Emissions (thousand metric tons of carbon dioxide)'
GROUP BY T26, [CO2 emission estimates], [Record (Year)], Series, [Metric Values], Footnotes, Source


-- See data from the view...
SELECT TOP 5 * FROM thousand_metric_tons_of_co2

SELECT TOP 5 * FROM em_per_capita_tons_of_co2

