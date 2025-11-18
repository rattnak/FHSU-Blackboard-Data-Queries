SELECT
    c.id AS course_id,
    c.name AS course_name,
    c.design_mode,
    t.start_date,
    t.name AS term,
    ci.name AS syllabus_item_name,
    CAST(ci.created_time AS DATE) AS item_created_date,
    CAST(ci.modified_time AS DATE) AS item_modified_date,
    CASE 
        WHEN ci.modified_time > ci.created_time + INTERVAL '1 year' 
             THEN 'Outdated'
        ELSE 'Current'
    END AS syllabus_status,
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
INNER JOIN cdm_lms.course_item ci
    ON ci.course_id = c.id 
    AND LOWER(ci.name) LIKE '%syllabus%' 
    AND ci.row_deleted_time IS NULL
WHERE t.start_date BETWEEN '2024-07-31' AND '2025-04-01'
  AND c.row_deleted_time IS NULL
GROUP BY
    c.id, c.name, c.design_mode, t.start_date, t.name,
    ci.name, ci.created_time, ci.modified_time,
    ih.hierarchy_name_seq
ORDER BY t.start_date, c.name;
