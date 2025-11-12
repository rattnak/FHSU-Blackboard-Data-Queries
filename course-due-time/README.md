# Course Due Time Query

## Queries
- `by-term-query.sql`: List all assignments with due dates for a specific term
- `between-date-query.sql`: List all assignments with due dates between specific dates

## Overview

This query retrieves all assignments in courses along with their due dates, ordered chronologically. It provides a comprehensive view of assignment deadlines across courses, instructors, and organizational units.

**Primary Use Cases:**
- Track upcoming assignment deadlines across courses
- Analyze assignment distribution patterns over time
- Identify peak assessment periods
- Support academic planning and workload management
- Monitor course readiness and content scheduling

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `assignment_name` | Name/title of the assignment |
| `due_time` | Date and time when the assignment is due |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Assignment Focus**: Shows all assignments with due dates (items with `due_time IS NOT NULL`)
- **Chronological Order**: Results sorted by `due_time ASC` (earliest first)
- **Instructor Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Term/Date Filtering**: Query variants for term-based or date-range filtering

## How to Use

### By-Term Query
Filter by specific term (e.g., "S2025"):
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
Filter by start date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

## Performance Tips

**Estimated Execution Time:**
- Single term: 8-15 seconds
- Full academic year: 25-40 seconds
- Multiple years: 60+ seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for academic year
- Large: For multi-year analysis

**Optimization Recommendations:**
- Always include term or date range filters
- Add college/department filters for focused analysis
- Consider limiting to specific due date ranges for large datasets

## Analysis Examples

### Find Assignment Deadlines in Next 30 Days
```sql
WHERE due_time BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 DAYS'
```

### Identify Courses with Weekend Deadlines
```sql
WHERE DAYOFWEEK(due_time) IN (1, 7)  -- Sunday = 1, Saturday = 7
```

### Find Assignment Density by Week
Group by week to identify heavy assessment periods:
```sql
GROUP BY DATE_TRUNC('week', due_time)
```

## Troubleshooting

### No Results
**Check**:
1. Term name matches exactly (`term.name = 'S2025'`)
2. Date range is valid and includes course start dates
3. Courses have assignments with due dates set
4. Content items have `due_time` populated

### Unexpected Assignment Counts
**Issue**: More or fewer assignments than expected
**Possible Causes**:
- Includes ALL content types with due dates (assignments, quizzes, discussions, etc.)
- May include draft/unpublished items
- Hidden items are still counted

**Solution**: Add filters for specific content types or availability status if needed

### Duplicate Assignments
**Issue**: Same assignment appears multiple times
**Cause**: Course assigned to multiple hierarchies
**Solution**: Add `DISTINCT` or filter to primary hierarchy

### Missing Assignments
**Issue**: Known assignments don't appear
**Check**:
- Assignment has `due_time` set (not null)
- Assignment is within the term/date filter range
- Course is properly mapped to organizational hierarchy
- Instructor is assigned with role 'I'

## Related Queries

- **course-earliest-due-time**: Shows only the FIRST assignment per course
- **course-overdue-time**: Filters to overdue assignments only
- **filter-each-course-due-time**: Template for single course analysis
