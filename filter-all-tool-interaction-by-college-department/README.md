# Filter All Tool Interaction by College and Department

## Queries
- `by-term-query.sql`: Tool interaction filtered to specific college AND department for a term
- `between-date-query.sql`: Tool interaction filtered to specific college AND department between dates

## Overview

This query provides tool interaction metrics filtered to a specific college AND department (e.g., College of Education, Teacher Education). It tracks 8 educational technology tools but limits results to courses within one specific department.

**Primary Use Cases:**
- Department-level technology adoption analysis
- Department chair reporting and planning
- Granular tool usage tracking
- Department-specific support planning
- Faculty recognition within departments

## Tracked Tools
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## How to Change Filters

Modify both college AND department filters:
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 5) = 'Teacher Education'
```

Both must match EXACTLY (case-sensitive).

### Finding Department Names

If unsure of exact department names, first run:
```sql
SELECT DISTINCT
    SPLIT_PART(ih.hierarchy_name_seq, '||', 4) as college,
    SPLIT_PART(ih.hierarchy_name_seq, '||', 5) as department
FROM ...
WHERE SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'Your College Name'
ORDER BY department
```

