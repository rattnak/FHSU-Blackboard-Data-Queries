# Virtual Course Total Interaction Per Student Per Course

## Queries
- `by-term.sql`: Course-level aggregated interaction statistics for virtual courses

## Overview

This query provides course-level aggregated statistics for virtual course engagement. Unlike the student-level query, this aggregates interactions to show overall course metrics without individual student details, making it suitable for broader reporting and privacy-friendly analysis.

**Primary Use Cases:**
- Monitor overall virtual course engagement
- Compare engagement across virtual courses
- Identify high and low-engagement virtual courses
- Report on online learning effectiveness
- Support strategic planning for online programs

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

**Filter**: Courses with at least 2 students

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full virtual course name |
| `total_course_interactions` | Sum of all student interactions in course |
| `active_students_count` | Number of students who have interacted |
| `avg_interaction_per_student` | Average interactions per student |
| `max_interaction` | Highest individual student interaction count |
| `min_interaction` | Lowest individual student interaction count |
| `last_interaction_time` | Most recent interaction in the course |
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

- **Course-Level Aggregation**: One row per virtual course
- **Engagement Statistics**: Average, min, max interactions per student
- **Activity Tracking**: Total interactions and recency
- **Privacy-Friendly**: No individual student identification
- **Instructor Context**: Contact information included

