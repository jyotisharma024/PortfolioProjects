-- to upload a big dataset, first we have to create a table in mysql so that through load data infile 
-- we can insert the values of each column in it
-- below is the query to create  the table 

CREATE TABLE `newdb`.`covidvaccinations` (`iso_code` text, 
`continent` text, 
`location` text,
 `date` text, 
 `new_tests` text, 
 `total_tests` text, 
 `total_tests_per_thousand`text,
 `new_tests_per_thousand` text, 
 `new_tests_smoothed` text, 
 `new_tests_smoothed_per_thousand`text,
 `positive_rate` text, 
 `tests_per_case` text, 
 `tests_units` text, 
 `total_vaccinations` text, 
 `people_vaccinated` text,
 `people_fully_vaccinated` text, 
 `new_vaccinations` text, 
 `new_vaccinations_smoothed` text, 
 `total_vaccinations_per_hundred` text, 
 `people_vaccinated_per_hundred` text, 
 `people_fully_vaccinated_per_hundred` text,
 `new_vaccinations_smoothed_per_million` text, 
 `stringency_index` double, 
 `population_density` double, 
 `median_age` double,
 `aged_65_older` double, 
 `aged_70_older` double, 
 `gdp_per_capita` double,
 `extreme_poverty` text, 
 `cardiovasc_death_rate` double, 
 `diabetes_prevalence` double, 
 `female_smokers` text, 
 `male_smokers` text,
 `handwashing_facilities` double,
 `hospital_beds_per_thousand` double, 
 `life_expectancy` double, 
 `human_development_index` double)	;
 use newdb;

    


-- loading data to mysql after creating table
 
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidVaccinations.csv" 
INTO TABLE covidvaccinations 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS 
(@iso_code, @continent, @location, @date, @new_tests, @total_tests, 
 @total_tests_per_thousand, @new_tests_per_thousand, @new_tests_smoothed, 
 @new_tests_smoothed_per_thousand, @positive_rate, @tests_per_case, 
 @tests_units, @total_vaccinations, @people_vaccinated, 
 @people_fully_vaccinated, @new_vaccinations, @new_vaccinations_smoothed, 
 @total_vaccinations_per_hundred, @people_vaccinated_per_hundred, 
 @people_fully_vaccinated_per_hundred, @new_vaccinations_smoothed_per_million, 
 @stringency_index, @population_density, @median_age, @aged_65_older, 
 @aged_70_older, @gdp_per_capita, @extreme_poverty, 
 @cardiovasc_death_rate, @diabetes_prevalence, @female_smokers, 
 @male_smokers, @handwashing_facilities, @hospital_beds_per_thousand, 
 @life_expectancy, @human_development_index) 
SET 
    iso_code = @iso_code,
    continent = @continent,
    location = @location,
    date = STR_TO_DATE(@date, '%d-%m-%Y'),
    new_tests = NULLIF(@new_tests, ''),
    total_tests = NULLIF(@total_tests, ''),
    total_tests_per_thousand = NULLIF(@total_tests_per_thousand, ''),
    new_tests_per_thousand = NULLIF(@new_tests_per_thousand, ''),
    new_tests_smoothed = NULLIF(@new_tests_smoothed, ''),
    new_tests_smoothed_per_thousand = NULLIF(@new_tests_smoothed_per_thousand, ''),
    positive_rate = NULLIF(@positive_rate, ''),
    tests_per_case = NULLIF(@tests_per_case, ''),
    tests_units = @tests_units,
    total_vaccinations = NULLIF(@total_vaccinations, ''),
    people_vaccinated = NULLIF(@people_vaccinated, ''),
    people_fully_vaccinated = NULLIF(@people_fully_vaccinated, ''),
    new_vaccinations = NULLIF(@new_vaccinations, ''),
    new_vaccinations_smoothed = NULLIF(@new_vaccinations_smoothed, ''),
    total_vaccinations_per_hundred = NULLIF(@total_vaccinations_per_hundred, ''),
    people_vaccinated_per_hundred = NULLIF(@people_vaccinated_per_hundred, ''),
    people_fully_vaccinated_per_hundred = NULLIF(@people_fully_vaccinated_per_hundred, ''),
    new_vaccinations_smoothed_per_million = NULLIF(@new_vaccinations_smoothed_per_million, ''),
    stringency_index = NULLIF(@stringency_index, ''),
    population_density = NULLIF(@population_density, ''),
    median_age = NULLIF(@median_age, ''),
    aged_65_older = NULLIF(@aged_65_older, ''),
    aged_70_older = NULLIF(@aged_70_older, ''),
    gdp_per_capita = NULLIF(@gdp_per_capita, ''),
    extreme_poverty = @extreme_poverty,
    cardiovasc_death_rate = NULLIF(@cardiovasc_death_rate, ''),
    diabetes_prevalence = NULLIF(@diabetes_prevalence, ''),
    female_smokers = NULLIF(@female_smokers, ''),
    male_smokers = NULLIF(@male_smokers, ''),
    handwashing_facilities = NULLIF(@handwashing_facilities, ''),
    hospital_beds_per_thousand = NULLIF(@hospital_beds_per_thousand, ''),
    life_expectancy = NULLIF(@life_expectancy, ''),
    human_development_index = NULLIF(@human_development_index, '');
