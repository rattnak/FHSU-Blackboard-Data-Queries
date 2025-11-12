# Filter All Tool Interaction by College and Department

## Queries
- `by-term-query.sql`: Tool interaction filtered to specific college AND department for a term
- `between-date-query.sql`: Tool interaction filtered to specific college AND department between dates

## Overview

This query provides tool interaction metrics filtered to a specific college AND department (e.g., College of Education, Teacher Education). It tracks 8 educational technology tools but limits results to courses within one specific department.

**Primary Use Cases:**
- Department-level technology adoption analysis
- Department chair reporting and planning
- Granular tool usage tracking
- Department-specific support planning
- Faculty recognition within departments

## Tracked Tools
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## How to Change Filters

Modify both college AND department filters:
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 5) = 'Teacher Education'
```

Both must match EXACTLY (case-sensitive).

### Finding Department Names

If unsure of exact department names, first run:
```sql
SELECT DISTINCT
    SPLIT_PART(ih.hierarchy_name_seq, '||', 4) as college,
    SPLIT_PART(ih.hierarchy_name_seq, '||', 5) as department
FROM ...
WHERE SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'Your College Name'
ORDER BY department
```

## Performance Tips

**Estimated Execution Time:**
- Single department, single term: 5-8 seconds
- Single department, academic year: 12-18 seconds

**Fastest tool query variant** due to narrow filtering.

**Warehouse Sizing:**
- Small: Sufficient

## Analysis Examples

### Department Tool Adoption Summary
```sql
SELECT
    tool_name,
    COUNT(DISTINCT course_id) as courses,
    COUNT(DISTINCT instructors) as instructors,
    SUM(tool_interaction_count) as interactions
GROUP BY tool_name
ORDER BY courses DESC
```

### Top Courses in Department
```sql
SELECT
    course_name,
    instructors,
    tool_name,
    students_interacted_count,
    tool_interaction_count
ORDER BY tool_interaction_count DESC
```

### Instructor Innovation in Department
```sql
SELECT
    instructors,
    COUNT(DISTINCT tool_name) as tools_used,
    COUNT(DISTINCT course_id) as courses,
    SUM(tool_interaction_count) as total_interactions
GROUP BY instructors
ORDER BY tools_used DESC, courses DESC
```

## Use Cases by Role

### Department Chairs
- Monitor technology use in department
- Recognize innovative faculty
- Plan department professional development
- Report to college/academic affairs
- Justify department technology needs

### Faculty within Department
- Compare their usage to department peers
- Discover tools colleagues are using
- Connect with peers using same tools
- Learn from high-engagement courses

### Instructional Designers
- Target support to specific department
- Build department-specific tool communities
- Share department-relevant examples
- Track department-level trends

### Academic Technology Staff
- Prioritize support by department needs
- Plan department-specific training
- Build relationships with department faculty
- Customize support for discipline needs

## Related Queries

- **course-tool-interaction**: All tools, all courses (parent)
- **filter-all-tool-interaction-by-college**: All departments in college
- **filter-specific-tool-interaction**: Single tool, institution-wide
- **filter-course-by-college-department**: All courses in department (no tool filter)

## Best Practices

1. **Partner with Department Chairs**: Share data for their planning
2. **Recognize Innovation**: Celebrate faculty using tools effectively
3. **Target Support**: Offer department-specific tool training
4. **Share Successes**: Highlight exemplar courses within department
5. **Track Growth**: Run termly to monitor adoption trends
6. **Build Community**: Connect tool users in same discipline
7. **Respect Context**: Understand tools may fit some disciplines better
8. **Compare Fairly**: Consider department size and course types
