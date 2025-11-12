# Filter Specific Tool Interaction

## Queries
- `by-term-query.sql`: Analyze interactions for a SPECIFIC tool in a specific term
- `between-date-query.sql`: Analyze interactions for a SPECIFIC tool between specific dates

## Overview

This query focuses on a single educational technology tool (default: YellowDig Engage) and shows only courses using that tool with their interaction metrics. This is a filtered subset of the `course-tool-interaction` query.

**Primary Use Cases:**
- Deep-dive analysis of single tool adoption
- Generate support lists for specific tool users
- Tool-specific effectiveness research
- Vendor reporting and ROI analysis
- Targeted professional development planning

## Default Tool
**YellowDig Engage** - Social learning discussion platform

To analyze a different tool, modify the search pattern in the query.

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `tool_name` | Name of the tool (e.g., "YellowDig Engage") |
| `tool_interaction_count` | Total interactions with the tool in this course |
| `students_interacted_count` | Number of unique students who used the tool |
| `last_interaction_time` | Most recent interaction timestamp |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## How to Change the Tool

### Option 1: Modify the WHERE Clause

Find and replace the tool name in the query:
```sql
WHERE LOWER(ci.name) LIKE '%yellowdig%'
```

Change to your desired tool:
```sql
WHERE LOWER(ci.name) LIKE '%packback%'    -- Packback
WHERE LOWER(ci.name) LIKE '%goreact%'      -- GoReact
WHERE LOWER(ci.name) LIKE '%voicethread%'  -- VoiceThread
WHERE LOWER(ci.name) LIKE '%zoom%'         -- Zoom
WHERE LOWER(ci.name) LIKE '%qwickly%'      -- Qwickly
WHERE LOWER(ci.name) LIKE '%inscribe%'     -- Inscribe
WHERE LOWER(ci.name) LIKE '%feedback%'     -- Feedback
```

### Option 2: Add Multiple Name Patterns

Some tools may have variations:
```sql
WHERE (LOWER(ci.name) LIKE '%yellowdig%'
    OR LOWER(ci.name) LIKE '%yellow dig%'
    OR LOWER(ci.name) LIKE '%yd engage%')
```

## Performance Tips

**Estimated Execution Time:**
- Single tool, single term: 8-12 seconds
- Single tool, academic year: 20-30 seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for multiple terms

**Faster than multi-tool query** because it filters to only one tool.

## Analysis Examples

### Total Adoption Metrics
```sql
SELECT
    COUNT(DISTINCT course_id) as total_courses,
    COUNT(DISTINCT instructors) as total_instructors,
    SUM(tool_interaction_count) as total_interactions,
    SUM(students_interacted_count) as total_students
```

### High-Usage Courses
```sql
SELECT
    course_name,
    instructors,
    students_interacted_count,
    tool_interaction_count
ORDER BY tool_interaction_count DESC
LIMIT 25
```

### Adoption by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(DISTINCT course_id) as course_count,
    AVG(tool_interaction_count) as avg_interactions
GROUP BY college
ORDER BY course_count DESC
```

### Recently Active Courses
```sql
WHERE last_interaction_time >= CURRENT_DATE - INTERVAL '7 DAYS'
ORDER BY last_interaction_time DESC
```

### Low-Usage Courses (May Need Support)
```sql
WHERE tool_interaction_count < 10
ORDER BY start_date DESC
```

## Use Cases by Tool

### YellowDig Engage
- Monitor social learning adoption
- Identify high-engagement discussion courses
- Support community-building initiatives

### Packback
- Track AI-powered discussion usage
- Analyze critical thinking integration
- Support writing-intensive courses

### GoReact
- Monitor video assessment adoption
- Support performance-based courses
- Track skills demonstration courses

### VoiceThread
- Analyze multimedia collaboration
- Support asynchronous discussion
- Track creative project-based learning

### Zoom
- Monitor synchronous session integration
- Track virtual class sessions
- Support hybrid/online course delivery

### Qwickly
- Track attendance tool usage
- Monitor engagement tool adoption
- Support classroom management

## Troubleshooting

### No Results
**Check**:
1. Tool name pattern matches content item naming
2. Term/date filter includes courses using the tool
3. Tool actually integrated in Blackboard (not external)
4. Students have actually used the tool (not just integrated)

### Fewer Courses Than Expected
**Possible Causes**:
- Some instructors use different naming for tool links
- Tool integrated but not yet used by students
- Tool usage before date range

**Solutions**:
- Add alternative name patterns
- Remove interaction count filters
- Expand date range

### Tool Name Variations
**Issue**: Tool may be named inconsistently
**Examples**:
- "YellowDig", "Yellowdig", "Yellow Dig", "YD Engage"
- "GoReact", "Go React", "GoReact Video"

**Solution**: Add all variations to WHERE clause with OR

## Vendor Reporting

This query is excellent for vendor reporting and ROI justification:

### Quarterly Report Template
```
Tool: [Tool Name]
Term: [Term]
Date Range: [Start] to [End]

Adoption Metrics:
- Courses Using Tool: [COUNT(DISTINCT course_id)]
- Instructors: [COUNT(DISTINCT instructors)]
- Departments: [COUNT(DISTINCT hierarchy_level_4)]
- Total Interactions: [SUM(tool_interaction_count)]
- Students Engaged: [SUM(students_interacted_count)]

Average per Course:
- Interactions: [AVG(tool_interaction_count)]
- Student Users: [AVG(students_interacted_count)]

Top 5 Courses by Engagement: [List]
```

## Related Queries

- **course-tool-interaction**: Shows ALL tools (not filtered to one)
- **filter-all-tool-interaction-by-college**: All tools filtered by college
- **specific-tool-adoption-and-usage**: System-wide tool statistics
- **filter-all-tool-interaction-by-college-department**: All tools by department

## Best Practices

1. **Customize for Your Tools**: Update tool name patterns to match your institution
2. **Track Over Time**: Run termly to show adoption trends
3. **Identify Champions**: Find high-usage instructors for peer mentoring
4. **Support Low Usage**: Proactively reach out to courses with low engagement
5. **Share Success**: Highlight effective implementations
6. **Connect Users**: Facilitate community of practice among tool users
7. **Validate Data**: Cross-check with vendor analytics
8. **Plan Training**: Use data to target professional development
9. **Budget Justification**: Document usage for renewal decisions
10. **Celebrate Milestones**: Recognize when adoption goals are met
