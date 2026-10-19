/*
Analysis of cross-ownership of products (Cross-Sell Matrix)
The conversion rate to a "Personal Loan" depends on the combination of ownership of three other products: A Securities Account, a CD Deposit, and Online Banking.

Анализ перекрестного владения продуктами (Cross-Sell Matrix)
Оценка конверсии в «Личный заем» в зависимости от комбинации владения тремя другими продуктами: Счетом ценных бумаг, Депозитом (CD) и Онлайн-банкингом.
*/

SELECT 
    [Securities Account] AS has_securities,
    [CD account] AS has_cd,
    Online AS has_online,
    COUNT(*) AS total_clients,
    SUM([Personal loan]) AS converted_clients,
    ROUND(100.0 * SUM([Personal loan]) / COUNT(*), 2) AS conversion_rate,
    ROUND(AVG(Income), 1) AS avg_income
FROM CreditoPersonal
GROUP BY [Securities Account], [CD Account], Online
ORDER BY conversion_rate DESC;

/*
Summary: the conducted analysis shows that there is still much to strive for and it is possible to improve customer conversion by offering favorable conditions for deposit products and securities and distributing information about the availability of a personal account that offers a wide range of opportunities and services for the client that save his time and money. Also, your personal account is open 24/7 and you don't have to wait in line. By connecting the Personal Manager service, you can get an even wider range of online services.

Резюме: проведенная аналитика показывает, что есть еще куда стремиться и можно улучшить конверсию клиентов за счет предложения выгожных условий по депозитным продуктам и ценным бумагам и распростанения информации о наличии личного кабинета, который предлашает широкий спектр возможностей и услуг для клиента, которые экономят его время и деньги. Также, личный кабинет работает 24/7 и не нужно ждать в очереди. ПОдключив услугу "Персональный менеджер" есть возможность получить еще более широкий спектр услуг в формате онлайн
*/