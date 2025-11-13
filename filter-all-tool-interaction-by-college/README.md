# Filter All Tool Interaction by College

## Queries
- `by-term-query.sql`: Tool interaction data filtered to a specific college for a term
- `between-date-query.sql`: Tool interaction data filtered to a specific college between dates

## Overview

This query provides tool interaction metrics filtered to a specific college (e.g., College of Education). It tracks the same 8 educational technology tools as the parent query but limits results to courses within one college.

**Primary Use Cases:**
- College-level technology adoption analysis
- Department chair tool usage reporting
- College-specific tool support planning
- College EdTech budget justification
- Comparative analysis across colleges

## Tracked Tools
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## Output Columns

Same as `course-tool-interaction` query, but filtered to one college:
- Course and term information
- Tool name and interaction metrics
- Student engagement counts
- Last interaction time
- Instructor information
- Organizational hierarchy (all at same college level)

## How to Change the College Filter

Find and modify this line in the query:
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
```

Replace with your desired college name:
- `'College of Arts, Humanities & Social Sciences'`
- `'College of Business and Entrepreneurship'`
- `'College of Health and Life Sciences'`
- `'College of Education'`

**Important**: College name must match EXACTLY (case-sensitive).

