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

