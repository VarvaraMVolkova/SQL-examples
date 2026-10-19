/*Percentiles of income and expenses on credit cards in the context of education
Analysis of the distribution of key financial metrics (median, 25th and 75th percentiles) without using the built-in percentile functions

Перцентили доходов и трат по кредиткам в разрезе образования
Анализ распределения ключевых финансовых метрик (медиана, 25-й и 75-й перцентили) без использования встроенных функций перцентилей
*/

WITH RankedData AS (
    SELECT 
        Education,
        Income,
        CCAvg,
        ROW_NUMBER() OVER(PARTITION BY Education ORDER BY Income) AS rn,
        COUNT(*) OVER(PARTITION BY Education) as cnt
    FROM CreditoPersonal
	where Education is not NULL
)
SELECT 
     case when Education = 1 then 'No graduado'
		 when Education = 2 then 'Graduado'
		 when Education = 3 then 'Profesional'end   Education,
    MAX(CASE WHEN rn = CAST(cnt * 0.5 AS INTEGER) THEN Income END) AS median_income,
    MAX(CASE WHEN rn = CAST(cnt * 0.25 AS INTEGER) THEN Income END) AS p25_income,
    MAX(CASE WHEN rn = CAST(cnt * 0.75 AS INTEGER) THEN Income END) AS p75_income
FROM RankedData
GROUP BY Education;

/*
Summary - data quality verification is required, as the analysis showed that clients without education have the highest income. There is a possibility that the data is outdated and the Client has already received an education. Update customer data

Резюме - требуется проведение проверки и качества данных, так как анализ показал, что наибольший доход имеют клиенты без образования. Есть вероятность, что данные устарели и Клиент уже получил образование. Актуализировать данные по клиентам
*/