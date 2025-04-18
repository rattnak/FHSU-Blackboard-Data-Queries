WITH items AS (
    SELECT
        lct.tool_id,
        COUNT(DISTINCT lci.course_id) AS distinct_courses,
        COUNT(DISTINCT lci.id) AS distinct_items,
        COUNT(DISTINCT lcia.id) AS item_accesses,
        COUNT(DISTINCT lcia.course_item_id) AS distinct_items_accessed,
        COUNT(DISTINCT lcia.person_id) AS distinct_item_users,
        SUM(lcia.duration_sum) / 60 AS item_minutes
    FROM cdm_lms.course_tool lct
    INNER JOIN cdm_lms.course_item lci ON lci.course_tool_id = lct.id
    LEFT JOIN cdm_lms.course_item_activity lcia ON lcia.course_item_id = lci.id
    GROUP BY lct.tool_id
), 
tools AS (
    SELECT
        lct.tool_id,
        COUNT(DISTINCT lcta.course_id) AS distinct_tool_course_accessed,
        COUNT(DISTINCT lcta.id) AS tool_accesses,
        COUNT(DISTINCT lcta.person_id) AS distinct_tool_users,
        SUM(lcta.duration_sum) / 60 AS tool_minutes
    FROM cdm_lms.course_tool lct
    INNER JOIN cdm_lms.course_tool_activity lcta ON lcta.course_tool_id = lct.id
    GROUP BY lct.tool_id
)

SELECT
    lt.plugin_vendor,
    lt.name,
    lt.plugin_desc,
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
FROM cdm_lms.tool lt
LEFT JOIN items i ON i.tool_id = lt.id
LEFT JOIN tools t ON t.tool_id = lt.id
WHERE LOWER(lt.name) NOT LIKE 'resource/%'
  AND (
      LOWER(lt.name) LIKE '%yellowdig engage%'
      OR LOWER(lt.name) LIKE '%packback%'
      OR LOWER(lt.name) LIKE '%feedback%'
      OR LOWER(lt.name) LIKE '%inscribe%'
      OR LOWER(lt.name) LIKE '%goreact%'
      OR LOWER(lt.name) LIKE '%qwickly%'
      OR LOWER(lt.name) LIKE '%voicethread%'
      OR LOWER(lt.name) LIKE '%zoom%'
  )
ORDER BY item_minutes DESC, tool_minutes DESC;
