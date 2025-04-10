SELECT
    lc.id AS course_id,
    lc.name AS course_name,
    lc.design_mode,
    lt.start_date,
    lt.name AS term,
    CONCAT(p.first_name, ' ', p.last_name) AS instructor_name,  -- Combine first and last name for instructor
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 2)
        ELSE 'Unknown'  -- Level 1: 'Fort Hays State University'
    END AS institutional_hierarchy_level_1,  -- University: 'Fort Hays State University'
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 3)
        ELSE 'Unknown'  -- Level 2: College
    END AS institutional_hierarchy_level_2,  -- College
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 4)
        ELSE 'Unknown'  -- Level 3: Department
    END AS institutional_hierarchy_level_3,  -- Department
    CASE
        WHEN ih.hierarchy_name_seq IS NOT NULL THEN SPLIT_PART(ih.hierarchy_name_seq, '||', 5)
        ELSE 'Unknown'  -- Level 4: Major
    END AS institutional_hierarchy_level_4  
FROM cdm_lms.course lc
INNER JOIN cdm_lms.term lt 
    ON lt.id = lc.term_id
INNER JOIN cdm_lms.person_course lpc  -- Join person_course to filter by course_role
    ON lpc.course_id = lc.id 
    AND lpc.course_role = 'I'  -- Only instructors
INNER JOIN cdm_lms.person p  -- Join person to get first and last name
    ON p.id = lpc.person_id
INNER JOIN cdm_lms.institution_hierarchy_course ihc 
    ON lc.id = ihc.course_id  -- Link course to institution hierarchy
INNER JOIN cdm_lms.institution_hierarchy ih 
    ON ih.id = ihc.institution_hierarchy_id ;  -- Link institution hierarchy to course