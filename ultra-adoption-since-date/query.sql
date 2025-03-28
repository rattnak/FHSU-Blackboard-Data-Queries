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
    END AS course_type
FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt ON lt.id = lc.term_id
WHERE lt.start_date > '2024-08-01'
ORDER BY lt.start_date, lc.name;
