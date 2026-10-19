/* Premium segment "5-5-5": top quintile by income, card spending and mortgage. Compares its personal-loan conversion with the overall rate.

Многомерная сегментация клиентов (RFM-подобный подход по доходу, тратам и ипотеке)
Присвоение клиентам рангов (квинтелей от 1 до 5) по трем осям с помощью NTILE и выявление премиального сегмента «5-5-5».
*/

WITH scored AS (
    SELECT
        ID,
        [Personal loan] AS loan,
        NTILE(5) OVER (ORDER BY Income, ID) AS income_score,
        NTILE(5) OVER (ORDER BY CCAvg, ID) AS cc_score,
        NTILE(5) OVER (ORDER BY Mortgage, ID) AS mortgage_score
    FROM CreditoPersonal
),
overall AS (
    SELECT 1.0 * SUM([Personal loan]) / COUNT(*) AS rate FROM CreditoPersonal -- 0.096
)
SELECT
    COUNT(*)                                          AS clients_count,
    ROUND(100.0 * SUM(s.loan) / COUNT(*), 2)          AS segment_conversion_pct,
    ROUND(100.0 * MAX(o.rate), 2)                     AS overall_conversion_pct,
    ROUND((1.0 * SUM(s.loan) / COUNT(*)) / MAX(o.rate), 2) AS lift_x
FROM scored s
CROSS JOIN overall o
WHERE s.income_score = 5
  AND s.cc_score = 5
  AND s.mortgage_score = 5;
  
  
--  SELECT COUNT(*) AS total, sum(case when  Mortgage = 0 then 1 else 0 end) AS zero_mortgage, 100*sum(case when  Mortgage = 0 then 1 else 0 end) / count(*) FROM CreditoPersonal;
 
 /*
 Summary -the sample provided is small and the output is approximate. It is advisable to do it on a full database. Previously, less than 200 customers belong to the Premium segment, which is less than 10% of the conversion rate
 
 резюме -предоставленная выборка небольшая и вывод ориентировочный. Желательно сделать на полной базе. Предварительно - менее 200 клиентов относятся к Премиум сегменту, что составляет менее 10% конверсии


 */