
-- alomost same as previous query

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) as demand_count
FROM job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home= True
GROUP BY sd.skills
ORDER BY
    median_salary DESC
LIMIT 20;

/*
┌───────────┬───────────────┬──────────────┐
│  skills   │ median_salary │ demand_count │
│  varchar  │    double     │    int64     │
├───────────┼───────────────┼──────────────┤
│ rust      │      210000.0 │          232 │
│ sheets    │      196698.0 │           98 │
│ solidity  │      192500.0 │           45 │
│ terraform │      184000.0 │         3248 │
│ golang    │      184000.0 │          912 │
│ next.js   │      180000.0 │           19 │
│ ggplot2   │      176250.0 │           15 │
│ spring    │      175500.0 │          364 │
│ erlang    │      172500.0 │            9 │
│ ocaml     │      172500.0 │            1 │
│ haskell   │      172500.0 │           17 │
│ neo4j     │      170000.0 │          277 │
│ gdpr      │      169616.0 │          582 │
│ zoom      │      168438.0 │          127 │
│ graphql   │      167500.0 │          445 │
│ plotly    │      162500.0 │           61 │
│ mongo     │      162250.0 │          265 │
│ centos    │      159350.0 │           31 │
│ mxnet     │      157500.0 │            5 │
│ fastapi   │      157500.0 │          204 │
└───────────┴───────────────┴──────────────┘
*/