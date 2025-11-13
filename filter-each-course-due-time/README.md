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

