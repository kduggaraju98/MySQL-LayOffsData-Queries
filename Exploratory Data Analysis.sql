-- Exploratory data Analysis 

Select * from layoffs_staging2;

Select MAX(total_laid_off),MAX(percentage_laid_off)
from layoffs_staging2;

Select * from layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


Select company , SUM(total_laid_off)
 from layoffs_staging2
 Group By company
 Order BY 2 DESC;
 
 Select min(`date`), max(`date`)
 from layoffs_staging2;
 
Select YEAR(`date`) , SUM(total_laid_off)
 from layoffs_staging2
 Group By YEAR(`date`)
 Order BY 1 DESC;
 
 
 Select stage , SUM(total_laid_off)
 from layoffs_staging2
 GROUP BY stage
 Order BY 2 DESC;
 
 Select company , AVG(percentage_laid_off)
 from layoffs_staging2
 Group By company
 Order BY 2 DESC;
 
 select *
 from layoffs_staging2;
 
 Select substring(`date`,1,7) AS `Month`, SUM(total_laid_off)
 from layoffs_staging2
 where substring(`date`,1,7) IS NOT NULL
 group by `month`
 Order by 1 ASC;
 
WITH Rolling_Total AS
(
Select substring(`date`,1,7) AS `Month`, SUM(total_laid_off) as total_off
 from layoffs_staging2
 where substring(`date`,1,7) IS NOT NULL
 group by `month`
 Order by 1 ASC
)
Select `MONTH`, total_off,
 SUM(total_off) OVER(Order by `MONTH`) As Rolling_Total
from rolling_Total;


Select company , YEAR(`date`), sum(total_laid_off)
 from layoffs_staging2
 Group By company, YEAR(`date`)
 Order BY 3 DESC;
 
 
Select company , sum(total_laid_off)
 from layoffs_staging2
 Group By company
 Order BY 2 DESC;  
 
 WITH Company_Year (Company, Years, Total_Offs) AS
 (
 Select company , YEAR(`date`), sum(total_laid_off)
 from layoffs_staging2
 Group By company, YEAR(`date`)
 ), Company_Year_Rank AS 
 (SELECT *, dense_rank() OVER(PARTITION BY years ORDER BY total_Offs DESC) AS Ranking
 FROM Company_Year
 Where Years IS NOT NULL)
 Select * 
 From Company_Year;
