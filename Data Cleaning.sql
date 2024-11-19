-- Data Cleaning

Select * 
from layoffs;

-- 1) Remove Duplicates
-- 2) Standardize the Data
-- 3) Null Values/ Black Values
-- 4) Remove any columns


Create table layoffs_staging
Like layoffs;

Select * 
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

-- -- 1) Remove Duplicates

select *,
row_number() over(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) As row_num
from layoffs_staging;

WITH duplicate_cte AS
(
select *,
row_number() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) As row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

select *
from layoffs_staging
WHERE company= "Casper";

WITH duplicate_cte AS
(
select *,
row_number() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) As row_num
from layoffs_staging
)
Delete
from duplicate_cte
where row_num >1;



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


Select * 
from layoffs_staging2
where row_num >1;


Insert Into layoffs_staging2
select *,
row_number() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) As row_num
from layoffs_staging;

Delete
from layoffs_staging2
where row_num > 1;

Select * 
from layoffs_staging2;

-- 2) Standardizing Data

Select company, Trim(company)
from layoffs_staging2;

Update layoffs_staging2
set company = Trim(company);

Select *
from layoffs_staging2
where industry like 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


Select distinct country, trim(trailing "." from country)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
order by 1;

Update layoffs_staging2
set country = trim(trailing "." from country)
Where country like 'United States%';

select `date`,
STR_TO_DATE(`date`,'%m/%d/%Y') AS Date
from layoffs_staging2;

Update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
modify column `date` Date;

Select * 
from layoffs_staging2
where total_laid_off IS NULL
And percentage_laid_off IS NULL;

Select *
from layoffs_staging2
where industry IS NULL OR industry = '';

SELECT *
from layoffs_staging2
where company LIKE 'Bally%';

Update layoffs_staging2
SET industry = NULL
WHERE industry = '';

select t1.industry, t2.industry
from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location 
WHERE (t1.industry IS NULL OR t1.industry= '')
AND t2.industry iS NOT NULL;

Update layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry iS NOT NULL;
    
Select *
from layoffs_staging2;


Select * 
from layoffs_staging2
where total_laid_off IS NULL
And percentage_laid_off IS NULL;

DELETE 
from layoffs_staging2
where total_laid_off IS NULL
And percentage_laid_off IS NULL;


ALTER table layoffs_staging2
DROP column row_num;

Select *
from layoffs_staging2;