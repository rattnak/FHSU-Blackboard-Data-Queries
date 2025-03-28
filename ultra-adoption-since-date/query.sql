SELECT
    lc.id AS course_id,
    lc.name AS course_name,
    lc.design_mode,
    lt.start_date,
    lt.name AS term,
    CASE 
        WHEN lc.design_mode = 'C' THEN 'Classic'
        WHEN lc.design_mode IN ('U', 'P') THEN 'Ultra'
        ELSE 'Unknown'
    END AS course_type,
    CONCAT(p.first_name, ' ', p.last_name) AS instructor_name  -- Combine first and last name for instructor
FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt ON lt.id = lc.term_id
INNER JOIN cdm_lms.person_course lpc  -- Join person_course to filter by course_role
    ON lpc.course_id = lc.id 
    AND lpc.course_role = 'I'  -- Only instructors
INNER JOIN cdm_lms.person p  -- Join person to get first and last name
    ON p.id = lpc.person_id
WHERE lt.start_date > '2024-08-01'
ORDER BY lt.start_date, lc.name;
