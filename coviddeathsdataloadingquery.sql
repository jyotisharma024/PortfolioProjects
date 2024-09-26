use newdb;
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv" 
INTO TABLE coviddeaths1 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@total_cases, other_column_1, other_column_2, ...)
SET total_cases = NULLIF(@total_cases, '');

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv"
INTO TABLE coviddeaths1
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@iso_code, @continent, @location, @population, @date, @total_cases, @new_cases, 
@new_cases_smoothed, @total_deaths, @new_deaths, @new_deaths_smoothed, @total_cases_per_million, 
@new_cases_per_million, @new_cases_smoothed_per_million, @total_deaths_per_million, 
@new_deaths_per_million, @new_deaths_smoothed_per_million, @reproduction_rate, @icu_patients, 
@icu_patients_per_million, @hosp_patients, @hosp_patients_per_million, @weekly_icu_admissions, 
@weekly_icu_admissions_per_million, @weekly_hosp_admissions, @weekly_hosp_admissions_per_million)
SET 
    iso_code = @iso_code,
    continent = @continent,
    location = @location,
    population = NULLIF(@population, ''),
    date = @date,
    total_cases = NULLIF(@total_cases, ''),
    new_cases = NULLIF(@new_cases, ''),
    new_cases_smoothed = @new_cases_smoothed,
    total_deaths = @total_deaths,
    new_deaths = @new_deaths,
    new_deaths_smoothed = @new_deaths_smoothed,
    total_cases_per_million = @total_cases_per_million,
    new_cases_per_million = @new_cases_per_million,
    new_cases_smoothed_per_million = @new_cases_smoothed_per_million,
    total_deaths_per_million = @total_deaths_per_million,
    new_deaths_per_million = @new_deaths_per_million,
    new_deaths_smoothed_per_million = @new_deaths_smoothed_per_million,
    reproduction_rate = @reproduction_rate,
    icu_patients = @icu_patients,
    icu_patients_per_million = @icu_patients_per_million,
    hosp_patients = @hosp_patients,
    hosp_patients_per_million = @hosp_patients_per_million,
    weekly_icu_admissions = @weekly_icu_admissions,
    weekly_icu_admissions_per_million = @weekly_icu_admissions_per_million,
    weekly_hosp_admissions = @weekly_hosp_admissions,
    weekly_hosp_admissions_per_million = @weekly_hosp_admissions_per_million;
    
    ALTER TABLE coviddeaths1 MODIFY population BIGINT;