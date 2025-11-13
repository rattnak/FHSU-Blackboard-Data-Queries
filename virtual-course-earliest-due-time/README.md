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

