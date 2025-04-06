-- CONVERT DATA TYPE USING '::'
SELECT '2024-01-05'::DATE,
        '123'::INTEGER,
        'true'::BOOLEAN,
        '3.14'::REAL;

/* job_posted_date is a TIMESTAMP. 
Convert it to DATE.*/
SELECT 
        job_title_short as title,
        job_location as location,
        job_posted_date::DATE as date
FROM
        job_postings_fact;

/* Converting timezone using 'AT TIME ZONE' 
- specify first the time zone if not provided in the data 
using 'AT TIME ZONE'
-then use again 'AT TIME ZONE'.*/

SELECT 
        job_title_short as title,
        job_location as location,
        job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date -- FROM UTC TO EST
FROM
        job_postings_fact
LIMIT 5;

-- Get specific field using EXTRACT.
SELECT 
        job_title_short as title,
        job_location as location,
        job_posted_date as date,
        EXTRACT(DAY FROM job_posted_date) AS day-- can use month, year, day.
FROM
        job_postings_fact
LIMIT 5;

-- Count job_id based on months.
SELECT 
        COUNT(job_id) as job_count,
        EXTRACT(MONTH FROM job_posted_date) as month
FROM    
        job_postings_fact
WHERE
        job_title_short = 'Data Analyst'
GROUP BY
        month
ORDER BY 
        month ASC;

/* Practice Problem 1
Average salary both yearly and hourly for job posting that were posted after June 1, 2023.
Group results by job schedule type.*/
SELECT
        job_schedule_type,
        AVG(salary_year_avg) AS yearly_salary_ave,
        AVG(salary_hour_avg) AS hourly_salary_ave
FROM
        job_postings_fact
WHERE
        job_posted_date::DATE > '2023-06-01'
GROUP BY
        job_schedule_type;

/* Count number of job posting for each month in 2023.
Adjust job_posted_date to be American/New York time zone.
Assume job_posted_date is in UTC.
Group and order by month. */
SELECT
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month,
        COUNT(job_id) AS job_count
FROM
        job_postings_fact
GROUP BY
        month
ORDER BY
        month;

/* Query to find companies(include company name) that have posted jobs offering health insurance, 
where these postings were made in the second quarter of 2023. Use date extraction to filter by quarter.*/
SELECT
        B.name as company_name,
        A.job_health_insurance as has_health_insurance,
        A.job_posted_date as date
FROM
        job_postings_fact as A
LEFT JOIN company_dim as B on A.company_id = B. company_id
WHERE
        EXTRACT(YEAR FROM job_posted_date) = 2023 and
        EXTRACT(QUARTER FROM job_posted_date) = 2 and
        A.job_health_insurance = 'true'
ORDER BY
        date;