/*Percentiles of income in the context of education
Analysis of the distribution of key financial metrics (median, 25th and 75th percentiles) without using the built-in percentile functions

Перцентили доходов в разрезе образования
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
Summary — clients with Education = 1 have the highest income: median $79k (P25–P75: $43k–$123k) vs. $54k for Graduate and $59k for Advanced/Professional. They also spend more on credit cards (median CCAvg 1.7 vs. 1.5 and 1.4). This is not necessarily a data error: in the original dataset Education = 1 means "Undergrad" (bachelor's degree), not "no education", and the groups have the same median age (45–46) and experience (~20 years), so the "outdated data" hypothesis is not supported.
Business takeaway: education strongly changes how high-income clients respond to a personal loan — with income above $100k, 78–79% of Graduate/Professional clients accepted the offer vs. only 10% of Undergrad clients. Income alone is not enough for targeting; combine it with education. 
Data quality note: 52 clients have negative Experience — to be checked with the data owner.

Резюме — у клиентов с Education = 1 самый высокий доход: медиана $79 тыс. (P25–P75: $43–123 тыс.) против $54 тыс. у Graduate и $59 тыс. у Advanced/Professional. По картам они тоже тратят больше (медиана CCAvg 1,7 против 1,5 и 1,4). Это не обязательно ошибка данных: в исходном датасете Education = 1 означает «Undergrad» (бакалавр), а не «без образования», а медианный возраст (45–46 лет) и стаж (~20 лет) во всех группах одинаковы, поэтому гипотеза об устаревших данных не подтверждается.
Вывод для бизнеса: образование сильно влияет на отклик клиентов с высоким доходом — при доходе выше $100 тыс. личный заём приняли 78–79% клиентов Graduate/Professional и только 10% клиентов Undergrad. Для таргетинга одного дохода недостаточно — его нужно сочетать с образованием. 
Качество данных: у 52 клиентов отрицательный стаж (Experience) — требует проверки у владельца данных.
*/
