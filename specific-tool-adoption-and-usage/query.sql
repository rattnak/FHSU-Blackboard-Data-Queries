WITH items AS (
    SELECT
        ct.tool_id,
        COUNT(DISTINCT ci.course_id) AS distinct_courses,
        COUNT(DISTINCT ci.id) AS distinct_items,
        COUNT(DISTINCT cia.id) AS item_accesses,
        COUNT(DISTINCT cia.course_item_id) AS distinct_items_accessed,
        COUNT(DISTINCT cia.person_id) AS distinct_item_users,
        SUM(cia.duration_sum) / 60 AS item_minutes
    FROM cdm_lms.course_tool ct
    INNER JOIN cdm_lms.course_item ci ON ci.course_tool_id = ct.id
    LEFT JOIN cdm_lms.course_item_activity cia ON cia.course_item_id = ci.id
    GROUP BY ct.tool_id
),
tools AS (
    SELECT
        ct.tool_id,
        COUNT(DISTINCT cta.course_id) AS distinct_tool_course_accessed,
        COUNT(DISTINCT cta.id) AS tool_accesses,
        COUNT(DISTINCT cta.person_id) AS distinct_tool_users,
        SUM(cta.duration_sum) / 60 AS tool_minutes
    FROM cdm_lms.course_tool ct
    INNER JOIN cdm_lms.course_tool_activity cta ON cta.course_tool_id = ct.id
    GROUP BY ct.tool_id
)

SELECT
    tl.plugin_vendor,
    tl.name,
    tl.plugin_desc,
    IFNULL(i.distinct_courses, 0) AS distinct_courses,
    IFNULL(i.distinct_items, 0) AS distinct_items,
    IFNULL(i.distinct_items_accessed, 0) AS distinct_items_accessed,
    ROUND(IFNULL(i.distinct_items_accessed / NULLIF(i.distinct_items, 0), 0), 2) AS pc_items_accessed,
    IFNULL(i.item_accesses, 0) AS item_accesses,
    IFNULL(i.distinct_item_users, 0) AS distinct_item_users,
    ROUND(IFNULL(i.item_minutes, 0), 0) AS item_minutes,
    IFNULL(t.distinct_tool_course_accessed, 0) AS distinct_tool_course_accessed,
    IFNULL(t.distinct_tool_users, 0) AS distinct_tool_users,
    IFNULL(t.tool_accesses, 0) AS tool_accesses,
    ROUND(IFNULL(t.tool_minutes, 0), 0) AS tool_minutes
FROM cdm_lms.tool tl
LEFT JOIN items i ON i.tool_id = tl.id
LEFT JOIN tools t ON t.tool_id = tl.id
WHERE LOWER(tl.name) NOT LIKE 'resource/%'
  AND (
      LOWER(tl.name) LIKE '%yellowdig engage%'
      OR LOWER(tl.name) LIKE '%packback%'
      OR LOWER(tl.name) LIKE '%feedback%'
      OR LOWER(tl.name) LIKE '%inscribe%'
      OR LOWER(tl.name) LIKE '%goreact%'
      OR LOWER(tl.name) LIKE '%qwickly%'
      OR LOWER(tl.name) LIKE '%voicethread%'
      OR LOWER(tl.name) LIKE '%zoom%'
  )
ORDER BY item_minutes DESC, tool_minutes DESC;
