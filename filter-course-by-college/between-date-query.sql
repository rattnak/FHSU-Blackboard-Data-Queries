SELECT
    c.id AS course_id,
    c.name AS course_name,
    c.design_mode,
    t.start_date,
    t.name AS term,
    COUNT(DISTINCT p.id) AS instructor_count,
    LISTAGG(DISTINCT p.first_name || ' ' || p.last_name, ', ')
        WITHIN GROUP (ORDER BY p.last_name, p.first_name) AS instructor_names,
    LISTAGG(DISTINCT p.email, ', ')
        WITHIN GROUP (ORDER BY p.email) AS instructor_emails,
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 2)
        ELSE 'Unknown'
    END AS institutional_hierarchy_level_1,
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 3)
        ELSE 'Unknown'
    END AS institutional_hierarchy_level_2,
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4)
        ELSE 'Unknown'
    END AS institutional_hierarchy_level_3,
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5)
        ELSE 'Unknown'
    END AS institutional_hierarchy_level_4
FROM cdm_lms.course c
INNER JOIN cdm_lms.term t
    ON t.id = c.term_id
INNER JOIN cdm_lms.person_course pc
    ON pc.course_id = c.id AND pc.course_role = 'I'
INNER JOIN cdm_lms.person p
    ON p.id = pc.person_id
INNER JOIN cdm_lms.institution_hierarchy_course ihc
    ON c.id = ihc.course_id AND ihc.primary_ind = 1
INNER JOIN cdm_lms.institution_hierarchy ih
    ON ih.id = ihc.institution_hierarchy_id
WHERE t.start_date BETWEEN '2024-07-31' AND '2025-04-01'
    AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
GROUP BY
    c.id, c.name, c.design_mode, t.start_date, t.name, ih.hierarchy_name_seq
ORDER BY t.start_date, instructor_count DESC, c.name;
