-- Exploratory Data Analysis

-- I'm going to explore the data and find trends, patterns or anything interesting

-- starting by selecting all data
Select *
from layoffs_staging2;

-- Looking at the pecentage to see how big these layoffs were
Select max(total_laid_off), max(percentage_laid_off) 
from layoffs_staging2;


-- Which of these companies had 1% layoffs ordering it by their total layoffs from the biggest to the smallest
 Select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;
-- Katerra, A construction company had the highest total number of layoffs


-- Looking at the top 10 companies with the most total layoffs using Groupby
Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
Limit 10;

Select min(`date`), max(`date`)
from layoffs_staging2;

-- by industry
Select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
Limit 10;

-- by Country
Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc
Limit 10;

-- by the year
Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc
Limit 10;

-- by stage
Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc
limit 10;

-- Using Substring to determine the most laidoff by months
select substring(`date`, 1,7) As `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 ;


-- Using CTE to determine the Rolling Total of layoffs using the Substring query above
with Rolling_total as
(
select substring(`date`, 1,7) As `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 
)
select `Month`, total_off
, sum(total_off) over(order by `Month`) as rolling_total
from Rolling_total;

-- Looking at the most total laidoff by company withinin a year
Select company, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc ;
-- Google is the most from the dataset

-- Ranking the top 10 Companies by their total layoffs per year using CTE
with company_year (company, years, total_laid_off) as
(
Select company, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as 
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 10
;

-- by Industry
Select industry, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by industry, year(`date`)
order by 3 desc ;


with industry_year (industry, years, total_laid_off) as
(
Select industry, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by industry, year(`date`)
), industry_year_rank as 
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from industry_year
where years is not null
)
select *
from industry_year_rank
where ranking <= 10
;

-- by Country
Select country, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by country, year(`date`)
order by 3 desc ;


with country_year (country, years, total_laid_off) as
(
Select country, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by country, year(`date`)
), country_year_rank as 
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from country_year
where years is not null
)
select *
from country_year_rank
where ranking <= 5
;