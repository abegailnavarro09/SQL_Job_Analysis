-- Create separate tables for January, Feb, March job_posted_date.
CREATE TABLE january_jobs AS
        SELECT *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
        SELECT *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
        SELECT *
        FROM
            job_postings_fact
        WHERE
            EXTRACT(MONTH FROM job_posted_date) = 3;
SELECT * FROM march_jobs;

-- Use CASE, WHEN, THEN, ELSE, END
SELECT
        job_title_short as job_title,
        job_location as location,
        CASE
            WHEN job_location = 'Anywhere' THEN 'Remote'
            WHEN job_location = 'New York, NY' THEN 'Local'
            ELSE 'Onsite'
        END as location_category
FROM
        job_postings_fact;

-- Focus on Data Analyst and use only the count of each location_category.
SELECT
        COUNT(job_id) as job_count,
        CASE
            WHEN job_location = 'Anywhere' THEN 'Remote'
            WHEN job_location = 'New York, NY' THEN 'Local'
            ELSE 'Onsite'
        END AS location_category
FROM
        job_postings_fact
WHERE
        job_title_short = 'Data Analyst'
GROUP BY
        location_category;

/* Categorize the salaries from each job posting.
Put salary into different buckets
Define what's a high, standard, or low
Look only for Data Analyst Roles
Order from highest to lowest.*/
SELECT
        salary_year_avg AS salary,
        CASE
            WHEN salary_year_avg > 0 AND salary_year_avg <= 30000 THEN 'LOW'
            WHEN salary_year_avg > 30000 AND salary_year_avg < 70000  THEN 'STANDARD'
            WHEN salary_year_avg > 70000 THEN 'HIGH'
            ELSE 'NULL'
        END AS salary_category
FROM
        job_postings_fact
WHERE
        job_title_short = 'Data Analyst'
ORDER BY
        salary_category DESC;


        
