# Filter Courses by College and Department

## Queries
- `by-term-query.sql`: Filter courses by college and department for a specific term
- `between-date-query.sql`: Filter courses by college and department between specific dates

## Overview

This query retrieves all courses offered in a specific college AND department (e.g., College of Education, Teacher Education) for a given term or date range. This provides more granular filtering than college-only queries.

**Primary Use Cases:**
- Generate department-specific course rosters
- Analyze course offerings within a particular department
- Create department-level instructor assignment reports
- Support department chair reviews and planning
- Track course distribution for program accreditation

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level (filtered value) |

## Key Features

- **Dual Filter**: Uses both college and department hierarchy levels
  - College: `SPLIT_PART(ih.hierarchy_name_seq, '||', 4)`
  - Department: `SPLIT_PART(ih.hierarchy_name_seq, '||', 5)`
- **Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Sorting**: Results ordered by start date and course name

## How to Use

### Modify the College and Department Filters

To change the college and department being filtered, update these lines in the query:

```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 5) = 'Teacher Education'
```

Replace with your desired college and department names (must match exactly).

### Example Combinations
- College of Education / Teacher Education
- College of Arts, Humanities & Social Sciences / History
- College of Business and Entrepreneurship / Management
- College of Health and Life Sciences / Nursing

