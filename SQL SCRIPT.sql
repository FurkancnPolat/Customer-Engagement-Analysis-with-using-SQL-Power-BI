-- This SQL script retrieves key metrics for student engagement on the 365 platform.
-- It calculates total minutes watched, average minutes per student, number of ratings, and average rating 
-- for each course by joining data from the 365_course_info, 365_student_learning, and 365_course_ratings tables.
-- The script uses Common Table Expressions (CTEs) to process and organize the data before presenting the final result

WITH title_total_minutes AS (
    SELECT
        ci.course_id,
        ci.course_title,
        SUM(sl.minutes_watched) AS total_minutes_watched,
        COUNT(DISTINCT sl.student_id) AS num_students
    FROM 
        365_course_info ci
    JOIN 
        365_student_learning sl
    ON 
        ci.course_id = sl.course_id
    GROUP BY 
        ci.course_id, ci.course_title
),
title_average_minutes AS (
    SELECT
        ttm.course_id,
        ttm.course_title,
        ttm.total_minutes_watched,
        ROUND(ttm.total_minutes_watched * 1.0 / ttm.num_students, 2) AS average_minutes
    FROM 
        title_total_minutes ttm
),
title_ratings AS (
    SELECT
        tam.course_id,
        tam.course_title,
        tam.total_minutes_watched,
        tam.average_minutes,
        COUNT(cr.course_rating) AS num_ratings, 
        ROUND(COALESCE(AVG(cr.course_rating), 0), 2) AS average_rating 
    FROM 
        title_average_minutes tam
    LEFT JOIN 
        365_course_ratings cr
    ON 
        tam.course_id = cr.course_id
    GROUP BY 
        tam.course_id, tam.course_title, tam.total_minutes_watched, tam.average_minutes
)
SELECT 
    *
FROM 
    title_ratings
ORDER BY 
    course_id;
    
- This SQL script creates a view named 'purchases_info' from the '365_student_purchases' table.
-- The view includes the following columns:
-- 'purchase_id', 'student_id', 'purchase_type', and 'date_start' (renamed from 'date_purchased').
-- Additionally, the script uses a CASE statement to assign a value for 'end_date' based on the purchase type:
--    - 0 for "Monthly" purchases
--    - 1 for "Quarterly" purchases
--    - 2 for "Annual" purchases
-- The 'DROP VIEW IF EXISTS' statement ensures that the view is dropped if it already exists before creating it again.


DROP VIEW IF EXISTS purchases_info;

CREATE VIEW purchases_info AS
SELECT
	purchase_id,
    student_id,
    purchase_type,
    date_purchased AS date_start,
    CASE
    WHEN purchase_type = "Monthly" THEN 0
    WHEN purchase_type = "Quarterly" THEN 1
    WHEN purchase_type = "Annual" THEN 2
    END AS "end_date"
FROM 365_student_purchases


-- This script calculates the total minutes watched by students on a daily basis,
-- along with information about their registration, onboard status, and subscription status.
-- The query combines data from the 365_student_info, 365_student_learning, and purchases_info tables.
-- For each student, the script determines whether they were onboarded (i.e., have learning data),
-- calculates the total minutes watched, and checks if the student had an active subscription (paid) 
-- on the day they watched the course.
-- The final result set includes:
--   - student_id: the student's ID
--   - student_country: the student's country
--   - date_registered: the student's registration date
--   - date_watched: the date the student watched a course
--   - minutes_watched: total minutes watched by the student on that day
--   - onboarded: 1 if the student has watched any courses, 0 if not
--   - paid: 1 if the student had an active subscription on that date, 0 if not
-- The query ensures that all records from the student info are retrieved, even if no learning data is available.

SELECT 
    b.student_id,
    b.student_country,
    b.date_registered,
    b.date_watched,
    b.minutes_watched,
    b.onboarded,
    MAX(b.paid) AS paid
FROM 
    (
        -- Step 4 query (aliased as 'a')
        SELECT 
            a.student_id,
            a.student_country,
            a.date_registered,
            a.date_watched,
            a.minutes_watched,
            a.onboarded,
            -- Determine if the student was paid on the date_watched
            IF(
                a.date_watched BETWEEN p.date_start AND DATE_ADD(p.date_start, INTERVAL p.end_date MONTH),
                1, 
                0
            ) AS paid
        FROM 
            (
                -- Your original query as a subquery (aliased as 'a')
                SELECT 
                    i.student_id,
                    i.student_country,
                    i.date_registered,
                    l.date_watched,
                    IF(l.minutes_watched IS NULL, 0, SUM(l.minutes_watched)) AS minutes_watched,
                    IF(l.date_watched IS NULL, 0, 1) AS onboarded
                FROM 
                    365_student_info i
                LEFT JOIN 
                    365_student_learning l USING(student_id)
                GROUP BY 
                    i.student_id, 
                    i.student_country, 
                    i.date_registered,
                    l.date_watched,
                    l.minutes_watched-- Ensure this is part of the GROUP BY
            ) a
        LEFT JOIN 
            purchases_info p ON a.student_id = p.student_id
    ) b
GROUP BY 
    b.student_id, 
    b.student_country,
    b.date_registered, 
    b.date_watched, 
    b.minutes_watched, 
    b.onboarded;
