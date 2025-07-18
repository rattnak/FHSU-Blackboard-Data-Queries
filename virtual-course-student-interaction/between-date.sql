WITH filtered_courses AS (
    SELECT 
        c.id AS course_id,
        c.name AS course_name,
        c.design_mode,
        c.term_id,
        t.start_date,
        t.name AS term_name
    FROM cdm_lms.course c
    JOIN cdm_lms.term t ON c.term_id = t.id
    WHERE t.start_date BETWEEN '2024-07-31' AND '2025-04-01'
),

course_interactions AS (
    SELECT
        ca.course_id,
        COUNT(DISTINCT ca.id) AS total_interaction_count, 
        MAX(ca.last_accessed_time) AS last_interaction_time,
        COUNT(DISTINCT ca.person_id) AS unique_students_interacted
    FROM cdm_lms.course_activity ca
    JOIN cdm_lms.person_course lpc ON lpc.person_id = ca.person_id AND lpc.course_id = ca.course_id
    JOIN filtered_courses fc ON fc.course_id = ca.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY ca.course_id
),

student_counts AS (
    SELECT
        lpc.course_id,
        COUNT(DISTINCT lpc.person_id) AS total_student_count
    FROM cdm_lms.person_course lpc
    JOIN filtered_courses fc ON lpc.course_id = fc.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY lpc.course_id
)

SELECT
    fc.course_id,
    fc.course_name,
    fc.design_mode,
    fc.start_date,
    fc.term_name AS term,

    COUNT(DISTINCT p.id) AS instructor_count,
    LISTAGG(DISTINCT CONCAT(p.first_name, ' ', p.last_name), ', ')
        WITHIN GROUP (ORDER BY CONCAT(p.first_name, ' ', p.last_name)) AS instructors,
    LISTAGG(DISTINCT p.email, ', ')
        WITHIN GROUP (ORDER BY p.email) AS instructor_emails,

    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institutional_hierarchy_level_3,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institutional_hierarchy_level_4,

    COALESCE(sc.total_student_count, 0) AS total_student_count,
    COALESCE(ci.total_interaction_count, 0) AS total_course_interaction_count,
    COALESCE(ci.unique_students_interacted, 0) AS student_course_interaction_count,
    TO_CHAR(ci.last_interaction_time, 'YYYY-MM-DD HH24:MI:SS') AS last_course_interaction

FROM filtered_courses fc

JOIN cdm_lms.person_course lpc ON lpc.course_id = fc.course_id AND lpc.course_role = 'I'
JOIN cdm_lms.person p ON p.id = lpc.person_id
JOIN cdm_lms.institution_hierarchy_course ihc ON fc.course_id = ihc.course_id
JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
LEFT JOIN course_interactions ci ON ci.course_id = fc.course_id
LEFT JOIN student_counts sc ON sc.course_id = fc.course_id

WHERE fc.course_name LIKE '%_V_%'
  AND fc.design_mode IN ('U', 'P')

GROUP BY
    fc.course_id, fc.course_name, fc.design_mode, fc.start_date, fc.term_name, ih.hierarchy_name_seq,
    ci.total_interaction_count, ci.unique_students_interacted, ci.last_interaction_time,
    sc.total_student_count

ORDER BY fc.start_date, fc.course_name, instructor_count DESC;
