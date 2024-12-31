-- DATA CLEANING

Select * 
from layoffs;

-- 1. Removing Duplicates
-- 2. Standardize the Data (i.e Spelling, Trim e.t.c)
-- 3. Null Values or Blank Values
-- 4. Removing Columns or Rows if necessary


-- To avoid tampering with the raw dataset, i create a 'layoffs_staging' Table and import the actual data from 'layoffs' 

create table layoffs_staging
like layoffs;

Select * 
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;


-- inserting row_number for easier removal of duplicates

select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1
;


-- TO delete duplicate we need create layoffs_staging2 using the dataset from layoffs_staging includig row_num


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging;

select *
from layoffs_staging2
where row_num > 1
;

Delete
from layoffs_staging2
where row_num > 1
;

Set sql_safe_updates = 0;

select *
from layoffs_staging2;


-- Standardizing Data

select company, trim(company)
from layoffs_staging2;

update layoffs_stagin2
set company = trim(company); 


select distinct industry
from layoffs_staging2
order by 1;


select *
from layoffs_staging2
where industry like 'Crypto%';


Update layoffs_staging2
set industry = 'Cryptocurrency'
where industry like 'Crypto%';

select distinct location 
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

update layoffs_staging2
set country ='United States'
where country like 'United States%'
;
-- changing date data type from 'text' to 'date' column 

select `date`,
str_to_date(`date`, '%m/%d/%Y') as DATE
from layoffs_staging2;

update layoffs_staging2
set date = str_to_date(`date`, '%m/%d/%Y');

select date
from layoffs_staging2;

Alter Table layoffs_staging2
Modify column `date` DATE;

-- Nulls 

select *
from layoffs_staging2
where total_laid_off is Null
And percentage_laid_off is Null;

update layoffs_staging2
set industry = Null
where industry = '';

select *
from layoffs_staging2
where industry is Null;

select *
from layoffs_staging2
where company = 'Airbnb';

select *
from layoffs_staging2 st1
join layoffs_staging2 st2
	on st2.company = st1.company
where st1.industry is Null 
and st2.industry is Not Null;

select st1.industry, st2.industry
from layoffs_staging2 st1
join layoffs_staging2 st2
	on st2.company = st1.company
where st1.industry is Null 
and st2.industry is Not Null;

update layoffs_staging2 st1
join layoffs_staging2 st2
	on st2.company = st1.company
set st1.industry = st2.industry
where st1.industry is Null 
and st2.industry is Not Null;

-- Removing Or Dropping columns;

delete
from layoffs_staging2
where total_laid_off is Null
And percentage_laid_off is Null;

select *
from layoffs_staging2;

-- Droping Row_num we created above

Alter Table layoffs_staging2
drop column row_num;
























