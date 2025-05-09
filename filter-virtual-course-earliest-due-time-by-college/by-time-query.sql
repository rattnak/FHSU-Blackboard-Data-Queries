WITH earliest_assignment AS (
    SELECT
        lg.course_id,
        lg.name AS assignment_name,
        lg.due_time
    FROM (
        SELECT 
            course_id, 
            name, 
            due_time,
            ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC) AS rn
        FROM cdm_lms.gradebook
    ) lg
    WHERE rn = 1
)
SELECT
    lc.id AS course_id,
    lc.name AS course_name,
    lc.design_mode,
    lt.start_date,
    ea.assignment_name,
    ea.due_time AS earliest_due_time,
    lt.name AS term,
    COUNT(DISTINCT p.id) AS instructor_count,
    LISTAGG(DISTINCT CONCAT(p.first_name, ' ', p.last_name), ', ') 
        WITHIN GROUP (ORDER BY CONCAT(p.first_name, ' ', p.last_name)) AS instructors,
    LISTAGG(DISTINCT p.email, ', ') 
        WITHIN GROUP (ORDER BY p.email) AS instructor_emails,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 2) ELSE 'Unknown' END AS institutional_hierarchy_level_1,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 3) ELSE 'Unknown' END AS institutional_hierarchy_level_2,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institutional_hierarchy_level_3,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institutional_hierarchy_level_4
FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt ON lt.id = lc.term_id
LEFT JOIN earliest_assignment ea ON ea.course_id = lc.id
INNER JOIN cdm_lms.person_course lpc ON lpc.course_id = lc.id AND lpc.course_role = 'I'
INNER JOIN cdm_lms.person p ON p.id = lpc.person_id
INNER JOIN cdm_lms.institution_hierarchy_course ihc ON lc.id = ihc.course_id
INNER JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
WHERE lt.name = 'S2025'
    AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
    AND lc.name LIKE '%_V%_%' 
GROUP BY
    lc.id, lc.name, lc.design_mode, lt.start_date, ea.assignment_name, ea.due_time, lt.name, ih.hierarchy_name_seq
ORDER BY earliest_due_time, lc.name;