# Filter Virtual Courses by College

## Queries
- `by-term-query.sql`: Show virtual courses in a specific college for a term

## Overview

This query identifies virtual courses (online courses) within a specific college. Virtual courses are detected by a naming pattern (underscore-V-underscore in the course name) and filtered to Ultra courses only.

**Primary Use Cases:**
- Track online course offerings by college
- Monitor virtual course adoption in specific colleges
- Support online learning initiatives at college level
- Compare online offerings across colleges
- Plan college-specific online course support

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

Matches courses with naming patterns like:
- `2025S_ENGL101_V_01_Composition`
- `2024F_MATH210_V_A_Calculus`
- `HIST_V_101_World History`

**Additional Filter**: `design_mode IN ('U', 'P')` (Ultra courses only)

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full course name (contains _V_ pattern) |
| `design_mode` | Course design mode (U or P only) |
| `start_date` | Course start date |
| `term` | Term name |
| `instructor_count` | Number of instructors assigned |
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

Replace with your desired college name (exact match required).

## How to Use

### By-Term Query
```sql
WHERE term.name = 'S2025'
```

### Adjust Virtual Course Pattern

If your institution uses different naming:
```sql
-- Match different patterns
WHERE course.course_name LIKE '%VIRTUAL%'
WHERE course.course_name LIKE '%ONLINE%'
WHERE course.course_name LIKE '%_O_%'  -- O for Online
```

### Include Classic Courses

To include Classic virtual courses:
```sql
AND design_mode IN ('U', 'P', 'C')  -- Add 'C' for Classic
```

