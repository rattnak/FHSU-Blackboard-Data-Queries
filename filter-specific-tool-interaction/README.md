# Filter Specific Tool Interaction

## Queries
- `by-term-query.sql`: Analyze interactions for a SPECIFIC tool in a specific term
- `between-date-query.sql`: Analyze interactions for a SPECIFIC tool between specific dates

## Overview

This query focuses on a single educational technology tool (default: YellowDig Engage) and shows only courses using that tool with their interaction metrics. This is a filtered subset of the `course-tool-interaction` query.

**Primary Use Cases:**
- Deep-dive analysis of single tool adoption
- Generate support lists for specific tool users
- Tool-specific effectiveness research
- Vendor reporting and ROI analysis
- Targeted professional development planning

## Default Tool
**YellowDig Engage** - Social learning discussion platform

To analyze a different tool, modify the search pattern in the query.

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
| `tool_name` | Name of the tool (e.g., "YellowDig Engage") |
| `tool_interaction_count` | Total interactions with the tool in this course |
| `students_interacted_count` | Number of unique students who used the tool |
| `last_interaction_time` | Most recent interaction timestamp |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## How to Change the Tool

### Option 1: Modify the WHERE Clause

Find and replace the tool name in the query:
```sql
WHERE LOWER(ci.name) LIKE '%yellowdig%'
```

Change to your desired tool:
```sql
WHERE LOWER(ci.name) LIKE '%packback%'    -- Packback
WHERE LOWER(ci.name) LIKE '%goreact%'      -- GoReact
WHERE LOWER(ci.name) LIKE '%voicethread%'  -- VoiceThread
WHERE LOWER(ci.name) LIKE '%zoom%'         -- Zoom
WHERE LOWER(ci.name) LIKE '%qwickly%'      -- Qwickly
WHERE LOWER(ci.name) LIKE '%inscribe%'     -- Inscribe
WHERE LOWER(ci.name) LIKE '%feedback%'     -- Feedback
```

### Option 2: Add Multiple Name Patterns

Some tools may have variations:
```sql
WHERE (LOWER(ci.name) LIKE '%yellowdig%'
    OR LOWER(ci.name) LIKE '%yellow dig%'
    OR LOWER(ci.name) LIKE '%yd engage%')
```

