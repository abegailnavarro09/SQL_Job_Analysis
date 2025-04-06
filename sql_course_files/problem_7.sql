/*Find the count of the number of remote job postings per skills.
Display the top 5 skills by their demand in remote jobs.
Include skill ID, name, and count of postings requiring the skill */

SELECT
        A.skill_id,
        A.skills,
        job_table.job_count AS total_posting
FROM (
        SELECT
                C.skill_id,
                COUNT(*) as job_count
        FROM
                skills_job_dim as C
        LEFT JOIN job_postings_fact AS B ON C.job_id = B.job_id
        WHERE
                B.job_work_from_home = TRUE
        GROUP BY
                C.skill_id
        ORDER BY
                job_count DESC
        LIMIT 5
) AS job_table

LEFT JOIN skills_dim AS A ON job_table.skill_id = A.skill_id 

ORDER BY
        job_count DESC

/* Try same question using CTE */

WITH job_table AS (
SELECT
        B.skill_id,
        COUNT(*) as job_count
FROM
        job_postings_fact as A
INNER JOIN skills_job_dim as B on A.job_id = B.job_id
WHERE
        A.job_work_from_home = true
GROUP BY
        B.skill_id
)

SELECT
        C.skill_id,
        C.skills,
        job_table.job_count
FROM
        job_table
INNER JOIN skills_dim AS C ON job_table.skill_id = C.skill_id
ORDER BY
        job_table.job_count DESC
LIMIT 5;

/*Find the count of the number of remote job postings per skills AND focus on Data Analyst.
Display the top 5 skills by their demand in remote jobs for Data Analyst.
Include skill ID, name, and count of postings requiring the skill */

WITH job_table AS (
SELECT
        B.skill_id,
        COUNT(*) as job_count
FROM
        job_postings_fact as A
INNER JOIN skills_job_dim as B ON A.job_id = B.job_id

WHERE
        job_work_from_home = true AND job_title_short = 'Data Analyst'
GROUP BY
        skill_id
)

SELECT
        D.skill_id,
        C.skills,
        D.job_count
FROM
        skills_dim as C
INNER JOIN  job_table AS D ON D.skill_id = C.skill_id
ORDER BY job_count DESC
LIMIT 5;


