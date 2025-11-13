# All College Department Query

## Overview

This query retrieves a comprehensive list of courses with their assigned instructors and organizational hierarchy information (colleges and departments).

**Primary Use Cases:**
- Generate departmental course rosters
- Identify course distribution across colleges and departments
- Create instructor assignment reports
- Audit course-to-organizational unit mappings

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
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Filters**: Only includes courses with instructors (role 'I')
- **Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Sorting**: Results ordered alphabetically by course name

