SELECT * FROM newdb.nashville_housing_data;

# cleaning data in sql queries
use newdb;

# Converting the saledate column text to date type
select saledate from nashville_housing_data;

-- As my date format was this 'april 9,2013, so exatracted the dates in '%M %d,%Y' format
UPDATE nashville_housing_data
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');
# SET SQL_SAFE_UPDATES = 0;

-- finally changing the datatype of the coulumn form text to date
alter table nashville_housing_data
modify SaleDate date;

# Polulate property address data
select propertyaddress from nashville_housing_data 
where propertyaddress is null or propertyaddress='';

/* here writing the query just to check the output
 select a.ParcelID, a.PropertyAddress,b.PropertyAddress, b.ParcelID, COALESCE(a.PropertyAddress, b.PropertyAddress) as new from nashville_housing_data a
join nashville_housing_data b
on a.ParcelID=b.ParcelID 
and a.UniqueID !=b.UniqueID
where a.propertyaddress is null;*/

# this is the actual query to update the table to populate the null propertyaddress values 
update nashville_housing_data a
join nashville_housing_data b
on a.ParcelID=b.ParcelID 
and a.UniqueID !=b.UniqueID
set a.propertyaddress=coalesce(a.propertyaddress,b.propertyaddress )
where a.propertyaddress is null;


# Breaking out address into individual columns(Address, city, state)

-- just checking the output
-- select propertyaddress, 
-- substring(propertyaddress,1,instr(propertyaddress,',')-1) as address, 
-- substring(propertyaddress,instr(propertyaddress,',')+2 ) as city
-- from nashville_housing_data;

# actual queries are below 4 queries where fiert have to create two new columns and then update them
alter table nashville_housing_data
add address varchar(225);

alter table nashville_housing_data
add city varchar(225);

update nashville_housing_data
set address=substring(propertyaddress,1,instr(propertyaddress,',')-1);
update nashville_housing_data
set city=substring(propertyaddress,instr(propertyaddress,',')+2 );

# again we have to follow the same steps for the column owneraddress
/* checking the output
SELECT 
    SUBSTRING_INDEX(owneraddress, ',', 1) AS StreetAddress,
    TRIM(SUBSTRING(owneraddress, LOCATE(',', owneraddress) + 1, 
                  LOCATE(',', owneraddress, LOCATE(',', owneraddress) + 1) - LOCATE(',', owneraddress) - 1)) AS City,
    TRIM(SUBSTRING_INDEX(owneraddress, ',', -1)) AS State
FROM 
    nashville_housing_data;
    # here is another mathod also to extract the city
   -- SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2), ',', -1)) AS City
-- FROM nashville_housing_data;*/

# these are the steps to create individual coulumns for street address, city and state 
alter table nashville_housing_data
add ownerStreetAddress varchar(225);

alter table nashville_housing_data
add ownercityaddress varchar(225);

alter table nashville_housing_data
add OwnerState varchar(225);

update nashville_housing_data
set ownerStreetAddress=SUBSTRING_INDEX(owneraddress, ',', 1);
update nashville_housing_data
set ownercityaddress=TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2), ',', -1));
update nashville_housing_data
set OwnerState=TRIM(SUBSTRING_INDEX(owneraddress, ',', -1));

/* select ownercityaddress, ownerstate, ownerstreetaddress from nashville_housing_data;
alter table nashville_housing_data
change address propertystreetaddress varchar(225);
alter table nashville_housing_data
change city propertycityaddress  varchar(225); */

# Change y to yes and n to No in soldasvacant
/* just checking if it works in this way and it worked we can also do the same without using 
replace function which i have done below 
select  SoldAsVacant, 
case
when SoldAsVacant ='N' then 
replace(soldasvacant,'N','No')
when SoldAsVacant ='Y' then 
replace(soldasvacant,'Y','Yes')
else SoldAsVacant
 
 end as newsoldasvacant 
from nashville_housing_data;*/

# this the actual query to use change 'Y' to Yes and 'N' to No
UPDATE nashville_housing_data 
SET 
soldasvacant = CASE 
    WHEN SoldAsVacant = 'N' THEN 'No' 
    WHEN SoldAsVacant = 'Y' THEN 'Yes' 
    ELSE SoldAsVacant 
END 
WHERE SoldAsVacant IN ('N', 'Y');  -- Ensure to filter based on your criteria
 
# Removing duplicates from the table
/* we can do it number of ways although it is not recommended to remove the data from the data 
but for the knowledge we can do it .
here we use the CTE and some window function to remove duplicates.*/

/* first we need to recognize the duplicaes rows that we can do by using window functions like 
row_number, rank, etc*/

with numberedrow as
(select *,
row_number() 
over(partition by parcelid, propertyaddress,saledate,saleprice,LegalReference
  order by uniqueid) as rownumber
 from nashville_housing_data)
select *from numberedrow
where rownumber>1;
 
 delete from nashville_housing_data
 where UniqueID in (select uniqueid
    FROM (
        SELECT uniqueid,
               ROW_NUMBER() OVER (PARTITION BY parcelid, propertyaddress, saledate, saleprice, LegalReference ORDER BY uniqueid) AS rownumber
        FROM nashville_housing_data
    ) as numbered_rows
    WHERE rownumber > 1
    );
    
    # update the saleprice column to int type so that it can be used for calculation purpose:
    # for that first we have to check whether the column has non-numeric values in it or not 
    # if yes we will update by removing them using replace function
    # finally we will alter the table to int
   
   select saleprice from nashville_housing_data 
    where SalePrice regexp '[^0-9]';
    
    update nashville_housing_data
    set saleprice=replace(replace(replace(saleprice,',',''),'$',''),' ','')
    where SalePrice regexp '[^0-9]';
    
 alter table nashville_housing_data modify SalePrice int;
 
 
 # removing the unused columns from the table
 alter table nashville_housing_data
 drop column OwnerAddress,
 drop column PropertyAddress,
 drop column TaxDistrict;
    