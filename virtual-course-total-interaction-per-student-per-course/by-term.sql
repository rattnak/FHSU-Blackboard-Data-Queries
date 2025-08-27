WITH filtered_courses AS (
    SELECT 
        c.id AS course_id,
        c.name AS course_name,
        c.design_mode,
        t.name AS term_name
    FROM cdm_lms.course c
    JOIN cdm_lms.term t ON c.term_id = t.id
    JOIN cdm_lms.course_item citem ON c.id = citem.course_id
    WHERE t.name = 'S2025'
      AND (
          c.name LIKE '%_VA_%' OR c.name LIKE '%_VB_%' OR c.name LIKE '%_VC_%' OR
          c.name LIKE '%_VD_%' OR c.name LIKE '%_VE_%' OR c.name LIKE '%_VF_%' OR
          c.name LIKE '%_VG_%' OR c.name LIKE '%_VH_%' OR c.name LIKE '%_VI_%' OR
          c.name LIKE '%_VJ_%' OR c.name LIKE '%_VK_%' OR c.name LIKE '%_VL_%' OR
          c.name LIKE '%_VM_%' OR c.name LIKE '%_VN_%' OR c.name LIKE '%_VO_%' OR
          c.name LIKE '%_VP_%' OR c.name LIKE '%_VQ_%' OR c.name LIKE '%_VR_%' OR
          c.name LIKE '%_VS_%' OR c.name LIKE '%_VT_%' OR c.name LIKE '%_VU_%' OR
          c.name LIKE '%_VV_%' OR c.name LIKE '%_VW_%' OR c.name LIKE '%_VX_%' OR
          c.name LIKE '%_VY_%' OR c.name LIKE '%_VZ_%'
      )
      AND c.name NOT LIKE '%-%V%'
      AND c.design_mode IN ('P', 'U', 'C')
      AND citem.available_ind = TRUE
),
course_interactions AS (
    SELECT
        ca.course_id,
        COUNT(DISTINCT ca.id) AS total_course_interactions,
        COUNT(DISTINCT ca.person_id) AS unique_students_interacted,
        MAX(ca.last_accessed_time) AS last_interaction_time
    FROM cdm_lms.course_activity ca
    JOIN cdm_lms.person_course lpc 
      ON lpc.person_id = ca.person_id 
     AND lpc.course_id = ca.course_id
    JOIN filtered_courses fc ON fc.course_id = ca.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY ca.course_id
    HAVING COUNT(DISTINCT ca.person_id) > 1
),
student_course_interactions AS (
    SELECT
        ca.person_id,
        ca.course_id,
        COUNT(DISTINCT ca.id) AS student_interactions
    FROM cdm_lms.course_activity ca
    JOIN cdm_lms.person_course lpc 
      ON lpc.person_id = ca.person_id 
     AND lpc.course_id = ca.course_id
    JOIN course_interactions ci ON ci.course_id = ca.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY ca.person_id, ca.course_id
)
SELECT DISTINCT
    sci.course_id,
    fc.course_name,
    s.id AS student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    sci.student_interactions,
    ci.last_interaction_time
FROM student_course_interactions sci
JOIN cdm_lms.person s ON s.id = sci.person_id
JOIN filtered_courses fc ON fc.course_id = sci.course_id
JOIN course_interactions ci ON ci.course_id = sci.course_id
ORDER BY sci.student_interactions DESC;
