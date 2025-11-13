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

