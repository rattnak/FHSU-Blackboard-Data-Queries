# Virtual Course Earliest Due Time

## Queries
- `by-term-query.sql`: Show earliest assignment due date for all virtual courses

## Overview

This query identifies the first (earliest) assignment due date for each virtual (online) course institution-wide. It helps assess virtual course readiness and initial content availability for online courses.

**Primary Use Cases:**
- Institution-wide virtual course readiness assessment
- Monitor online course preparation
- Identify virtual courses with early deadlines
- Support online learning quality initiatives
- Compare virtual course readiness across institution

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

Matches courses with naming patterns like:
- `2025S_ENGL101_V_01_Composition`
- `2024F_MATH210_V_A_Calculus`
- `HIST_V_101_World History`

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full course name (contains _V_ pattern) |
| `design_mode` | Course design mode (C/U/P) |
| `assignment_name` | Name of the earliest assignment |
| `due_time` | Due date/time of earliest assignment |
| `start_date` | Course start date |
| `term` | Term name |
| `instructor_count` | Number of instructors |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Technical Implementation

Uses window function to rank assignments by due time:
```sql
ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY due_time ASC) as rn
WHERE rn = 1  -- Only first assignment per course
```

Result: Exactly one row per virtual course (the earliest assignment).

## Performance Tips

**Estimated Execution Time:**
- Single term: 8-12 seconds
- Academic year: 20-30 seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for multiple terms

## Analysis Examples

### Virtual Courses Ready Before Start Date
```sql
WHERE due_time >= start_date
ORDER BY start_date ASC
```

### Virtual Courses with Early Deadlines (First Week)
```sql
WHERE due_time <= start_date + INTERVAL '7 DAYS'
ORDER BY due_time ASC
```

### Virtual Course Readiness by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(*) as virtual_courses_with_assignments,
    AVG(DATEDIFF('day', start_date, due_time)) as avg_days_to_first_due
GROUP BY college
ORDER BY college
```

### Identify Virtual Courses Not Ready
Virtual courses with earliest assignment due before course starts:
```sql
WHERE due_time < start_date
ORDER BY due_time ASC
```

## Online Course Quality Metrics

### Readiness Score
```sql
SELECT
    course_name,
    instructors,
    start_date,
    due_time,
    CASE
        WHEN due_time >= start_date + INTERVAL '7 DAYS' THEN 'Optimal'
        WHEN due_time >= start_date THEN 'Acceptable'
        ELSE 'Needs Review'
    END as readiness_status
```

### Days Until First Assignment
```sql
SELECT
    course_name,
    instructors,
    DATEDIFF('day', start_date, due_time) as days_to_first_assignment,
    CASE
        WHEN DATEDIFF('day', start_date, due_time) < 0 THEN 'Early Assignment'
        WHEN DATEDIFF('day', start_date, due_time) BETWEEN 0 AND 3 THEN 'Very Early'
        WHEN DATEDIFF('day', start_date, due_time) BETWEEN 4 AND 7 THEN 'Early'
        ELSE 'Paced'
    END as pacing
```

## Use Cases by Role

### Online Learning Office
- Monitor institution-wide virtual course readiness
- Identify courses needing development support
- Track online course quality metrics
- Plan proactive faculty support

### Academic Technology
- Support online course preparation
- Track virtual course content availability
- Plan targeted interventions
- Report on online learning readiness

### Academic Affairs
- Monitor online program quality
- Support online education initiatives
- Report to leadership on online readiness
- Ensure student success in online courses

### Instructional Design Team
- Prioritize virtual course support
- Identify courses needing urgent attention
- Track course development timelines
- Support quality online course design

## Troubleshooting

### Missing Virtual Courses
**Issue**: Known virtual courses don't appear
**Possible Causes**:
1. Course has no assignments with due dates
2. Virtual course naming doesn't match pattern
3. Course not in term filter

**Solution**: Run parent virtual course query without due time filter to see all

### Unexpected Early Dates
**Issue**: Assignment due before course start
**Possible Causes**:
- Backdated assignment for pacing purposes
- Error in course setup
- Rolled-over assignment with old date

### Different Virtual Course Naming
**Issue**: Your institution uses different pattern
**Solution**: Modify the WHERE clause:
```sql
WHERE course.course_name LIKE '%ONLINE%'
  OR course.course_name LIKE '%VIRTUAL%'
  OR course.course_name LIKE '%_O_%'
```

## Virtual Course Support Workflow

### 4 Weeks Before Term
1. Run query for upcoming term
2. Identify virtual courses without results (no assignments)
3. Contact instructors of courses without assignments

### 2 Weeks Before Term
1. Re-run query
2. Identify courses with very early deadlines (<3 days)
3. Verify content is ready
4. Offer last-minute support

### Week of Term Start
1. Final check
2. Address any urgent issues
3. Document courses launched successfully

## Related Queries

- **virtual-course-student-interaction**: Virtual course engagement metrics
- **virtual-course-total-interaction-per-student-per-course**: Virtual course interaction aggregates
- **filter-virtual-course-by-college**: Virtual courses filtered by college
- **course-earliest-due-time**: All courses (not just virtual) with earliest due times

## Best Practices

1. **Customize Virtual Pattern**: Match your institution's naming convention
2. **Run Proactively**: 3-4 weeks before term for intervention time
3. **Support Faculty**: Offer assistance to courses without assignments
4. **Track Trends**: Monitor virtual course readiness over time
5. **Quality Standards**: Establish expectations for first assignment timing
6. **Celebrate Success**: Recognize instructors with well-prepared courses
7. **Document Issues**: Track barriers to timely course preparation
8. **Share Best Practices**: Connect early-prep instructors with peers
