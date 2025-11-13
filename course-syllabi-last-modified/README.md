# Course Syllabi Last Modified Query

## Queries
- `by-term-query.sql`: Analyze when syllabi were last modified for courses in a specific term
- `between-date-query.sql`: Analyze when syllabi were last modified for courses between specific dates

## Overview

This query identifies courses containing syllabus content items and classifies them as "Current" or "Outdated" based on when the syllabus was last modified. A syllabus is considered "Outdated" if it has NOT been modified in the past 1 year (absolute time measurement).

**Primary Use Cases:**
- Audit syllabus currency and maintenance
- Identify courses with stale syllabus documents
- Track syllabus update frequency
- Support course quality assurance initiatives
- Monitor compliance with syllabus policies

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
- **Absolute Age Classification**:
  - **Outdated**: `modified_time < CURRENT_DATE - INTERVAL '1 YEAR'`
  - **Current**: Modified within the past 1 year
- **Creation & Modification Tracking**: Shows both timestamps for analysis
- **All Syllabi Included**: Shows both current and outdated (not filtered)

## Classification Logic

```sql
CASE
    WHEN ci.modified_time < CURRENT_DATE - INTERVAL '1 YEAR'
    THEN 'Outdated'
    ELSE 'Current'
END AS status
```

**"Outdated" means**: The syllabus has NOT been modified in the past year (measured from current date).

**Important Difference from "syllabi-age"**:
- This query measures absolute time since last modification
- The "syllabi-age" query measures time between creation and last modification

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

### Adjust Outdated Threshold

To change the 1-year threshold:
```sql
-- 6 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '6 MONTHS'

-- 2 years
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '2 YEARS'

-- 180 days
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '180 DAYS'
```

