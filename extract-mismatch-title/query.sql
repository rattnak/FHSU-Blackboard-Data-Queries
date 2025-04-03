SELECT
    lc.id AS course_id,
    lc.name AS course_name,
    -- Extract term in format Letter + Year (e.g., F2025)
    REGEXP_SUBSTR(lc.name, '[A-Z]20[0-9]{2}') AS before,  
    -- Extract term in format Year + Letter (e.g., 2025F)
    REGEXP_SUBSTR(lc.name, '20[0-9]{2}[A-Z]') AS after,  
    lt.name AS term,  -- Term column value (e.g., 'S2014')
    lt.start_date,
    CONCAT(p.first_name, ' ', p.last_name) AS instructor_name
FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt 
    ON lt.id = lc.term_id
INNER JOIN cdm_lms.person_course lpc  
    ON lpc.course_id = lc.id 
    AND lpc.course_role = 'I'  
INNER JOIN cdm_lms.person p  
    ON p.id = lpc.person_id
WHERE 
    COALESCE(
        REGEXP_SUBSTR(lc.name, '[A-Z]20[0-9]{2}'),  
        CONCAT(RIGHT(REGEXP_SUBSTR(lc.name, '20[0-9]{2}[A-Z]'), 1), 
               LEFT(REGEXP_SUBSTR(lc.name, '20[0-9]{2}[A-Z]'), 4))  
    ) <> CONCAT(LEFT(lt.name, 1), RIGHT(lt.name, 4))  
ORDER BY lt.start_date, lc.name;
