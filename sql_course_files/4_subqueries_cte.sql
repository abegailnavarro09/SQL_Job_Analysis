/* Subqueries
- query nested inside larger query.
- it can be used inside SELECT, FROM, WHERE, HAVING clauses. */
SELECT * 
FROM ( -- Subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- Subquery ends here

/* Common Table Expression (CTE) 
- Define a temporary result set that you can reference.
- Can be used within SELECT, INSERT, UPDATE, DELETE.
- Defined with WITH */
WITH january_jobs AS( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here
SELECT *
FROM january_jobs;

/* EXAMPLE SUBQUERY
- return company name that does not require degree. */
SELECT name AS company_name
FROM 
        company_dim
WHERE   company_id IN (
    SELECT company_id
    FROM   job_postings_fact
    WHERE  job_no_degree_mention = true
);

/* EXAMPLE CTE
- Find the companies that have the most job openings.
- Get the total number of job postings per company id.
- Return the total number of jobs with the company name.*/

WITH company_total_jobs AS(
    SELECT 
            company_id,
            COUNT(*) as total
    FROM
            job_postings_fact
    GROUP BY
            company_id
)

SELECT 
        A.name as company_name,
        B.total as total_count
FROM
        company_dim as A
LEFT JOIN company_total_jobs as B ON A.company_id = B.company_id
ORDER BY B.total DESC;
        
/* PRACTICE PROBLEM
Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table 
and then join this result with the skills_dim table to get the skill names.*/
SELECT 
        A.skills, top_table.skill_count
FROM (
        SELECT  skill_id,
                COUNT(*) as skill_count
        FROM
                skills_job_dim 
        GROUP BY
                skill_id
        ORDER BY
                skill_count DESC
        LIMIT 5     
        ) AS top_table
LEFT JOIN skills_dim as A ON top_table.skill_id = A.skill_id;

/* Determine the size category (Small, Medium, Large) for each company by first identifying the number of job postings they have. 
Use a subquery to calculate the total job postings per company. 
A company is considered Small of it has less than 10 job postings, Medium if number of job postings is between 10 and 50 
and Large if more than 50. Implement subquery to aggregate job counts per company before classifying them based on size. */
SELECT
        A.name, job_table.job_count,
        CASE
                WHEN job_table.job_count <= 10 THEN 'Small'
                WHEN job_table.job_count > 10 AND job_table.job_count <= 50 THEN 'Medium'
                ELSE 'Large'
        END AS company_category
FROM (
        SELECT
                company_id,
                COUNT(*) AS job_count
        FROM
                job_postings_fact
        GROUP BY
                company_id
        ORDER BY 
                job_count DESC
) AS job_table
LEFT JOIN company_dim as A ON job_table.company_id = A.company_id;


