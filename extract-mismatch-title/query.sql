SELECT
    c.id AS course_id,
    c.name AS course_name,
    -- Extract term in format Letter + Year (e.g., F2025)
    REGEXP_SUBSTR(c.name, '[A-Z]20[0-9]{2}') AS before,
    -- Extract term in format Year + Letter (e.g., 2025F)
    REGEXP_SUBSTR(c.name, '20[0-9]{2}[A-Z]') AS after,
    t.name AS term,  -- Term column value (e.g., 'S2014')
    t.start_date,
    p.first_name || ' ' || p.last_name AS instructor_name
FROM cdm_lms.course c
INNER JOIN cdm_lms.term t
    ON t.id = c.term_id
INNER JOIN cdm_lms.person_course pc
    ON pc.course_id = c.id
    AND pc.course_role = 'I'
INNER JOIN cdm_lms.person p
    ON p.id = pc.person_id
WHERE
    COALESCE(
        REGEXP_SUBSTR(c.name, '[A-Z]20[0-9]{2}'),
        CONCAT(RIGHT(REGEXP_SUBSTR(c.name, '20[0-9]{2}[A-Z]'), 1),
               LEFT(REGEXP_SUBSTR(c.name, '20[0-9]{2}[A-Z]'), 4))
    ) <> CONCAT(LEFT(t.name, 1), RIGHT(t.name, 4))
ORDER BY t.start_date, c.name;
