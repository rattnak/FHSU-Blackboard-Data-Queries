SELECT
    c.id AS course_id,
    c.name AS course_name,
    c.design_mode,
    t.start_date,
    t.name AS term,
    CASE
        WHEN c.design_mode = 'C' THEN 'Classic'
        WHEN c.design_mode IN ('U', 'P') THEN 'Ultra'
        ELSE 'Unknown'
    END AS course_type,
    p.first_name || ' ' || p.last_name AS instructor_name  -- Combine first and last name for instructor
FROM cdm_lms.course c
INNER JOIN cdm_lms.term t ON t.id = c.term_id
INNER JOIN cdm_lms.person_course pc  -- Join person_course to filter by course_role
    ON pc.course_id = c.id
    AND pc.course_role = 'I'  -- Only instructors
INNER JOIN cdm_lms.person p  -- Join person to get first and last name
    ON p.id = pc.person_id
WHERE t.start_date > '{date}'
ORDER BY t.start_date, c.name;
