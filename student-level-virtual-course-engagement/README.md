# Student-Level Virtual Course Engagement

## Queries
- `by-term.sql`: Course-level engagement aggregates for virtual courses by term

## Overview

This query provides aggregated engagement statistics for virtual (online) courses at the course level. It calculates total interactions, student counts, and average engagement metrics without revealing individual student identities, making it suitable for broader reporting and analysis.

**Primary Use Cases:**
- Monitor virtual course engagement at course level
- Compare engagement across virtual courses
- Identify high and low-engagement online courses
- Report on online learning effectiveness
- Support online course quality initiatives
- Privacy-friendly engagement analysis

## Virtual Course Detection

**Pattern**: `course_name LIKE '%_V%_%'`

**Filter**: Courses with at least 2 students

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full virtual course name |
| `total_course_interactions` | Sum of all student interactions |
| `unique_students_interacted` | Number of students who engaged |
| `avg_interaction_per_student` | Average interactions per student |
| `max_interaction` | Highest student interaction count |
| `min_interaction` | Lowest student interaction count |
| `last_interaction_time` | Most recent activity in course |
| `start_date` | Course start date |
| `term` | Term name |
| `instructor_count` | Number of instructors |
| `instructors` | Comma-separated instructor names |
| `instructor_emails` | Comma-separated instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

## Key Features

- **Course-Level Aggregation**: One row per virtual course (privacy-friendly)
- **Engagement Statistics**: Average, min, max provide distribution insight
- **Activity Tracking**: Total volume and recency
- **Instructor Context**: Contact information for follow-up
- **Comparative**: Easy to rank and compare courses

