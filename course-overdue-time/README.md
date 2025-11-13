# Course Overdue Time Query

## Queries
- `by-term-query.sql`: Find overdue assignments for a specific term
- `between-date-query.sql`: Find overdue assignments for courses between specific dates

## Overview

This query identifies assignments that are overdue (past their due date) for currently active courses. It filters for assignments due more than 21 days ago in courses where the term has not yet ended.

**Primary Use Cases:**
- Identify outdated course content needing updates
- Find assignments with past due dates in active courses
- Support course maintenance and cleanup
- Assess course content currency
- Audit course materials before term rollover

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `assignment_name` | Name of the overdue assignment |
| `due_time` | Original due date/time (in the past) |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `term_end_date` | Term end date |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Overdue Filter**: `due_time < CURRENT_DATE - INTERVAL '21 DAYS'`
  - Assignments must be at least 21 days past due
- **Active Courses Only**: `term.end_date >= CURRENT_DATE`
  - Only includes courses in active/current terms
- **Chronological Order**: Results sorted by `due_time ASC` (oldest first)
- **Instructor Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from organizational hierarchy

## Overdue Logic

An assignment is considered "overdue" if:
1. `due_time < CURRENT_DATE - INTERVAL '21 DAYS'` (due date was >21 days ago)
2. `term.end_date >= CURRENT_DATE` (course term is still active)

This prevents flagging old assignments in completed terms while identifying stale content in current courses.

## How to Use

### Adjust Overdue Threshold

To change the 21-day threshold, modify this line:
```sql
AND ci.due_time < CURRENT_DATE - INTERVAL '21 DAYS'
```

Examples:
- 7 days: `INTERVAL '7 DAYS'`
- 30 days: `INTERVAL '30 DAYS'`
- 60 days: `INTERVAL '60 DAYS'`

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

