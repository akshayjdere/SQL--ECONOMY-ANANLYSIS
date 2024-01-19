SHOW DATABASES;

CREATE database economy;

USE economy;

-- 1.Select all data from a specific file:
SELECT * FROM `bgd-646 ppg bilateral debt`;
SELECT * FROM `btn-646 ppg bilateral debt`;
SELECT * FROM `lka-646 ppg bilateral debt`;
SELECT * FROM `mdv-646 ppg bilateral debt`; 
SELECT * FROM `mmr-646 ppg bilateral debt`;
SELECT * FROM `npl-646 ppg bilateral debt`;


-- 2.Filter data based on a specific condition:
 SELECT * 
 FROM `bgd-646 ppg bilateral debt` 
 WHERE year = 2020;
 
 -- 3.Aggregate data by year:
SELECT year, sum(data) as total_d
from `bgd-646 ppg bilateral debt` 
group by year;

-- 4.Average Debt for Each Year
SELECT year, AVG(data) AS average_debt
FROM `bgd-646 ppg bilateral debt`
WHERE indicator = 'DT.DOD.BLAT.CD'
GROUP BY year
ORDER BY year;

-- 5.Find the highest debtor in a specific year:
SELECT year, debtor, MAX(data) AS max_debt
FROM `bgd-646 ppg bilateral debt`
WHERE year = 2019
GROUP BY year, debtor;

-- 6.Join data from multiple files based on a common column:
SELECT A.*, B.*
FROM `bgd-646 ppg bilateral debt` as A
inner JOIN `btn-646 ppg bilateral debt` as B ON A.year = B.year AND A.creditor=B.creditor;


-- 7 .Calculate the year-over-year growth in total debt for a specific creditor:

SELECT year, creditor, SUM(data) AS total_debt,
       LAG(SUM(data)) OVER (PARTITION BY creditor ORDER BY year) AS previous_year_debt
FROM `bgd-646 ppg bilateral debt`
GROUP BY year, creditor;

-- 8.Calculate the year-over-year percentage growth in total debt for each creditor:

SELECT year, creditor,
       (SUM(data) - LAG(SUM(data)) OVER (PARTITION BY creditor ORDER BY year)) / LAG(SUM(data)) OVER (PARTITION BY creditor ORDER BY year) * 100 AS debt_growth_percentage
FROM `bgd-646 ppg bilateral debt`
GROUP BY year, creditor;

-- 9.Yearly Percentage Change in Debt

SELECT t1.year, t1.debtor, t1.data AS current_debt,
       LAG(t1.data) OVER (PARTITION BY t1.debtor ORDER BY t1.year) AS previous_debt,
       (t1.data - LAG(t1.data) OVER (PARTITION BY t1.debtor ORDER BY t1.year)) / LAG(t1.data) OVER (PARTITION BY t1.debtor ORDER BY t1.year) * 100 AS percentage_change
FROM `bgd-646 ppg bilateral debt` t1
WHERE t1.indicator = 'DT.DOD.BLAT.CD'
ORDER BY t1.debtor, t1.year;

-- 10 .Average Debt Across All Countries for Each Year:
SELECT debtor, AVG(data) AS avg_debt
FROM `bgd-646 ppg bilateral debt`
WHERE indicator = 'DT.DOD.BLAT.CD'
GROUP BY debtor
ORDER BY avg_debt DESC;
 