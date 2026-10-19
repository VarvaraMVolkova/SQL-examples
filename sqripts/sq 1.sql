/*
1. Searching for outliers using the interquartile range (IQR) method for spending on maps. Identification of abnormal customers (power-users), whose expenses (CCAvg) are statistically significantly higher than the upper limit of the norm (Q3+1.5×IQR) in terms of income groups.

IQR (from the English Interquartile Range) is the interquartile range, which shows the spread of the central 50% of the data in a statistical series.

Formula
(\text{IQR}=Q_{3}-Q_{1}\)
• Q₁ (first quartile / 25th percentile) is the value below which 25% of all data is located.
• Q₃ (third quartile / 75th percentile) is the value below which 75% of all data is located.

Main Features

• Outlier tolerance: Unlike the classical standard deviation or the total range (between minimum and maximum), IQR ignores extreme anomalous values.

How to find outliers according to the IQR rule

• Lower bound: Q₁ - 1.5 × IQR
• Upper bound: Q₃ + 1.5 × IQR

---
1. Поиск выбросов методом межквартильного размаха (IQR) для трат по картам. Выявление аномальных клиентов (power-users), чьи расходы (CCAvg) статистически сильно превышают верхнюю границу нормы (Q3+1.5×IQR) в разрезе групп доходов.

IQR (от англ. Interquartile Range) — это межквартильный (интерквартильный) размах, который показывает разброс центральных 50% данных в статистическом ряду.

Формула
(\text{IQR}=Q_{3}-Q_{1}\)
• Q₁ (первый квартиль / 25-й перцентиль) — значение, ниже которого находится 25% всех данных.
• Q₃ (третий квартиль / 75-й перцентиль) — значение, ниже которого находится 75% всех данных.

Главные особенности

• Устойчивость к выбросам: В отличие от классического стандартного отклонения или общего размаха (между минимумом и максимумом), IQR игнорирует крайние аномальные значения.

Как находят выбросы по правилу IQR

• Нижняя граница: Q₁ - 1.5 × IQR
• Верхняя граница: Q₃ + 1.5 × IQR
*/


WITH Quartiles AS (
    SELECT 
        ID,
        Income,
        CCAvg,
        NTILE(4) OVER(ORDER BY CCAvg) AS q
    FROM CreditoPersonal
),
Bounds AS (
    -- Упрощенный расчет через границы квартилей для примера
    SELECT 
        (SELECT MAX(CCAvg) FROM Quartiles WHERE q = 3) AS q3,
        (SELECT MIN(CCAvg) FROM Quartiles WHERE q = 1) AS q1
) --select * from Bounds
SELECT 
    c.ID, 
    c.Income, 
    c.CCAvg CCAvg_month,
	(b.q3 - b.q1) AS iqr,
    (b.q3 + 1.5 * (b.q3 - b.q1)) AS upper_bound
FROM CreditoPersonal c
CROSS JOIN Bounds b
WHERE c.CCAvg > (b.q3 + 1.5 * (b.q3 - b.q1))
ORDER BY c.CCAvg DESC;

/*Resume - The final sample contains information on 225 clients who meet the stated requirements. IQR = 2.5 and the excess is 6.25k*/