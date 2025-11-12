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

## Performance Tips

**Estimated Execution Time:**
- Single term: 15-25 seconds
- Between dates: 25-40 seconds

**Warehouse Sizing:**
- Medium: Recommended minimum
- Large: Optimal for large datasets

**Why Slower?**
- Student-level detail creates many rows
- Complex aggregation for course averages
- Joins to interaction logs

## Analysis Examples

### Identify Low-Engagement Students
```sql
WHERE student_interaction_count < course_avg_interaction * 0.5  -- Less than 50% of average
ORDER BY student_interaction_count ASC
```

### Students Not Active Recently
```sql
WHERE last_student_interaction < CURRENT_DATE - INTERVAL '7 DAYS'
  AND start_date < CURRENT_DATE - INTERVAL '14 DAYS'  -- Course has been running >2 weeks
ORDER BY last_student_interaction ASC
```

### High-Engagement Students (For Recognition)
```sql
WHERE student_interaction_count > course_avg_interaction * 1.5  -- 50% above average
ORDER BY student_interaction_count DESC
```

### Course-Level Summary (Aggregate Up)
```sql
SELECT
    course_name,
    instructors,
    COUNT(DISTINCT student_id) as enrolled_students,
    AVG(student_interaction_count) as avg_interactions,
    MIN(student_interaction_count) as min_interactions,
    MAX(student_interaction_count) as max_interactions
GROUP BY course_name, instructors
ORDER BY avg_interactions DESC
```

### Students Below Threshold
```sql
WHERE student_interaction_count < 10  -- Absolute threshold
ORDER BY course_name, student_name
```

## Early Warning System

### Flag At-Risk Students
```sql
SELECT
    course_name,
    instructors,
    instructor_emails,
    student_name,
    student_interaction_count,
    course_avg_interaction,
    ROUND(100.0 * student_interaction_count / NULLIF(course_avg_interaction, 0), 1) as percent_of_avg,
    DATEDIFF('day', last_student_interaction, CURRENT_DATE) as days_since_active
WHERE
    -- Flag if either low interaction OR inactive
    (student_interaction_count < course_avg_interaction * 0.5
     OR last_student_interaction < CURRENT_DATE - INTERVAL '10 DAYS')
    AND start_date < CURRENT_DATE - INTERVAL '14 DAYS'  -- Course running >2 weeks
ORDER BY percent_of_avg ASC, days_since_active DESC
```

### Generate Instructor Alerts
Export results and send to instructors:
```markdown
Subject: Low Engagement Alert - [Student Name] in [Course Name]

Dear [Instructor Name],

Our monitoring system has identified a student in your virtual course
who may benefit from outreach:

Student: [Student Name]
Course: [Course Name]
Interactions: [N] (Course Average: [Avg])
Last Active: [Date] ([N] days ago)

Consider reaching out to check in and offer support.
```

## Privacy and FERPA Considerations

**IMPORTANT**: Student-level data requires appropriate access controls.

### Best Practices
1. **Limit Access**: Only authorized staff should run this query
2. **Purpose**: Use only for student support, not punitive measures
3. **Aggregation for Reporting**: Aggregate to course-level for broader reports
4. **Retention**: Follow data retention policies
5. **Communication**: Train staff on appropriate use of student data

## Use Cases by Role

### Academic Advisors
- Identify advisees with low online engagement
- Proactive outreach for struggling students
- Support online learner success
- Track engagement trends

### Instructors
- Monitor individual student participation
- Identify students needing outreach
- Compare student engagement to peers
- Support timely interventions

### Online Learning Support Staff
- Track online student engagement
- Identify students for tutoring/support services
- Monitor online course health
- Support retention initiatives

### Student Success / Retention
- Early warning system for at-risk students
- Target interventions to low-engagement students
- Track effectiveness of outreach
- Support online student persistence

## Related Queries

- **virtual-course-total-interaction-per-student-per-course**: Course-level aggregates (no student names)
- **student-level-virtual-course-engagement**: Similar metrics, may have different filters
- **virtual-course-earliest-due-time**: Virtual course readiness
- **filter-virtual-course-by-college**: Virtual courses by college

## Best Practices

1. **Protect Student Privacy**: Appropriate access controls
2. **Contextualize Data**: Low engagement ≠ low learning (consider course design)
3. **Timely Intervention**: Run weekly during term
4. **Train Instructors**: Help faculty interpret and use data appropriately
5. **Support, Don't Punish**: Frame as student success tool
6. **Track Outcomes**: Monitor if interventions improve engagement
7. **Set Thresholds Thoughtfully**: Consider course type and design
8. **Combine with Other Data**: Look at grades, attendance, etc. holistically
9. **Respect Student Agency**: Some students succeed with minimal LMS interaction
10. **Document Process**: Clear protocols for using student engagement data
