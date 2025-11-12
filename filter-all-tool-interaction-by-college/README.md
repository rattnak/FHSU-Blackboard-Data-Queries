# Filter All Tool Interaction by College

## Queries
- `by-term-query.sql`: Tool interaction data filtered to a specific college for a term
- `between-date-query.sql`: Tool interaction data filtered to a specific college between dates

## Overview

This query provides tool interaction metrics filtered to a specific college (e.g., College of Education). It tracks the same 8 educational technology tools as the parent query but limits results to courses within one college.

**Primary Use Cases:**
- College-level technology adoption analysis
- Department chair tool usage reporting
- College-specific tool support planning
- College EdTech budget justification
- Comparative analysis across colleges

## Tracked Tools
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## Output Columns

Same as `course-tool-interaction` query, but filtered to one college:
- Course and term information
- Tool name and interaction metrics
- Student engagement counts
- Last interaction time
- Instructor information
- Organizational hierarchy (all at same college level)

## How to Change the College Filter

Find and modify this line in the query:
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
```

Replace with your desired college name:
- `'College of Arts, Humanities & Social Sciences'`
- `'College of Business and Entrepreneurship'`
- `'College of Health and Life Sciences'`
- `'College of Education'`

**Important**: College name must match EXACTLY (case-sensitive).

## Performance Tips

**Estimated Execution Time:**
- Single college, single term: 10-15 seconds
- Single college, academic year: 25-35 seconds

**Faster than institution-wide query** due to college filter.

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended

## Analysis Examples

### College-Wide Tool Adoption Summary
```sql
SELECT
    tool_name,
    COUNT(DISTINCT course_id) as courses,
    SUM(students_interacted_count) as total_students,
    SUM(tool_interaction_count) as total_interactions
GROUP BY tool_name
ORDER BY courses DESC
```

### Department Breakdown Within College
```sql
SELECT
    institutional_hierarchy_level_4 as department,
    tool_name,
    COUNT(DISTINCT course_id) as courses
GROUP BY department, tool_name
ORDER BY department, courses DESC
```

### Top Tool-Using Instructors in College
```sql
SELECT
    instructors,
    COUNT(DISTINCT course_id) as courses_with_tools,
    SUM(tool_interaction_count) as total_interactions
GROUP BY instructors
ORDER BY courses_with_tools DESC
```

### Most Engaged Courses in College
```sql
SELECT
    course_name,
    instructors,
    tool_name,
    students_interacted_count,
    tool_interaction_count
ORDER BY tool_interaction_count DESC
LIMIT 20
```

## Use Cases by Role

### College Deans
- Monitor technology integration in college
- Justify college-level EdTech investments
- Compare departments within college
- Showcase innovation to stakeholders

### Department Chairs (in filtered college)
- See departmental tool usage context
- Compare department to college peers
- Plan department-level technology initiatives
- Recognize departmental innovation

### College EdTech Liaisons
- Target support to college courses
- Plan college-specific training
- Build college EdTech community
- Share college-specific best practices

### Instructional Design Teams
- Prioritize support by college needs
- Assign designers to college-specific tools
- Share exemplars within college context
- Track college-level engagement trends

## Comparative Analysis Across Colleges

Run the query multiple times for different colleges, then compare:

```sql
-- Run separately for each college, then combine results

College A: [Tool adoption metrics]
College B: [Tool adoption metrics]
College C: [Tool adoption metrics]

Comparison:
- Which college has highest tool adoption?
- Which tools are popular in which colleges?
- Where should EdTech support be focused?
```

## Related Queries

- **course-tool-interaction**: All tools, all colleges (parent query)
- **filter-all-tool-interaction-by-college-department**: Further filtered to department
- **filter-specific-tool-interaction**: Single tool, all colleges
- **filter-course-by-college**: All courses in college (no tool filter)

## Best Practices

1. **Customize College Name**: Ensure exact match with your hierarchy
2. **Run for Each College**: Compare adoption patterns
3. **Share with College Leadership**: Provide data for decision-making
4. **Celebrate College Success**: Recognize college-level innovation
5. **Target Support**: Focus resources where adoption is growing
6. **Build College Community**: Connect tool users within college
7. **Plan College Training**: Use data for college-specific PD
8. **Track Trends**: Run termly to monitor college progress
