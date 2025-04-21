SELECT 
    c.course_number AS course_id,
    c.name AS course_name,
    ci.name AS item_name,
    ci.created_time AS item_created_date,
    ci.modified_time AS last_modified_date,
    CASE 
        WHEN c.design_mode IN ('U', 'P') THEN 'Ultra'
        ELSE 'Original'
    END AS course_type,
    LISTAGG(CONCAT(p.first_name, ' ', p.last_name, ' <', p.email, '>'), ', ')
        WITHIN GROUP (ORDER BY p.last_name, p.first_name) AS instructors
FROM CDM_LMS.COURSE_ITEM ci
INNER JOIN CDM_LMS.COURSE c 
    ON ci.course_id = c.id
INNER JOIN CDM_LMS.TERM t 
    ON c.term_id = t.id
LEFT JOIN CDM_LMS.PERSON_COURSE pc 
    ON pc.course_id = c.id AND pc.course_role = 'I'
LEFT JOIN CDM_LMS.PERSON p 
    ON p.id = pc.person_id
WHERE LOWER(ci.name) LIKE '%syllabus%'
  AND ci.modified_time < CURRENT_DATE - INTERVAL '1 YEAR'
  AND lt.start_date BETWEEN '2024-07-31' AND '2025-04-01'
  AND c.row_deleted_time IS NULL
  AND ci.row_deleted_time IS NULL
GROUP BY 
    c.course_number, c.name, ci.name, ci.created_time, ci.modified_time, c.design_mode
ORDER BY 
    ci.modified_time DESC;
