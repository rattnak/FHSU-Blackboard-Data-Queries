# Course Syllabi Age Query

## Queries
- `by-term-query.sql`: Analyze syllabus age for courses in a specific term
- `between-date-query.sql`: Analyze syllabus age for courses between specific dates

## Overview

This query identifies courses containing syllabus content items and classifies them as "Current" or "Outdated" based on when the syllabus was last modified relative to its creation date. A syllabus is considered "Outdated" if it was modified more than 1 year after its creation date.

**Primary Use Cases:**
- Audit syllabus currency and maintenance
- Identify courses with outdated syllabus documents
- Track syllabus update patterns
- Support course quality assurance initiatives
- Monitor compliance with syllabus requirements

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified |
| `status` | 'Current' or 'Outdated' classification |
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

- **Syllabus Detection**: Searches for content items with 'syllabus' in the name (case-insensitive)
- **Age Classification Logic**:
  - **Outdated**: `modified_time > created_time + INTERVAL '1 YEAR'`
  - **Current**: Modified within 1 year of creation
- **Creation & Modification Tracking**: Shows both timestamps for analysis
- **All Syllabi Included**: Shows both current and outdated (not filtered)

## Classification Logic

```sql
CASE
    WHEN ci.modified_time > ci.created_time + INTERVAL '1 YEAR'
    THEN 'Outdated'
    ELSE 'Current'
END AS status
```

**"Outdated" means**: The syllabus was last modified MORE than 1 year after it was created.

**Important Note**: This measures time between creation and last modification, not absolute age. A syllabus created 5 years ago but updated recently may still show as "Current" depending on when the last update occurred relative to creation.

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

### Finding Syllabus Items
The query searches for items where:
```sql
LOWER(ci.name) LIKE '%syllabus%'
```

Common matches: "Syllabus", "Course Syllabus", "SYLLABUS.pdf", "Syllabus_Fall2024", etc.

