-- PURPOSE: SHOW DETAILS OF ITEMS CREATED USING AIDA

with ai_summary as (
select
    ifnull(ih.hierarchy_name_seq, 'No Node') as ih_node,
    ifnull(lt.name, 'No Term') as term,
    lci.course_id,
    lc.name as course_name,
    lc.course_number,
    lci.id as course_item_id,
    lci.item_type,
    lci.name,
    lci.stage,
    lci.ai_status,
    concat(lp.first_name,' ',lp.last_name) as creator,
    lci.created_time,
    lci.modified_time,
    --datediff(second,lci.created_time,lci.modified_time) as modified_x_seconds_after_creation,
    case when datediff(second,lci.created_time,lci.modified_time) > 10 then 'Modified' else 'Unmodified' end as modified_indicator
from cdm_lms.course_item lci
inner join cdm_lms.person lp
    on lp.id = lci.person_id
inner join cdm_lms.course lc
    on lc.id = lci.course_id
left join cdm_lms.institution_hierarchy_course ihc
    on ihc.course_id = lc.id
    And ihc.primary_ind = 1
left join cdm_lms.institution_hierarchy ih
    on ihc.institution_hierarchy_id = ih.id
left join cdm_lms.term lt
    on lt.id = lc.term_id
)


select * from ai_summary where ai_status = 'Y' order by created_time desc;