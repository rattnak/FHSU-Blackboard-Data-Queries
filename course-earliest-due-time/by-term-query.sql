WITH earliest_assignment AS (
    SELECT
        gb.course_id,
        gb.name AS assignment_name,
        gb.due_time
    FROM (
        SELECT
            course_id,
            name,
            due_time,
            ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC) AS rn
        FROM cdm_lms.gradebook
    ) gb
    WHERE rn = 1
)
SELECT
    c.id AS course_id,
    c.name AS course_name,
    c.design_mode,
    t.start_date,
    ea.assignment_name,
    ea.due_time AS earliest_due_time,
    t.name AS term,
    COUNT(DISTINCT p.id) AS instructor_count,
    LISTAGG(DISTINCT p.first_name || ' ' || p.last_name, ', ') AS instructor_names,
    LISTAGG(DISTINCT p.email, ', ') AS instructor_emails,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 2) ELSE 'Unknown' END AS institutional_hierarchy_level_1,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 3) ELSE 'Unknown' END AS institutional_hierarchy_level_2,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institutional_hierarchy_level_3,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institutional_hierarchy_level_4
FROM cdm_lms.course c
INNER JOIN cdm_lms.term t ON t.id = c.term_id
LEFT JOIN earliest_assignment ea ON ea.course_id = c.id
INNER JOIN cdm_lms.person_course pc ON pc.course_id = c.id AND pc.course_role = 'I'
INNER JOIN cdm_lms.person p ON p.id = pc.person_id
INNER JOIN cdm_lms.institution_hierarchy_course ihc ON c.id = ihc.course_id AND ihc.primary_ind = 1
INNER JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
WHERE t.name = 'S2025'
GROUP BY
    c.id, c.name, c.design_mode, t.start_date, ea.assignment_name, ea.due_time, t.name, ih.hierarchy_name_seq
ORDER BY earliest_due_time, c.name;
