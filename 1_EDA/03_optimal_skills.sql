/*
1. combine demand_count with median salary to know which skills has major job postings
 which also provide salary equal to median salary
┌───────────┬───────────────┬──────────────┐
│  skills   │ median_salary │ demand_count │
│  varchar  │    double     │    int64     │
├───────────┼───────────────┼──────────────┤
│ rust      │      210000.0 │           23 │
│ sheets    │      196698.0 │            2 │
│ solidity  │      192500.0 │            3 │
│ terraform │      184000.0 │          193 │
│ golang    │      184000.0 │           39 │
│ next.js   │      180000.0 │            2 │
│ ggplot2   │      176250.0 │            2 │
│ spring    │      175500.0 │           33 │
│ ocaml     │      172500.0 │            1 │
│ erlang    │      172500.0 │            1 │
│ haskell   │      172500.0 │            1 │
│ neo4j     │      170000.0 │           11 │
│ gdpr      │      169616.0 │           22 │
│ zoom      │      168438.0 │           12 │
│ graphql   │      167500.0 │           28 │
│ plotly    │      162500.0 │            3 │
│ mongo     │      162250.0 │           14 │
│ centos    │      159350.0 │            2 │
│ fastapi   │      157500.0 │            3 │
│ mxnet     │      157500.0 │            1 │
└───────────┴───────────────┴──────────────┘


2. instead of taking count of demand count,
    take logarithmic count of demand count.
    it compresses larger values

3. now calculate optimal score using median x log demand count
4. sort results by optimal score

┌────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │             8.1 │          1.49 │
│ python     │      135000.0 │            10.3 │          1.39 │
│ airflow    │      150000.0 │             9.2 │          1.38 │
│ aws        │      137320.0 │             9.8 │          1.34 │
│ sql        │      130000.0 │            10.3 │          1.34 │
│ spark      │      140000.0 │             9.5 │          1.32 │
│ kafka      │      145000.0 │             8.8 │          1.27 │
│ kubernetes │      150500.0 │             8.3 │          1.26 │
│ golang     │      184000.0 │             6.8 │          1.25 │
│ snowflake  │      135500.0 │             9.1 │          1.23 │
│ azure      │      128000.0 │             9.6 │          1.22 │
│ java       │      135000.0 │             8.9 │           1.2 │
│ scala      │      137290.0 │             8.7 │           1.2 │
│ databricks │      132750.0 │             9.0 │           1.2 │
│ pyspark    │      140000.0 │             8.5 │          1.19 │
│ gcp        │      136000.0 │             8.8 │          1.19 │
│ git        │      140000.0 │             8.4 │          1.18 │
│ hadoop     │      135000.0 │             8.6 │          1.16 │
│ rust       │      210000.0 │             5.4 │          1.14 │
│ docker     │      135000.0 │             8.4 │          1.13 │
└────────────┴───────────────┴─────────────────┴───────────────┘

*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    -- COUNT(jpf.*) as demand_count
    ROUND(LN(COUNT(jpf.*)), 1) as ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/ 1_000_000, 2) as optimal_score
FROM job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home= True
GROUP BY sd.skills
ORDER BY
    optimal_score DESC
LIMIT 20;