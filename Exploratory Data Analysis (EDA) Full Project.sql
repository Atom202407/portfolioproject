-- Exploratory Data Analysis

Select *
from layoffs_staging2;


Select max(total_laid_off), max(percentage_laid_off) 
from layoffs_staging2;

Select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

Select min(`date`), max(`date`)
from layoffs_staging2;

Select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


select substring(`date`, 1,7) As `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 ;

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


Select company, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc ;


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