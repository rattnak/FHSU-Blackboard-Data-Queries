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

