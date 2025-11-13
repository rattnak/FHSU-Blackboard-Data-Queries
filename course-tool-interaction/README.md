# Course Tool Interaction Query

## Queries
- `by-term-query.sql`: Analyze tool interactions for courses in a specific term
- `between-date-query.sql`: Analyze tool interactions for courses between specific dates

## Overview

This comprehensive query tracks student engagement with specific educational technology tools integrated into Blackboard courses. It provides interaction counts, student engagement metrics, and last access times for multiple tools.

**Primary Use Cases:**
- Monitor adoption of educational technology tools
- Analyze student engagement with specific tools
- Compare tool usage across courses and departments
- Support tool effectiveness research
- Guide instructional technology investments

## Tracked Tools

The query monitors these educational technology tools:
- **YellowDig Engage** - Social learning platform
- **Packback** - AI-powered discussion platform
- **Feedback** - Assessment and feedback tool
- **Inscribe** - Digital annotation tool
- **GoReact** - Video assessment platform
- **Qwickly** - Attendance and engagement suite
- **VoiceThread** - Collaborative multimedia tool
- **Zoom** - Video conferencing integration

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
| `tool_name` | Name of the educational technology tool |
| `tool_interaction_count` | Total number of interactions with the tool |
| `students_interacted_count` | Number of unique students who used the tool |
| `last_interaction_time` | Most recent interaction timestamp |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Multi-Tool Tracking**: Monitors 8 different educational technology tools
- **Engagement Metrics**: Counts both total interactions and unique student users
- **Recency Tracking**: Records last interaction time for activity monitoring
- **Course Context**: Includes instructor and organizational hierarchy information
- **Flexible Filtering**: Query variants for term or date range analysis

## Technical Implementation

The query uses a multi-step CTE (Common Table Expression) structure:

1. **Tool Filter CTE**: Identifies content items matching tool name patterns
2. **Interaction Aggregation**: Counts user interactions and unique students
3. **Course Join**: Combines with course, term, and hierarchy information
4. **Instructor Aggregation**: Consolidates multiple instructors per course

## How to Use

### By-Term Query
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Add Additional Tools

To track additional tools, add to the WHERE clause:
```sql
WHERE (LOWER(ci.name) LIKE '%yellowdig%'
    OR LOWER(ci.name) LIKE '%packback%'
    OR LOWER(ci.name) LIKE '%feedback%'
    OR LOWER(ci.name) LIKE '%inscribe%'
    OR LOWER(ci.name) LIKE '%goreact%'
    OR LOWER(ci.name) LIKE '%qwickly%'
    OR LOWER(ci.name) LIKE '%voicethread%'
    OR LOWER(ci.name) LIKE '%zoom%'
    OR LOWER(ci.name) LIKE '%newtool%')  -- Add new tool here
```

