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
        COUNT(DISTINCT ca.id) AS total_course_interaction_count,
        COUNT(DISTINCT ca.person_id) AS student_course_interaction_count
    FROM cdm_lms.course_activity ca
    JOIN cdm_lms.person_course lpc 
        ON lpc.person_id = ca.person_id
       AND lpc.course_id = ca.course_id
    LEFT JOIN filtered_courses fc ON fc.course_id = ca.course_id
    WHERE lpc.course_role = 'S'
    GROUP BY ca.course_id
),

student_courses_unique AS (
    SELECT DISTINCT
        lpc.person_id,
        lpc.course_id,
        ci.total_course_interaction_count,
        ci.student_course_interaction_count,
        fc.course_name
    FROM cdm_lms.person_course lpc
    JOIN filtered_courses fc ON fc.course_id = lpc.course_id
    JOIN course_interactions ci ON ci.course_id = lpc.course_id
    WHERE lpc.course_role = 'S'
)

SELECT
    s.id AS person_id,
    TRIM(s.first_name) || ' ' || TRIM(s.last_name) AS student_name,

    COUNT(scu.course_id) AS number_of_courses_enrolled,

    LISTAGG(DISTINCT scu.course_id, ', ') WITHIN GROUP (ORDER BY scu.course_id) AS course_ids,

    LISTAGG(DISTINCT scu.course_name, ', ') WITHIN GROUP (ORDER BY scu.course_name) AS courses_enrolled,

    ROUND(
        SUM(
            (scu.total_course_interaction_count * 1.0 / scu.student_course_interaction_count)
            * scu.total_course_interaction_count
        )
        / NULLIF(SUM(scu.total_course_interaction_count), 0),
        2
    ) AS weighted_avg_interaction_per_student

FROM student_courses_unique scu
JOIN cdm_lms.person s ON s.id = scu.person_id
GROUP BY s.id, TRIM(s.first_name), TRIM(s.last_name)
ORDER BY weighted_avg_interaction_per_student DESC;
