# Filter Outdated Syllabi by Age

## Queries
- `by-term-query.sql`: Show ONLY outdated syllabi for courses in a specific term
- `between-date-query.sql`: Show ONLY outdated syllabi for courses between specific dates

## Overview

This query filters to show ONLY courses with outdated syllabus content, where "outdated" means the syllabus was last modified more than 1 year after its creation date. This is a filtered subset of the `course-syllabi-age` query.

**Primary Use Cases:**
- Generate action lists for course maintenance
- Prioritize syllabus update projects
- Create instructor outreach lists
- Target interventions for course quality
- Support pre-term course readiness

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the outdated syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified |
| `status` | Always 'Outdated' (filtered to this value only) |
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

- **Filtered Results**: Shows ONLY outdated syllabi (status = 'Outdated')
- **"Outdated" Definition**: `modified_time > created_time + INTERVAL '1 YEAR'`
- **Syllabus Detection**: Searches for content items with 'syllabus' in name (case-insensitive)
- **Action-Oriented**: Results are courses that need attention
- **Contact Information**: Includes instructor emails for outreach

## "Outdated" Classification

A syllabus is flagged as "Outdated" if:
```sql
ci.modified_time > ci.created_time + INTERVAL '1 YEAR'
```

This means the time between creation and last modification is MORE than 1 year.

**Important**: This measures relative age (creation to modification interval), not absolute age. See `filter-outdated-syllabi-last-modified` for absolute age filtering.

## How to Use

### By-Term Query
Focus on specific term:
```sql
WHERE term.name = 'S2025'
```

**Best Practice**: Run 2-4 weeks before term starts to give instructors time to update.

### Between-Date Query
Focus on date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Generate Instructor Contact List
Export the results and use the `instructor_emails` column to:
- Send reminder emails
- Create support tickets
- Schedule training sessions
- Assign to instructional design team

