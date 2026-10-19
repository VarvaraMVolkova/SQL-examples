/*Cumulative distribution (CDF) of clients by income level
Cumulative total of the share of clients and the accumulated amount of income to assess the concentration of capital.

Кумулятивное распределение (CDF) клиентов по уровню дохода
Накопительный итог доли клиентов и накопленная сумма доходов для оценки концентрации капитала.
*/ 

WITH IncomeDistribution AS (
    SELECT 
        Income,
        COUNT(*) AS clients_cnt,
        SUM(Income) AS total_income_group
    FROM CreditoPersonal
    GROUP BY Income
),
RunningTotals AS (
    SELECT 
        Income,
        clients_cnt,
        SUM(clients_cnt) OVER(ORDER BY Income) AS running_clients,   -- CNT clients is a running total
        SUM(total_income_group) OVER(ORDER BY Income) AS running_income,
        SUM(clients_cnt) OVER() AS total_clients,
        SUM(total_income_group) OVER() AS total_income
    FROM IncomeDistribution
) --select * from RunningTotals
SELECT 
    Income,
    ROUND(100.0 * running_clients / total_clients, 2) AS cumulative_clients_pct,
    ROUND(100.0 * running_income / total_income, 2) AS cumulative_income_pct
FROM RunningTotals
ORDER BY Income;

/*
Summary modeling showed that about 360 clients currently meet the stated conditions in all regions, which is about 7% of the total number of clients. The task statement does not specify a threshold for the viability of the project

резюме -моделирование показало, что по всем регионам на текущий момент заявленным условиям удовлетворяют около 360 клиентов, что составляет около 7% от общего числа клиентов. В постановке задачи не указан порог жизнеспособности проекта
*/