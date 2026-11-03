# SQL Examples — Banking Customer Analytics

SQL analysis of a retail-banking customer base: who takes a personal loan, which products sell together, and which regions fit a new mortgage programme.

**Stack:** SQL (SQLite dialect) · window functions (`NTILE`, `ROW_NUMBER`, running `SUM() OVER`) · CTEs · conditional aggregation
**Data:** [Créditos Personales – Banca (Kaggle)](https://www.kaggle.com/datasets/luisenriquesguerrero/creditos-personales-actualizado) — ~5,000 bank clients, 14 fields: age, experience, income, ZIP code, family size, card spending (`CCAvg`), education, mortgage, and ownership of a personal loan, securities account, CD deposit, online banking and credit card. Field descriptions: [`dataset/readme.md`](dataset/readme.md).

## Business questions

| # | Script | Question | Technique |
|---|--------|----------|-----------|
| 1 | [`sq 1.sql`](sqripts/sq%201.sql) | Which clients spend abnormally much on cards (power users)? | Outlier detection with the IQR rule (Q3 + 1.5×IQR) |
| 2 | [`sq 2.sql`](sqripts/sq%202.sql) | What does the "ideal" personal-loan client look like? | Additive scoring on 6 product/demographic criteria, conversion by score |
| 3 | [`sq 3.sql`](sqripts/sq%203.sql) | Does owning other products drive loan conversion? | Cross-sell matrix: securities × CD deposit × online banking |
| 4 | [`sq 4.sql`](sqripts/sq%204.sql) | How does income vary by education level? | Median and 25th/75th percentiles via `ROW_NUMBER()` (no built-in percentile functions) |
| 5 | [`sq 5.sql`](sqripts/sq%205.sql) | How concentrated is income across the client base? | Cumulative distribution (CDF) with running totals |
| 6 | [`sq 6.sql`](sqripts/sq%206.sql) | Is there a premium segment worth targeting? | "5-5-5" segmentation: top quintile by income, card spend and mortgage; conversion lift vs. base rate |
| 7 | [`sq 7.sql`](sqripts/sq%207.sql) | Which regions have enough eligible clients for a new mortgage programme? | Regional target profile (ZIP prefix), eligibility filters, share of eligible clients |

Each script starts with the task statement (EN/RU) and ends with a short summary of results.

## Key findings

- **Power users:** 225 clients spend on cards above the IQR upper bound (IQR = 2.5k, threshold ≈ 6.25k per month).
- **Mortgage programme (script 7):** about 360 clients (~7% of the base) meet all conditions — graduate education, no current mortgage, card spending ≤ 45% of income, middle age range, family of 3+. The task did not define a viability threshold, so the result is an input for the business decision, not a verdict.
- **Premium "5-5-5" segment:** fewer than 200 clients; conversion and lift vs. the overall 9.6% rate are calculated in script 6. Sample is small, so the result is indicative.
- **Data quality:** clients without a degree show the highest median income (script 4) — likely outdated education data; recommended to refresh client records before using education in targeting.

## Assumptions

- Region = first two digits of the ZIP code, assumed to be entered correctly.
- Negative `Experience` values are treated as typos (`ABS()`).
- `CCAvg` = average monthly card spending, in $000.
- Family size is self-reported (questionnaire), not verified.

## How to run

1. Load `dataset/Model_creditoPersonal.csv` into SQLite (or DB Browser for SQLite) as table `CreditoPersonal`.
2. Run any script from `sqripts/`.

---
*Author: Varvara Volkova — Data / BI Analyst · [LinkedIn](https://www.linkedin.com/in/varvara-volkova-425095b5/) · [Tableau Public](https://public.tableau.com/app/profile/varvara.volkova)*
