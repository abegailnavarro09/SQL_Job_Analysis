/*
Question: What are the most optimal skills to learn (high demand and high paying skills)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

WITH top_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demanded_skills
    FROM job_postings_fact 
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
            job_title_short = 'Data Analyst' AND
            job_location = 'Anywhere' AND
            salary_year_avg IS NOT NULL
    GROUP BY
            skills_dim.skill_id
), top_salary AS (
    SELECT
        C.skill_id,
        C.skills,
        ROUND(AVG(salary_year_avg), 2) as average_salary
    FROM    job_postings_fact AS A
    INNER JOIN skills_job_dim AS B ON A.job_id = B.job_id
    INNER JOIN skills_dim AS C ON B.skill_id = C.skill_id
    WHERE
            job_title_short = 'Data Analyst' AND
            job_location = 'Anywhere' AND
            salary_year_avg IS NOT NULL
    GROUP BY
            C.skill_id
)

SELECT
        top_demand.skill_id,
        top_demand.skills,
        demanded_skills,
        average_salary
FROM    top_demand
INNER JOIN top_salary ON top_demand.skill_id = top_salary.skill_id
WHERE
        demanded_skills > 10
ORDER BY
        average_salary DESC,
        demanded_skills DESC
LIMIT 5;

-- Shorter way to do this: 
SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demanded_skills,
        ROUND(AVG(salary_year_avg), 2) as average_salary
FROM    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
GROUP BY
        skills_dim.skill_id
HAVING
        COUNT(skills_job_dim.job_id) > 10
ORDER BY
        average_salary DESC,
        demanded_skills DESC
LIMIT 5;
