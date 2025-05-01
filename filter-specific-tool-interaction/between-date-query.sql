-- SET SEARCH TERM (you can change 'yellowdig' to another tool)
WITH approved_tool_names AS (
    SELECT '%yellowdig engage%' AS pattern
    UNION ALL SELECT '%packback%'
    UNION ALL SELECT '%feedback%'
    UNION ALL SELECT '%inscribe%'
    UNION ALL SELECT '%goreact%'
    UNION ALL SELECT '%qwickly%'
    UNION ALL SELECT '%voicethread%'
    UNION ALL SELECT '%zoom%'
),

-- Step 1: Get all course IDs that used the SEARCHED tool
searched_courses AS (
    SELECT DISTINCT cta.course_id
    FROM cdm_lms.course_tool_activity cta
    JOIN cdm_lms.tool t ON cta.tool_id = t.id
    JOIN cdm_lms.course c ON c.id = cta.course_id
    JOIN cdm_lms.term term ON term.id = c.term_id
    WHERE term.start_date BETWEEN '2024-07-31' AND '2025-04-01'
      AND t.visible_ind = TRUE
      AND LOWER(t.name) LIKE '%yellowdig engage%'  -- <<== Search term
),

-- Step 2: Tool usage for those courses, filtered to approved tools
tool_usage AS (
    SELECT
        cta.course_id,
        cta.tool_id,
        t.name AS tool_name,
        cta.person_course_id,
        MAX(cta.last_accessed_time) AS last_accessed_time,
        SUM(cta.interaction_cnt) AS total_interaction_cnt
    FROM cdm_lms.course_tool_activity cta
    JOIN cdm_lms.tool t ON cta.tool_id = t.id
    JOIN searched_courses sc ON sc.course_id = cta.course_id
    WHERE t.visible_ind = TRUE
      AND LOWER(t.name) NOT LIKE 'resource/%'
      AND EXISTS (
          SELECT 1 FROM approved_tool_names atn
          WHERE LOWER(t.name) LIKE atn.pattern
      )
    GROUP BY cta.course_id, cta.tool_id, t.name, cta.person_course_id
    HAVING SUM(cta.interaction_cnt) > 0
),

-- Step 3: Aggregate tool usage per course
per_tool_course_agg AS (
    SELECT
        tu.course_id,
        lc.name AS course_name,
        lc.design_mode,
        lt.name AS term,
        lt.start_date,
        tu.tool_id,
        tu.tool_name,
        COUNT(DISTINCT CASE WHEN lpc.course_role = 'S' THEN lpc.person_id END) AS students_used_tool,
        SUM(tu.total_interaction_cnt) AS total_interactions,
        MAX(tu.last_accessed_time) AS last_accessed_time,
        ih.hierarchy_name_seq
    FROM tool_usage tu
    JOIN cdm_lms.person_course lpc ON lpc.id = tu.person_course_id
    JOIN cdm_lms.course lc ON lc.id = tu.course_id
    JOIN cdm_lms.term lt ON lt.id = lc.term_id
    JOIN cdm_lms.institution_hierarchy_course ihc ON ihc.course_id = lc.id
    JOIN cdm_lms.institution_hierarchy ih ON ih.id = ihc.institution_hierarchy_id
    GROUP BY tu.course_id, lc.name, lc.design_mode, lt.name, lt.start_date, ih.hierarchy_name_seq, tu.tool_id, tu.tool_name
),

-- Step 4: Combine tools per course
tool_agg_per_course AS (
    SELECT
        course_id,
        LISTAGG(tool_name || ': ' || total_interactions, ', ') WITHIN GROUP (ORDER BY tool_name) AS tool_interaction_detail,
        SUM(total_interactions) AS total_tool_interaction_count
    FROM per_tool_course_agg
    GROUP BY course_id
)

-- Final SELECT
SELECT
    pta.course_id,
    pta.course_name,
    pta.design_mode,
    pta.term,
    pta.start_date,
    (
        SELECT COUNT(DISTINCT lpc1.person_id)
        FROM cdm_lms.person_course lpc1
        WHERE lpc1.course_id = pta.course_id AND lpc1.course_role = 'I'
    ) AS instructor_count,
    (
        SELECT LISTAGG(DISTINCT p.first_name || ' ' || p.last_name, ', ')
        FROM cdm_lms.person_course lpc2
        JOIN cdm_lms.person p ON p.id = lpc2.person_id
        WHERE lpc2.course_id = pta.course_id AND lpc2.course_role = 'I'
    ) AS instructor_name,
    (
        SELECT LISTAGG(DISTINCT p.email, ', ')
        FROM cdm_lms.person_course lpc3
        JOIN cdm_lms.person p ON p.id = lpc3.person_id
        WHERE lpc3.course_id = pta.course_id AND lpc3.course_role = 'I'
    ) AS instructor_email,
    (
        SELECT COUNT(DISTINCT tu.tool_name)
        FROM tool_usage tu
        WHERE tu.course_id = pta.course_id
    ) AS tool_count,
    (
        SELECT COUNT(DISTINCT lpc4.person_id)
        FROM cdm_lms.person_course lpc4
        WHERE lpc4.course_id = pta.course_id AND lpc4.course_role = 'S'
    ) AS total_student,
    tag.tool_interaction_detail,
    pta.students_used_tool AS students_tool_interaction_count,
    tag.total_tool_interaction_count,
    TO_CHAR(pta.last_accessed_time, 'YYYY-MM-DD HH24:MI:SS') AS tool_last_accessed_time,
    CASE WHEN pta.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(pta.hierarchy_name_seq, '||', 2) ELSE 'Unknown' END AS institution_hierarchy_level_1,
    CASE WHEN pta.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(pta.hierarchy_name_seq, '||', 3) ELSE 'Unknown' END AS institution_hierarchy_level_2,
    CASE WHEN pta.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(pta.hierarchy_name_seq, '||', 4) ELSE 'Unknown' END AS institution_hierarchy_level_3,
    CASE WHEN pta.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(pta.hierarchy_name_seq, '||', 5) ELSE 'Unknown' END AS institution_hierarchy_level_4
FROM per_tool_course_agg pta
JOIN tool_agg_per_course tag ON tag.course_id = pta.course_id
ORDER BY pta.course_name, pta.tool_name;
