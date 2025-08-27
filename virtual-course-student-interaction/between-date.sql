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

-- per-student rollup, then course-level rollup (keeps your logic, excludes inactive via person_course)
course_interactions AS (
    SELECT
        s.course_id,
        SUM(s.interaction_count)          AS total_interaction_count,
        COUNT(*)                          AS unique_students_interacted,
        MAX(s.interaction_count)          AS max_interaction_per_student,
        MIN(s.interaction_count)          AS min_interaction_per_student,
        ROUND(SUM(s.interaction_count) / COUNT(*), 2) AS avg_interaction_per_student,
        MAX(s.last_accessed_time)         AS last_interaction_time
    FROM (
        SELECT
            ca.course_id,
            ca.person_id,
            COUNT(DISTINCT ca.id)         AS interaction_count,
            MAX(ca.last_accessed_time)    AS last_accessed_time
        FROM cdm_lms.course_activity ca
        JOIN cdm_lms.person_course lpc
          ON lpc.person_id = ca.person_id
         AND lpc.course_id = ca.course_id
        JOIN filtered_courses fc
          ON fc.course_id = ca.course_id
        WHERE lpc.course_role = 'S'
        GROUP BY ca.course_id, ca.person_id
    ) s
    GROUP BY s.course_id
),

-- count of students with at least one interaction (aligns with your exclusion logic)
student_counts AS (
    SELECT
        ca.course_id,
        COUNT(DISTINCT ca.person_id) AS total_student_count
    FROM cdm_lms.course_activity ca
    JOIN cdm_lms.person_course lpc
      ON lpc.person_id = ca.person_id
     AND lpc.course_id = ca.course_id
    JOIN filtered_courses fc
      ON fc.course_id = ca.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY ca.course_id
)

SELECT
    fc.course_id,
    fc.course_name,
    fc.design_mode,
    fc.start_date,
    fc.term_name AS term,

    -- COUNT(DISTINCT p.id) AS instructor_count,
    -- LISTAGG(DISTINCT CONCAT(p.first_name, ' ', p.last_name), ', ')
    --     WITHIN GROUP (ORDER BY CONCAT(p.first_name, ' ', p.last_name)) AS instructors,
    -- LISTAGG(DISTINCT p.email, ', ')
    --     WITHIN GROUP (ORDER BY p.email) AS instructor_emails,

    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institutional_hierarchy_level_3,
    CASE WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institutional_hierarchy_level_4,

    -- COALESCE(sc.total_student_count, 0)            AS total_student_count,
    COALESCE(ci.total_interaction_count, 0)        AS total_course_interaction_count,
    COALESCE(ci.unique_students_interacted, 0)     AS active_student_count,
    -- ci.max_interaction_per_student,
    -- ci.min_interaction_per_student,
    ci.avg_interaction_per_student,
    TO_CHAR(ci.last_interaction_time, 'YYYY-MM-DD HH24:MI:SS') AS last_course_interaction

FROM filtered_courses fc
JOIN cdm_lms.person_course lpc
  ON lpc.course_id = fc.course_id
 AND lpc.course_role = 'I'
JOIN cdm_lms.person p ON p.id = lpc.person_id
JOIN cdm_lms.institution_hierarchy_course ihc ON fc.course_id = ihc.course_id
JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
LEFT JOIN course_interactions ci ON ci.course_id = fc.course_id
LEFT JOIN student_counts sc ON sc.course_id = fc.course_id
JOIN cdm_lms.course_item citem ON lpc.course_id = citem.course_id

WHERE fc.course_name LIKE '%_V_%'
  AND (
          fc.course_name  LIKE '%_VA_%' OR fc.course_name  LIKE '%_VB_%' OR fc.course_name LIKE '%_VC_%' OR
          fc.course_name LIKE '%_VD_%' OR fc.course_name LIKE '%_VE_%' OR fc.course_name LIKE '%_VF_%' OR
          fc.course_name  LIKE '%_VG_%' OR fc.course_name LIKE '%_VH_%' OR fc.course_name LIKE '%_VI_%' OR
          fc.course_name  LIKE '%_VJ_%' OR fc.course_name LIKE '%_VK_%' OR fc.course_name LIKE '%_VL_%' OR
          fc.course_name  LIKE '%_VM_%' OR fc.course_name LIKE '%_VN_%' OR fc.course_name LIKE '%_VO_%' OR
          fc.course_name  LIKE '%_VP_%' OR fc.course_name LIKE '%_VQ_%' OR fc.course_name LIKE '%_VR_%' OR
          fc.course_name  LIKE '%_VS_%' OR fc.course_name LIKE '%_VT_%' OR fc.course_name LIKE '%_VU_%' OR
          fc.course_name  LIKE '%_VV_%' OR fc.course_name LIKE '%_VW_%' OR fc.course_name LIKE '%_VX_%' OR
          fc.course_name  LIKE '%_VY_%' OR fc.course_name LIKE '%_VZ_%'
      )
  AND fc.course_name NOT LIKE '%-%V%'
  AND fc.design_mode IN ('P', 'U', 'C')
  AND citem.available_ind = TRUE
  AND ci.last_interaction_time IS NOT NULL
  AND sc.total_student_count > 1

GROUP BY
    fc.course_id, fc.course_name, fc.design_mode, fc.start_date, fc.term_name, ih.hierarchy_name_seq,
    ci.total_interaction_count, ci.unique_students_interacted, ci.last_interaction_time,
    ci.max_interaction_per_student, ci.min_interaction_per_student, ci.avg_interaction_per_student,
    sc.total_student_count

ORDER BY fc.start_date, fc.course_name;
