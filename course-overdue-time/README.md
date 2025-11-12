# Course Overdue Time Query

## Queries
- `by-term-query.sql`: Find overdue assignments for a specific term
- `between-date-query.sql`: Find overdue assignments for courses between specific dates

## Overview

This query identifies assignments that are overdue (past their due date) for currently active courses. It filters for assignments due more than 21 days ago in courses where the term has not yet ended.

**Primary Use Cases:**
- Identify outdated course content needing updates
- Find assignments with past due dates in active courses
- Support course maintenance and cleanup
- Assess course content currency
- Audit course materials before term rollover

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `assignment_name` | Name of the overdue assignment |
| `due_time` | Original due date/time (in the past) |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `term_end_date` | Term end date |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Overdue Filter**: `due_time < CURRENT_DATE - INTERVAL '21 DAYS'`
  - Assignments must be at least 21 days past due
- **Active Courses Only**: `term.end_date >= CURRENT_DATE`
  - Only includes courses in active/current terms
- **Chronological Order**: Results sorted by `due_time ASC` (oldest first)
- **Instructor Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from organizational hierarchy

## Overdue Logic

An assignment is considered "overdue" if:
1. `due_time < CURRENT_DATE - INTERVAL '21 DAYS'` (due date was >21 days ago)
2. `term.end_date >= CURRENT_DATE` (course term is still active)

This prevents flagging old assignments in completed terms while identifying stale content in current courses.

## How to Use

### Adjust Overdue Threshold

To change the 21-day threshold, modify this line:
```sql
AND ci.due_time < CURRENT_DATE - INTERVAL '21 DAYS'
```

Examples:
- 7 days: `INTERVAL '7 DAYS'`
- 30 days: `INTERVAL '30 DAYS'`
- 60 days: `INTERVAL '60 DAYS'`

### By-Term Query
Filter by specific term:
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
Filter by course start date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

## Performance Tips

**Estimated Execution Time:**
- Single term: 8-12 seconds
- Full academic year: 20-35 seconds

**Warehouse Sizing:**
- Small: Sufficient for most queries
- Medium: Recommended for multiple terms

**Optimization Recommendations:**
- Always include term filter for better performance
- Add college/department filters for focused analysis
- Results typically smaller than other due-time queries

## Analysis Examples

### Group Overdue Items by Course
```sql
SELECT course_name, COUNT(*) as overdue_count
GROUP BY course_name
ORDER BY overdue_count DESC
```

### Find Instructors with Most Overdue Content
```sql
SELECT instructors, COUNT(*) as overdue_items
GROUP BY instructors
ORDER BY overdue_items DESC
```

### Identify Oldest Overdue Assignments
Already sorted by `due_time ASC`, so first results are oldest.

## Troubleshooting

### No Results
**Possible Reasons**:
1. All courses are current with no old due dates
2. Term filter excludes active courses
3. No assignments are >21 days overdue in active terms
4. All courses with old dates are in completed terms

**This is often GOOD news** - means courses are well-maintained!

### Too Many Results
**Issue**: Overwhelming number of overdue assignments
**Solutions**:
1. Increase the interval threshold (e.g., 30 or 60 days)
2. Filter by specific college/department
3. Group results by instructor for summary view
4. Export for bulk course cleanup project

### False Positives: Self-Paced Courses
**Issue**: Self-paced courses flagged as having overdue content
**Cause**: Some courses intentionally have past dates for pacing
**Solution**:
- Add exclusion filter for self-paced course naming patterns
- Filter out specific terms/course types
- Work with instructors to identify intentional vs. outdated dates

### Results Include Completed Courses
**Issue**: Courses that ended show as having overdue content
**Check**: Verify `term.end_date >= CURRENT_DATE` filter is in place
**Cause**: Term end dates may not be properly set in system

## Use Cases by Role

### Instructional Designers
- Identify courses needing content refresh
- Support instructors with course cleanup
- Prioritize course maintenance projects

### Department Chairs
- Monitor course content currency in department
- Identify instructors needing support
- Plan professional development on course maintenance

### Academic Technology Staff
- Generate cleanup reports before new terms
- Support term rollover activities
- Identify courses for archiving or inactivation

### Quality Assurance
- Audit course content quality
- Track course maintenance metrics
- Support accreditation documentation

## Related Queries

- **course-due-time**: Shows ALL assignments with due dates
- **course-earliest-due-time**: Shows first assignment per course
- **filter-each-course-due-time**: All assignments for a specific course

## Best Practices

1. **Run Before Term Starts**: Generate reports 2-4 weeks before term begins
2. **Share with Instructors**: Provide lists to help them update courses
3. **Adjust Threshold**: 21 days works for most; adjust based on institution needs
4. **Consider Course Types**: Some courses (archives, templates) may intentionally have old dates
5. **Regular Monitoring**: Schedule quarterly reviews to maintain course quality
