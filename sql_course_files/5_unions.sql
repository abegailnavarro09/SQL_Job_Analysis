/* UNION
- combines results from two or more select statements.
- must have the same columns, and data type must match. 
- get rid of duplicate rows (all rows unique) */

-- Get jobs and company for January.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    january_jobs

UNION
-- Get jobs and company for February.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    february_jobs

UNION
-- Get jobs and company for March.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    march_jobs

/* UNION ALL
-   combine the result of two or more SELECT statement.
-   must have the same columns, and data type must match. 
-   return all rows even duplicate */
-- Get jobs and company for January.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    january_jobs

UNION ALL
-- Get jobs and company for February.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    february_jobs

UNION ALL
-- Get jobs and company for March.
SELECT
        job_title_short,
        company_id,
        job_location
FROM    march_jobs

/* Practice Problem
- Get the corresponding skill and skill type for each job posting in q1.
- Focus on Data Analyst
Include those without any skills, too. */

-- Use subquery and union

SELECT  job_title_short,
        job_location,
        job_via,
        salary_year_avg,
        job_posted_date::DATE
FROM    (
        SELECT *
        FROM    january_jobs
        UNION ALL
        SELECT *
        FROM    february_jobs
        UNION ALL
        SELECT *
        FROM    march_jobs
)   AS combined_quarter
WHERE   salary_year_avg > 70000 AND
        job_title_short = 'Data Analyst'
ORDER BY
        salary_year_avg DESC        