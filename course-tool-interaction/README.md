# Course Tool Interaction Query

## Queries
- `by-term-query.sql`: Analyze tool interactions for courses in a specific term
- `between-date-query.sql`: Analyze tool interactions for courses between specific dates

## Overview

This comprehensive query tracks student engagement with specific educational technology tools integrated into Blackboard courses. It provides interaction counts, student engagement metrics, and last access times for multiple tools.

**Primary Use Cases:**
- Monitor adoption of educational technology tools
- Analyze student engagement with specific tools
- Compare tool usage across courses and departments
- Support tool effectiveness research
- Guide instructional technology investments

## Tracked Tools

The query monitors these educational technology tools:
- **YellowDig Engage** - Social learning platform
- **Packback** - AI-powered discussion platform
- **Feedback** - Assessment and feedback tool
- **Inscribe** - Digital annotation tool
- **GoReact** - Video assessment platform
- **Qwickly** - Attendance and engagement suite
- **VoiceThread** - Collaborative multimedia tool
- **Zoom** - Video conferencing integration

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
| `tool_name` | Name of the educational technology tool |
| `tool_interaction_count` | Total number of interactions with the tool |
| `students_interacted_count` | Number of unique students who used the tool |
| `last_interaction_time` | Most recent interaction timestamp |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Multi-Tool Tracking**: Monitors 8 different educational technology tools
- **Engagement Metrics**: Counts both total interactions and unique student users
- **Recency Tracking**: Records last interaction time for activity monitoring
- **Course Context**: Includes instructor and organizational hierarchy information
- **Flexible Filtering**: Query variants for term or date range analysis

## Technical Implementation

The query uses a multi-step CTE (Common Table Expression) structure:

1. **Tool Filter CTE**: Identifies content items matching tool name patterns
2. **Interaction Aggregation**: Counts user interactions and unique students
3. **Course Join**: Combines with course, term, and hierarchy information
4. **Instructor Aggregation**: Consolidates multiple instructors per course

## How to Use

### By-Term Query
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Add Additional Tools

To track additional tools, add to the WHERE clause:
```sql
WHERE (LOWER(ci.name) LIKE '%yellowdig%'
    OR LOWER(ci.name) LIKE '%packback%'
    OR LOWER(ci.name) LIKE '%feedback%'
    OR LOWER(ci.name) LIKE '%inscribe%'
    OR LOWER(ci.name) LIKE '%goreact%'
    OR LOWER(ci.name) LIKE '%qwickly%'
    OR LOWER(ci.name) LIKE '%voicethread%'
    OR LOWER(ci.name) LIKE '%zoom%'
    OR LOWER(ci.name) LIKE '%newtool%')  -- Add new tool here
```

## Performance Tips

**Estimated Execution Time:**
- Single term: 15-25 seconds
- Full academic year: 40-60 seconds
- Multi-year: 90+ seconds

**Warehouse Sizing:**
- Medium: Recommended minimum
- Large: Optimal for multi-term analysis

**Why Slower?**
- Joins interaction logs (large tables)
- Aggregates across multiple tools
- Counts unique students per tool

**Optimization**:
- Always include term or date filter
- Add college/department filters when possible
- Consider running for specific tools only

## Analysis Examples

### Most Used Tools by Interaction Count
```sql
SELECT
    tool_name,
    SUM(tool_interaction_count) as total_interactions,
    COUNT(DISTINCT course_id) as courses_using
GROUP BY tool_name
ORDER BY total_interactions DESC
```

### Average Engagement per Course
```sql
SELECT
    tool_name,
    AVG(students_interacted_count) as avg_students,
    AVG(tool_interaction_count) as avg_interactions
GROUP BY tool_name
```

### Tool Adoption by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    tool_name,
    COUNT(DISTINCT course_id) as course_count
GROUP BY college, tool_name
ORDER BY college, course_count DESC
```

### Find Inactive Tool Integrations
```sql
WHERE last_interaction_time < CURRENT_DATE - INTERVAL '30 DAYS'
  OR tool_interaction_count = 0
```

### High-Engagement Courses
```sql
WHERE students_interacted_count > 20
ORDER BY tool_interaction_count DESC
```

## Troubleshooting

### No Results
**Possible Causes**:
1. No tools integrated in filtered courses
2. Tool naming in content items doesn't match patterns
3. Tools integrated but no student interactions yet
4. Term/date filter excludes all courses with tools

**Solutions**:
- Verify tool integration by checking Blackboard directly
- Review tool naming conventions (may need to adjust LIKE patterns)
- Remove interaction count filters to see inactive integrations

### Missing Tools
**Issue**: Known tool usage not appearing
**Causes**:
- Content item name doesn't match pattern (e.g., "YD Engage" vs "YellowDig")
- Tool integrated differently (not as content item)
- Tool integrated after query date range

**Solutions**:
- Add alternative name patterns to WHERE clause
- Check with EdTech team on integration methods
- Expand date range

### Duplicate Courses
**Issue**: Same course appears multiple times
**Causes**:
- Course uses multiple tools (expected - one row per tool per course)
- Course assigned to multiple hierarchies

**Solutions**:
- This is expected behavior - each tool per course gets a row
- For unique course count, use `COUNT(DISTINCT course_id)`

### Unexpectedly High Interaction Counts
**Issue**: Interaction counts seem inflated
**Causes**:
- Tool logs every click/action (not just meaningful interactions)
- Auto-generated interactions (notifications, syncs)
- Multiple semesters of data if course reused

**Solution**: Compare to tool's native analytics for validation

## Use Cases by Role

### Educational Technology Team
- Monitor tool adoption and usage
- Demonstrate ROI on tool investments
- Identify tools needing promotion or support
- Plan future tool integrations

### Instructional Designers
- Identify successful tool implementations
- Connect instructors using similar tools
- Share best practices for tool integration
- Support instructors in tool adoption

### Academic Affairs
- Track innovation in teaching
- Support strategic technology planning
- Demonstrate student engagement initiatives
- Report on teaching technology to leadership

### Faculty Development
- Identify tool champions for peer training
- Target workshops based on tool interest
- Share exemplar courses using tools
- Plan technology professional development

### Institutional Research
- Correlate tool usage with student outcomes
- Compare engagement across demographics
- Analyze longitudinal adoption trends
- Support research on teaching effectiveness

## Related Queries

- **filter-specific-tool-interaction**: Focus on single tool (e.g., only YellowDig)
- **filter-all-tool-interaction-by-college**: Tool usage filtered by college
- **filter-all-tool-interaction-by-college-department**: Tool usage filtered by department
- **specific-tool-adoption-and-usage**: System-wide tool adoption statistics

## Best Practices

1. **Establish Baselines**: Run regularly to track adoption over time
2. **Share Success Stories**: Highlight high-engagement courses
3. **Support Early Adopters**: Provide resources to instructors trying tools
4. **Compare Tool Effectiveness**: Analyze which tools drive most engagement
5. **Integrate with Outcomes**: Combine with grade/retention data when possible
6. **Respect Privacy**: Aggregate data appropriately for reporting
7. **Validate with Vendors**: Cross-check with tool vendors' analytics
8. **Plan Professional Development**: Use data to target training
9. **Budget Justification**: Use adoption data to support tool renewals
10. **Celebrate Innovation**: Recognize instructors effectively using tools
