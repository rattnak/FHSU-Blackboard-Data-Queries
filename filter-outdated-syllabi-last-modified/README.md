# Filter Outdated Syllabi by Last Modified Date

## Queries
- `by-term-query.sql`: Show ONLY syllabi not modified in past year for a specific term
- `between-date-query.sql`: Show ONLY syllabi not modified in past year for courses between specific dates
- `hans-by-term-query.sql`: Alternative variant (possibly customized for specific user)
- `hans-between-date-query.sql`: Alternative variant (possibly customized for specific user)

## Overview

This query filters to show ONLY courses with outdated syllabi, where "outdated" means the syllabus has NOT been modified in the past 1 year (absolute time measurement). This is a filtered subset of the `course-syllabi-last-modified` query.

**Primary Use Cases:**
- Generate action lists for stale content
- Prioritize syllabus refresh projects
- Create instructor outreach campaigns
- Target course quality interventions
- Support pre-term course preparation

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the outdated syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified (>1 year ago) |
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
- **"Outdated" Definition**: `modified_time < CURRENT_DATE - INTERVAL '1 YEAR'`
- **Absolute Age**: Measures time since last modification (not relative to creation)
- **Action-Oriented**: Results are courses needing immediate attention
- **Contact Information**: Includes instructor emails for outreach

## "Outdated" Classification

A syllabus is flagged as "Outdated" if:
```sql
ci.modified_time < CURRENT_DATE - INTERVAL '1 YEAR'
```

This means the syllabus has NOT been modified in the past year (measured from today).

**Important Difference**:
- This query uses **absolute age** (time since last modification)
- `filter-outdated-syllabi-age` uses **relative age** (creation to modification interval)

## How to Use

### By-Term Query
Focus on specific term:
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
Focus on date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Adjust Outdated Threshold

To change the 1-year threshold:
```sql
-- 6 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '6 MONTHS'

-- 18 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '18 MONTHS'

-- 90 days
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '90 DAYS'
```

### "Hans" Variants

The `hans-*` query files may contain customizations such as:
- Different outdated thresholds
- Additional filters or exclusions
- Modified output columns
- Specific reporting formats

Check these files for variations that might better suit specific needs.

