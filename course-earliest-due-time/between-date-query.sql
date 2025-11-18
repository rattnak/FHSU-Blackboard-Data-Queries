WITH ranked_assignments AS (
    SELECT
        c.id AS course_id,
        c.name AS course_name,
        c.design_mode,
        t.name AS term,
        t.start_date,
        gb.name AS assignment_name,
        gb.due_time,
        p.id AS instructor_id,
        p.first_name || ' ' || p.last_name AS instructor_name,
        p.email AS instructor_email,
        ih.hierarchy_name_seq,
        ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY gb.due_time ASC) AS rn
    FROM cdm_lms.course c
    INNER JOIN cdm_lms.term t ON t.id = c.term_id
    INNER JOIN cdm_lms.gradebook gb ON gb.course_id = c.id
    INNER JOIN cdm_lms.person_course pc ON pc.course_id = c.id AND pc.course_role = 'I'
    INNER JOIN cdm_lms.person p ON p.id = pc.person_id
    INNER JOIN cdm_lms.institution_hierarchy_course ihc ON c.id = ihc.course_id AND ihc.primary_ind = 1
    INNER JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
    WHERE t.start_date BETWEEN '2024-07-31' AND '2025-04-01'
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
        c.id AS course_id,
        COUNT(DISTINCT p.id) AS instructor_count,
        LISTAGG(DISTINCT p.first_name || ' ' || p.last_name, ', ')
            WITHIN GROUP (ORDER BY p.last_name, p.first_name) AS instructor_names,
        LISTAGG(DISTINCT p.email, ', ')
            WITHIN GROUP (ORDER BY p.email) AS instructor_emails
    FROM cdm_lms.course c
    INNER JOIN cdm_lms.person_course pc ON c.id = pc.course_id AND pc.course_role = 'I'
    INNER JOIN cdm_lms.person p ON p.id = pc.person_id
    GROUP BY c.id
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
