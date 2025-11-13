# Virtual Course Student Interaction

## Queries
- `by-term.sql`: Student-level interaction data for virtual courses in a specific term
- `between-date.sql`: Student-level interaction data for virtual courses between dates

## Overview

This query provides detailed, student-level interaction metrics for virtual (online) courses. It shows individual student engagement alongside course-average metrics, helping identify student participation patterns in online courses.

**Primary Use Cases:**
- Monitor individual student engagement in virtual courses
- Identify students with low online participation
- Support early intervention for at-risk online students
- Analyze virtual course engagement patterns
- Compare individual vs. course-average engagement

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

**Filter**: Courses with more than 1 student

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full virtual course name |
| `student_id` | Unique student identifier |
| `student_name` | Student's full name |
| `student_interaction_count` | This student's total interactions in course |
| `last_student_interaction` | When this student last accessed course |
| `course_avg_interaction` | Average interactions across all students in course |
| `start_date` | Course start date |
| `term` | Term name |
| `instructor_count` | Number of instructors |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Student-Level Granularity**: One row per student per virtual course
- **Course Context**: Includes course-average for comparison
- **Recency Tracking**: Shows last interaction timestamp
- **Instructor Contact Info**: Enables follow-up communication
- **Filtered**: Only courses with 2+ students (excludes independent studies)

