# Course Earliest Due Time Query

## Queries
- `by-term-query.sql`: Find the earliest assignment due date per course for a specific term
- `between-date-query.sql`: Find the earliest assignment due date per course between specific dates

## Overview

This query identifies the FIRST (earliest) assignment due date for each course. It uses window functions to rank assignments by due time and returns only the earliest one per course. This is particularly useful for assessing course readiness and initial content availability.

**Primary Use Cases:**
- Assess course readiness before term starts
- Identify courses with early deadlines
- Compare first assignment timing across departments
- Monitor course setup completion
- Support student onboarding planning

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `assignment_name` | Name of the earliest assignment |
| `due_time` | Due date/time of the earliest assignment |
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

- **Window Function**: Uses `ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC)` to rank assignments
- **Single Result Per Course**: Returns only the assignment with rank = 1 (earliest)
- **Chronological Order**: Results sorted by `due_time ASC`
- **Instructor Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from organizational hierarchy

## Technical Implementation

The query uses a Common Table Expression (CTE) with window function:

```sql
WITH ranked_assignments AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC) as rn
  FROM ...
)
SELECT * FROM ranked_assignments WHERE rn = 1
```

This ensures exactly one row per course (the earliest assignment).

## How to Use

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
- Single term: 10-18 seconds
- Full academic year: 30-50 seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for academic year
- Large: For multi-year analysis

**Optimization Notes:**
- Window functions can be resource-intensive
- Always include term/date filters
- Add college filters for faster subset analysis

## Analysis Examples

### Identify Courses Starting Before Course Start Date
Find courses where first assignment is due before the official start date:
```sql
WHERE due_time < start_date
```

### Find Courses with Early Deadlines (First Week)
```sql
WHERE due_time <= start_date + INTERVAL '7 DAYS'
```

### Compare First Assignment Timing Across Colleges
```sql
GROUP BY institutional_hierarchy_level_3
ORDER BY AVG(DATEDIFF('day', start_date, due_time))
```

## Troubleshooting

### No Results for a Course
**Possible Causes**:
1. Course has no assignments with due dates
2. All assignments have null `due_time`
3. Course filtered out by term/date range
4. Course has no instructors assigned

### Unexpected "Earliest" Assignment
**Issue**: The returned assignment doesn't seem like the first one
**Check**:
- Verify `due_time` values in the course (may have backdated items)
- Check for unpublished/draft assignments with early dates
- Confirm timezone settings if times seem off

### Multiple Results for Same Course
**Issue**: Same course appears more than once
**Cause**: Should not happen with `rn = 1` filter
**Check**:
- Query may have been modified
- Course might be assigned to multiple hierarchies (rare)
- Verify the `PARTITION BY course_id` clause is intact

### Missing Active Courses
**Issue**: Active courses don't appear in results
**Cause**: Courses have no assignments with due dates set
**Solution**: This is expected behavior - only courses with at least one assignment with a due date will appear

## Related Queries

- **course-due-time**: Shows ALL assignments with due dates (not just earliest)
- **course-overdue-time**: Shows overdue assignments
- **filter-virtual-course-earliest-due-time-by-college**: Same query filtered for virtual courses
- **filter-each-course-due-time**: Shows all assignments for a single specific course

## Use Cases by Role

### Academic Affairs
- Monitor course readiness across institution
- Identify courses not ready at term start
- Compare timing patterns across colleges

### Department Chairs
- Review first assignment dates in department
- Ensure course content is available early
- Support faculty with course setup

### Instructional Designers
- Identify courses needing setup assistance
- Track course design completion
- Support just-in-time course development
