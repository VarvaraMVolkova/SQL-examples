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
Summary — income is moderately concentrated: the lower half of clients (income up to $64k)
earns only 26% of total income, while the top 20% (income above ~$113k) earns about 40%
and the top 10% (above ~$145k) about 23%. Median income is $64k vs. a mean of $74k:
the distribution is right-skewed, pulled up by a small group of high earners.
For the business this means that the income base — and the potential for credit products —
sits in a relatively small segment. These clients should be prioritised in campaigns:
clients with income above $100k are the ones who accept personal-loan offers,
while below $50k there are no conversions in the last campaign.

Резюме — доходы клиентов умеренно сконцентрированы: нижняя половина клиентов
(доход до $64 тыс.) получает лишь 26% совокупного дохода, тогда как верхние 20%
(доход выше ~$113 тыс.) — около 40%, а верхние 10% (выше ~$145 тыс.) — около 23%.
Медиана дохода $64 тыс. при среднем $74 тыс.: распределение скошено вправо
за счёт небольшой группы клиентов с высоким доходом.
Для бизнеса это значит, что доходная база, а значит и потенциал кредитных продуктов,
сосредоточена в относительно небольшом сегменте. Именно его стоит приоритизировать
в кампаниях: личный заём принимают клиенты с доходом выше $100 тыс., а среди клиентов
с доходом до $50 тыс. конверсий в последней кампании не было.
*/
