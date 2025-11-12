# Filter Each Course Due Time

## Queries
- `query.sql`: Template query to show all assignments for a specific course by name

## Overview

This is a single-course template query that retrieves all assignments with due dates for one specific course. It's designed to be customized with a course name to view the assignment timeline for that particular course.

**Primary Use Cases:**
- View complete assignment schedule for a single course
- Support individual instructor course reviews
- Troubleshoot specific course date issues
- Verify assignment timeline for student inquiries
- Template for course-specific reports

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `assignment_name` | Name of each assignment in the course |
| `due_time` | Due date/time for the assignment |
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

- **Single Course Filter**: Uses `course.course_name = '...'` for exact course matching
- **Chronological Order**: Results sorted by `due_time ASC` (earliest first)
- **All Assignments**: Shows complete assignment timeline for the course
- **Instructor Information**: Includes instructor details for context
- **Hierarchy Context**: Provides organizational placement information

## How to Use

### Customize for Your Course

Replace the course name in this line:
```sql
WHERE course.course_name = '2025S_HHP440_A_Anatomical Kinesiology'
```

The course name must match EXACTLY as it appears in Blackboard, including:
- Term prefix (e.g., "2025S_")
- Course code (e.g., "HHP440_A")
- Full course title

### Finding the Exact Course Name

If you don't know the exact course name format, first run:
```sql
SELECT course_name
FROM course
WHERE course_name LIKE '%HHP440%'  -- Use partial match to find
```

Then copy the exact `course_name` value into the template.

## Performance Tips

**Estimated Execution Time:**
- Single course: 1-3 seconds (very fast)

**Warehouse Sizing:**
- Small: More than sufficient

**Note**: This query is very lightweight since it filters to a single course.

## Analysis Examples

### Count Total Assignments
```sql
SELECT COUNT(*) as total_assignments
FROM ...
WHERE course.course_name = 'YourCourseName'
```

### Find Assignment Gaps
Look at intervals between `due_time` values to identify bunching or long gaps.

### Compare to Course Duration
```sql
SELECT
    MIN(due_time) as first_due,
    MAX(due_time) as last_due,
    start_date,
    term.end_date,
    DATEDIFF('day', start_date, MIN(due_time)) as days_until_first_assignment
```

## Troubleshooting

### No Results
**Check**:
1. Course name is exactly correct (including spaces, underscores, capitalization)
2. Course exists in the system
3. Course has assignments with due dates set
4. Instructor is assigned to the course
5. Course is linked to organizational hierarchy

### Finding Course Name Format

**Strategy 1 - Use LIKE with Partial Match**:
```sql
WHERE course.course_name LIKE '%HHP440%'
```

**Strategy 2 - Search by Instructor**:
```sql
WHERE instructors LIKE '%LastName%'
```

**Strategy 3 - Search by Term and Department**:
```sql
WHERE term.name = 'S2025'
  AND institutional_hierarchy_level_4 = 'Department Name'
```

### Special Characters in Course Names
**Issue**: Course name contains quotes or special characters
**Solution**: Escape special characters properly:
```sql
WHERE course.course_name = 'Course with ''single quote'''
-- or
WHERE course.course_name = 'Course with "quotes"'
```

## Converting to Bulk Query

To analyze multiple courses at once, modify the WHERE clause:

**Multiple Specific Courses**:
```sql
WHERE course.course_name IN (
    'Course Name 1',
    'Course Name 2',
    'Course Name 3'
)
```

**All Courses by Pattern**:
```sql
WHERE course.course_name LIKE '2025S_HHP%'  -- All HHP courses in Spring 2025
```

**All Courses by Instructor**:
```sql
WHERE instructors LIKE '%Instructor Name%'
```

## Use Cases by Role

### Faculty/Instructors
- Review their own course assignment schedule
- Verify due dates before term starts
- Plan assignment distribution adjustments

### Academic Advisors
- Help students plan workload for specific course
- Verify assignment timeline when students ask
- Support course selection advising

### Instructional Designers
- Review course design with instructor
- Support course development timeline
- Verify alignment with course schedule

### Student Support Services
- Respond to student questions about deadlines
- Verify assignment information for accommodations
- Support academic success interventions

## Related Queries

- **course-due-time**: Shows assignments for ALL courses (not filtered to one)
- **course-earliest-due-time**: Shows only the first assignment per course
- **course-overdue-time**: Shows overdue assignments across courses

## Tips for Regular Use

1. **Save Common Searches**: Create copies with frequently-requested course names
2. **Bookmark Template**: Keep the base query handy for quick customization
3. **Document Format**: Keep a reference of your institution's course naming convention
4. **Combine with Excel**: Export and use for course timeline visualizations
5. **Share with Instructors**: Provide as self-service tool for faculty to check their courses
