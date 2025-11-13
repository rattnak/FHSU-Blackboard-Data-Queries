SELECT 
    c.course_number AS course_id,
    c.name AS course_name,
    t.name AS term_name,
    t.start_date AS term_start_date,
    t.end_date AS term_end_date,
    ci.name AS assignment_name,
    gb.due_time AS assignment_due_date,
    CASE 
        WHEN c.design_mode IN ('U', 'P') THEN 'Ultra'
        ELSE 'Original'
    END AS course_type,
    LISTAGG(CONCAT(p.first_name, ' ', p.last_name, ' <', p.email, '>'), ', ') 
        WITHIN GROUP (ORDER BY p.last_name, p.first_name) AS instructors
FROM CDM_LMS.COURSE c
INNER JOIN CDM_LMS.GRADEBOOK gb 
    ON gb.course_id = c.id
LEFT JOIN CDM_LMS.COURSE_ITEM ci 
    ON gb.course_item_id = ci.id
LEFT JOIN CDM_LMS.PERSON_COURSE pc 
    ON pc.course_id = c.id AND pc.course_role = 'I'
LEFT JOIN CDM_LMS.PERSON p 
    ON p.id = pc.person_id
INNER JOIN CDM_LMS.TERM t 
    ON c.term_id = t.id
WHERE gb.due_time IS NOT NULL
  AND gb.due_time < CURRENT_DATE - INTERVAL '21 DAYS'
  AND t.end_date >= CURRENT_DATE
  AND t.start_date BETWEEN '2024-07-31' AND '2025-04-01'
  AND c.row_deleted_time IS NULL
GROUP BY 
    c.course_number, c.name, t.name, t.start_date, t.end_date, 
    ci.name, gb.due_time, c.design_mode
ORDER BY 
    t.start_date DESC, gb.due_time DESC; 