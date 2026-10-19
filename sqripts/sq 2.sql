/*Portrait of the "Ideal candidate" through logical profiling (additive scoring)
, assigning points to customers based on a set of product and demographic criteria, followed by ranking the deciles of the target audience.
The points are awarded based on logic, whether there is or not.

Портрет «Идеального кандидата» через логическое профилирование (аддитивный скоринг)
Присхождение баллов клиентам по набору продуктовых и демографических критериев с последующим ранжированием децилей целевой аудитории.
Присвоение баллов  производится из логики - есть или нет.
*/

WITH ScoredClients AS ( --Yes or No
SELECT 
        ID,
        [Personal loan],
        (
            CASE WHEN Income >= 100 THEN 1 ELSE 0 END +
            CASE WHEN CCAvg >= 2.5 THEN 1 ELSE 0 END +
            CASE WHEN Education = 3 THEN 1 ELSE 0 END +
            CASE WHEN [Securities account] = 1 THEN 1 ELSE 0 END +
            CASE WHEN [CD Account] = 1 THEN 1 ELSE 0 END +
            CASE WHEN Mortgage > 200 THEN 1 ELSE 0 END
        ) AS total_score
    FROM CreditoPersonal
)
SELECT 
    total_score,
    COUNT(*) AS clients_count,
    SUM([Personal loan]) as conversions,
    ROUND(100.0 * SUM([Personal loan]) / COUNT(*), 2) AS conversion_rate
FROM ScoredClients
GROUP BY total_score
ORDER BY total_score DESC;

/*
Summary: the assignment of points is simplified and the results of the analysis should be clarified in the future after the customer has determined a complete description of the logic of assigning points to the client.

Currently, using the results is not preferable due to the simplified calculation. More than 2/3 of all customers are below the 20% conversion rate.

Резюме: присвоение баллов носит упрощенный вариант и результаты анализа в будущем должны быть уточнены после определения заказчиком полного описания логики присвоения баллов клиента.

На текущий момент использование результатов не является предпочтительным по причине упрощенного расчета. Более 2/3 всех клиентов находятся ниже 20% уровня конверсии.*/