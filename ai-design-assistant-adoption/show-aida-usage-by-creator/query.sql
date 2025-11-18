-- PURPOSE: SHOW AIDA USAGE BY CREATOR

with ai_summary as (
select
    ifnull(ih.hierarchy_name_seq, 'No Node') as ih_node,
    ifnull(t.name, 'No Term') as term,
    ci.course_id,
    c.name as course_name,
    c.course_number,
    ci.id as course_item_id,
    ci.item_type,
    ci.name,
    ci.stage,
    ci.ai_status,
    concat(p.first_name,' ',p.last_name) as creator,
    ci.created_time,
    ci.modified_time,
    --datediff(second,ci.created_time,ci.modified_time) as modified_x_seconds_after_creation,
    case when datediff(second,ci.created_time,ci.modified_time) > 10 then 'Modified' else 'Unmodified' end as modified_indicator
from cdm_lms.course_item ci
inner join cdm_lms.person p
    on p.id = ci.person_id
inner join cdm_lms.course c
    on c.id = ci.course_id
left join cdm_lms.institution_hierarchy_course ihc
    on ihc.course_id = c.id
    And ihc.primary_ind = 1
left join cdm_lms.institution_hierarchy ih
    on ihc.institution_hierarchy_id = ih.id
left join cdm_lms.term t
    on t.id = c.term_id
)
select creator, count(course_item_id) from ai_summary where ai_status = 'Y' group by 1 order by 2 desc;