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

## Performance Tips

**Estimated Execution Time:**
- Single term: 10-15 seconds
- Between dates: 18-25 seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for multiple terms

**Faster than student-level query** because results are aggregated to course level.

## Analysis Examples

### Rank Virtual Courses by Engagement
```sql
SELECT
    course_name,
    instructors,
    avg_interaction_per_student,
    active_students_count
ORDER BY avg_interaction_per_student DESC
```

### Identify Low-Engagement Virtual Courses
```sql
WHERE avg_interaction_per_student < 50  -- Below threshold
ORDER BY avg_interaction_per_student ASC
```

### Virtual Courses with High Engagement Variation
```sql
SELECT
    course_name,
    instructors,
    avg_interaction_per_student,
    max_interaction,
    min_interaction,
    (max_interaction - min_interaction) as range,
    ROUND((max_interaction - min_interaction) * 1.0 / NULLIF(avg_interaction_per_student, 0), 2) as variation_ratio
WHERE (max_interaction - min_interaction) > 100  -- Large spread
ORDER BY variation_ratio DESC
```

### Recently Inactive Virtual Courses
```sql
WHERE last_interaction_time < CURRENT_DATE - INTERVAL '7 DAYS'
  AND start_date < CURRENT_DATE - INTERVAL '14 DAYS'  -- Course should be active
ORDER BY last_interaction_time ASC
```

### Virtual Course Engagement by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(*) as virtual_courses,
    AVG(avg_interaction_per_student) as college_avg_interactions,
    AVG(active_students_count) as avg_students_per_course
GROUP BY college
ORDER BY college_avg_interactions DESC
```

### Virtual Course Health Dashboard
```sql
SELECT
    course_name,
    instructors,
    active_students_count,
    avg_interaction_per_student,
    DATEDIFF('day', last_interaction_time, CURRENT_DATE) as days_since_last_activity,
    CASE
        WHEN avg_interaction_per_student >= 100 THEN 'High Engagement'
        WHEN avg_interaction_per_student >= 50 THEN 'Moderate Engagement'
        ELSE 'Low Engagement'
    END as engagement_level,
    CASE
        WHEN last_interaction_time >= CURRENT_DATE - INTERVAL '3 DAYS' THEN 'Active'
        WHEN last_interaction_time >= CURRENT_DATE - INTERVAL '7 DAYS' THEN 'Recent'
        ELSE 'Inactive'
    END as activity_status
ORDER BY engagement_level, activity_status
```

## Engagement Benchmarks

### Establishing Baselines
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY avg_interaction_per_student) as q1_25th_percentile,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY avg_interaction_per_student) as median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_interaction_per_student) as q3_75th_percentile,
    AVG(avg_interaction_per_student) as mean
GROUP BY college
```

### Flag Courses Below Benchmark
```sql
WITH benchmarks AS (
    SELECT AVG(avg_interaction_per_student) as institution_avg
    FROM results
)
SELECT
    r.course_name,
    r.instructors,
    r.avg_interaction_per_student,
    b.institution_avg,
    ROUND(100.0 * r.avg_interaction_per_student / b.institution_avg, 1) as percent_of_avg
FROM results r, benchmarks b
WHERE r.avg_interaction_per_student < b.institution_avg * 0.75  -- Below 75% of average
ORDER BY percent_of_avg ASC
```

## Use Cases by Role

### Online Learning Office
- Monitor virtual course engagement across institution
- Identify courses needing support
- Report on online program health
- Track engagement trends over time

### Academic Technology
- Support instructors with low-engagement courses
- Share best practices from high-engagement courses
- Plan targeted professional development
- Track impact of online teaching support

### Academic Affairs
- Monitor quality of online offerings
- Report to leadership on online education
- Support strategic planning for online programs
- Demonstrate online learning effectiveness

### Institutional Research
- Analyze online course engagement patterns
- Correlate engagement with student outcomes
- Compare online vs. face-to-face engagement
- Support assessment and accreditation

## Executive Reporting Template

```markdown
# Virtual Course Engagement Report
**Term**: [Term Name]
**Date**: [Date]

## Overview
- **Virtual Courses**: [N] courses
- **Students in Virtual Courses**: [Sum of active_students_count]
- **Average Engagement**: [Avg of avg_interaction_per_student] interactions/student

## Engagement Distribution
- **High Engagement (>100)**: [N] courses ([%])
- **Moderate Engagement (50-100)**: [N] courses ([%])
- **Low Engagement (<50)**: [N] courses ([%])

## Top Performers
| Course | Instructor | Avg Interactions/Student |
|--------|-----------|-------------------------|
| [Course 1] | [Instructor] | [N] |
| [Course 2] | [Instructor] | [N] |
| [Course 3] | [Instructor] | [N] |

## Courses Needing Support
[List of courses below benchmark with contact info]

## Recommendations
1. [Based on data]
2. [Based on data]
3. [Based on data]
```

## Identifying Best Practices

### High-Engagement Course Characteristics
```sql
SELECT
    course_name,
    instructors,
    instructor_emails,
    avg_interaction_per_student,
    active_students_count
WHERE avg_interaction_per_student > (SELECT AVG(avg_interaction_per_student) * 1.5 FROM results)
ORDER BY avg_interaction_per_student DESC
```

**Next Step**: Interview high-engagement instructors about their course design and teaching practices.

## Related Queries

- **virtual-course-student-interaction**: Student-level detail (includes student names)
- **student-level-virtual-course-engagement**: Similar aggregation, different focus
- **virtual-course-earliest-due-time**: Virtual course readiness metrics
- **filter-virtual-course-by-college**: Virtual courses filtered by college

## Privacy Advantages

This query is **FERPA-friendly** for broader sharing:
- No individual student identification
- Aggregated metrics only
- Suitable for:
  - Department chair reports
  - College-level dashboards
  - Executive presentations
  - Public-facing reports (with appropriate context)

## Best Practices

1. **Set Context-Appropriate Benchmarks**: Engagement varies by discipline
2. **Track Longitudinally**: Compare term-to-term for same courses
3. **Combine with Outcomes**: Correlate engagement with grades/retention
4. **Share Success**: Highlight high-engagement courses
5. **Support Improvement**: Offer help to low-engagement courses
6. **Consider Course Design**: Some designs naturally generate more interactions
7. **Avoid Over-Interpretation**: High interactions ≠ high learning (always)
8. **Train Stakeholders**: Help interpret metrics appropriately
9. **Regular Monitoring**: Run monthly or mid-term and end-term
10. **Document Trends**: Track whether engagement is improving institution-wide

## Caveats and Considerations

### What "Interaction" Means
- Clicks, page views, content accesses
- Not necessarily deep engagement or learning
- Varies by content type and design

### Factors Affecting Engagement
- Course design (active vs. passive)
- Content type (discussions vs. readings)
- Assignment structure
- Student demographics
- Time in term

### Use Holistically
Combine with:
- Student success outcomes (grades, retention)
- Student satisfaction surveys
- Instructor reflections
- Qualitative course reviews
