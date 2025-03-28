SELECT
    lc.id AS course_id,
    lc.name AS course_name,
    lc.design_mode,
    lt.start_date,
    lt.name AS term,

FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt ON lt.id = lc.term_id
WHERE lt.start_date > '{date}'
ORDER BY lt.start_date, lc.name;