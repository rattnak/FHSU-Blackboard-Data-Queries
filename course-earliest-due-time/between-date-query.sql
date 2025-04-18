WITH ranked_assignments AS (
    SELECT
        lc.id AS course_id,
        lc.name AS course_name,
        lc.design_mode,
        lt.name AS term,
        lt.start_date,
        lg.name AS assignment_name,
        lg.due_time,
        p.id AS instructor_id,
        CONCAT(p.first_name, ' ', p.last_name) AS instructor_name,
        p.email AS instructor_email,
        ih.hierarchy_name_seq,
        ROW_NUMBER() OVER (PARTITION BY lc.id ORDER BY lg.due_time ASC) AS rn
    FROM cdm_lms.course lc
    INNER JOIN cdm_lms.term lt ON lt.id = lc.term_id
    INNER JOIN cdm_lms.gradebook lg ON lg.course_id = lc.id
    INNER JOIN cdm_lms.person_course lpc ON lpc.course_id = lc.id AND lpc.course_role = 'I'
    INNER JOIN cdm_lms.person p ON p.id = lpc.person_id
    INNER JOIN cdm_lms.institution_hierarchy_course ihc ON lc.id = ihc.course_id
    INNER JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
    WHERE lt.start_date BETWEEN '2024-07-31' AND '2025-04-01'
),
earliest_assignment_per_course AS (
    SELECT
        course_id,
        course_name,
        design_mode,
        term,
        start_date,
        assignment_name,
        due_time,
        hierarchy_name_seq
    FROM ranked_assignments
    WHERE rn = 1
),
instructor_agg AS (
    SELECT
        lc.id AS course_id,
        COUNT(DISTINCT p.id) AS instructor_count,
        LISTAGG(DISTINCT CONCAT(p.first_name, ' ', p.last_name), ', ') 
            WITHIN GROUP (ORDER BY CONCAT(p.first_name, ' ', p.last_name)) AS instructors,
        LISTAGG(DISTINCT p.email, ', ') 
            WITHIN GROUP (ORDER BY p.email) AS instructor_emails
    FROM cdm_lms.course lc
    INNER JOIN cdm_lms.person_course lpc ON lc.id = lpc.course_id AND lpc.course_role = 'I'
    INNER JOIN cdm_lms.person p ON p.id = lpc.person_id
    GROUP BY lc.id
)
SELECT
    ea.course_id,
    ea.course_name,
    ea.design_mode,
    ea.term,
    ea.start_date,
    ea.assignment_name,
    ea.due_time,
    ia.instructor_count,
    ia.instructors,
    ia.instructor_emails,
    CASE WHEN ea.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ea.hierarchy_name_seq, '||', 2) ELSE 'Unknown' END AS institutional_hierarchy_level_1,
    CASE WHEN ea.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ea.hierarchy_name_seq, '||', 3) ELSE 'Unknown' END AS institutional_hierarchy_level_2,
    CASE WHEN ea.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ea.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institutional_hierarchy_level_3,
    CASE WHEN ea.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ea.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institutional_hierarchy_level_4
FROM earliest_assignment_per_course ea
LEFT JOIN instructor_agg ia ON ea.course_id = ia.course_id
ORDER BY ea.due_time ASC;
