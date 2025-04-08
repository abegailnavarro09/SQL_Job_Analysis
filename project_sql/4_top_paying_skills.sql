/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
        skills,
        ROUND(AVG(salary_year_avg), 2) as average_salary
FROM    job_postings_fact AS A
INNER JOIN skills_job_dim AS B ON A.job_id = B.job_id
INNER JOIN skills_dim AS C ON B.skill_id = C.skill_id
WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
GROUP BY
        skills
ORDER BY
        average_salary DESC
LIMIT 10

/*
Final Analysis:
- Niche & Emerging Tech Pays More: Skills like Solidity, MXNet, and DataRobot offer high salaries due to their rarity and relevance in cutting-edge fields like blockchain and AI/AutoML.
- Infrastructure & DevOps Are Valuable: Tools like Terraform, VMware, and Couchbase command top pay for enabling scalable, cloud-native, and secure data systems.
- Specialization Over Generalization: High salaries are linked to deep expertise in specific tools rather than broad, general-purpose skills—reflecting demand for specialized roles in modern data teams.

[
  {
    "skills": "svn",
    "average_salary": "400000.00"
  },
  {
    "skills": "solidity",
    "average_salary": "179000.00"
  },
  {
    "skills": "couchbase",
    "average_salary": "160515.00"
  },
  {
    "skills": "datarobot",
    "average_salary": "155485.50"
  },
  {
    "skills": "golang",
    "average_salary": "155000.00"
  },
  {
    "skills": "mxnet",
    "average_salary": "149000.00"
  },
  {
    "skills": "dplyr",
    "average_salary": "147633.33"
  },
  {
    "skills": "vmware",
    "average_salary": "147500.00"
  },
  {
    "skills": "terraform",
    "average_salary": "146733.83"
  },
  {
    "skills": "twilio",
    "average_salary": "138500.00"
  }
]

*/
