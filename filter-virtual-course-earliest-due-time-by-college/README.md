# Filter Virtual Course Earliest Due Time by College

## Queries
- `by-term-query.sql`: Show earliest assignment due date for virtual courses in a specific college

## Overview

This query combines virtual course detection with earliest due time analysis, filtered to a specific college. It identifies the first assignment due date for each virtual (online) course within the specified college.

**Primary Use Cases:**
- Assess virtual course readiness at college level
- Monitor online course preparation
- Identify virtual courses with early deadlines
- Support college-level online course quality
- Compare virtual course readiness across colleges

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

Matches courses like:
- `2025S_ENGL101_V_01_Composition`
- `2024F_MATH210_V_A_Calculus`

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full course name (contains _V_ pattern) |
| `design_mode` | Course design mode |
| `assignment_name` | Name of the earliest assignment |
| `due_time` | Due date/time of earliest assignment |
| `start_date` | Course start date |
| `term` | Term name |
| `instructor_count` | Number of instructors |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level (filtered value) |
| `institutional_hierarchy_level_4` | Department Level |

## How to Change the College Filter

Modify this line:
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
```

## Technical Implementation

Uses window function to identify earliest assignment:
```sql
ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC) as rn
WHERE rn = 1  -- Only earliest assignment per course
```

## Performance Tips

**Estimated Execution Time:**
- Single college, single term: 5-8 seconds

**Warehouse Sizing:**
- Small: Sufficient

## Analysis Examples

### Virtual Courses Ready Before Term Start
```sql
WHERE due_time >= start_date
ORDER BY due_time ASC
```

### Virtual Courses Not Ready (No Assignments)
```sql
-- Run parent query to see all virtual courses
-- Compare to this query results to find missing courses
```

### Average Days Between Start and First Assignment
```sql
SELECT
    AVG(DATEDIFF('day', start_date, due_time)) as avg_days_to_first_assignment
```

## Use Cases by Role

### College Deans
- Monitor virtual course readiness
- Ensure quality online student experience
- Support faculty with online course development

### Online Learning Office
- Track virtual course preparation
- Identify courses needing support
- Plan proactive outreach to instructors

### Instructional Designers
- Prioritize support for college virtual courses
- Identify courses needing content development
- Support timely course readiness

## Related Queries

- **filter-virtual-course-by-college**: All virtual courses in college (no due time filter)
- **virtual-course-earliest-due-time**: Virtual courses institution-wide with earliest due times
- **course-earliest-due-time**: All courses (not just virtual) with earliest due times

## Best Practices

1. **Run 2-3 Weeks Before Term**: Identify courses needing support
2. **Follow Up on Missing Courses**: Compare to all virtual courses to find those without assignments
3. **Support Early Deadline Courses**: Ensure content is ready if due date is early
4. **Track College Trends**: Monitor if college virtual courses are consistently ready
