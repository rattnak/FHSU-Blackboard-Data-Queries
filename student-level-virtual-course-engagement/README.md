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

## Performance Tips

**Estimated Execution Time:**
- Single term: 10-15 seconds
- Multiple terms: 20-30 seconds

**Warehouse Sizing:**
- Small: OK for single term
- Medium: Recommended for multiple terms

**Faster than student-level detail** due to aggregation.

## Analysis Examples

### Rank Virtual Courses by Engagement
```sql
SELECT
    course_name,
    instructors,
    unique_students_interacted,
    avg_interaction_per_student,
    total_course_interactions
ORDER BY avg_interaction_per_student DESC
```

### Identify Low-Engagement Virtual Courses
```sql
WHERE avg_interaction_per_student < 50
ORDER BY avg_interaction_per_student ASC
```

### High Engagement Variation (Some Students Very Active, Others Not)
```sql
SELECT
    course_name,
    instructors,
    avg_interaction_per_student,
    max_interaction,
    min_interaction,
    (max_interaction - min_interaction) as engagement_range
WHERE (max_interaction - min_interaction) > 100
ORDER BY engagement_range DESC
```

### Recently Inactive Courses
```sql
WHERE last_interaction_time < CURRENT_DATE - INTERVAL '7 DAYS'
  AND start_date < CURRENT_DATE - INTERVAL '14 DAYS'
ORDER BY last_interaction_time ASC
```

### Virtual Course Engagement by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(*) as virtual_courses,
    ROUND(AVG(avg_interaction_per_student), 1) as avg_engagement,
    ROUND(AVG(unique_students_interacted), 1) as avg_students
GROUP BY college
ORDER BY avg_engagement DESC
```

### Course Health Dashboard
```sql
SELECT
    course_name,
    instructors,
    unique_students_interacted,
    ROUND(avg_interaction_per_student, 1) as avg_engagement,
    DATEDIFF('day', last_interaction_time, CURRENT_DATE) as days_inactive,
    CASE
        WHEN avg_interaction_per_student >= 100 THEN 'High'
        WHEN avg_interaction_per_student >= 50 THEN 'Moderate'
        ELSE 'Low'
    END as engagement_level,
    CASE
        WHEN last_interaction_time >= CURRENT_DATE - INTERVAL '3 DAYS' THEN 'Active'
        WHEN last_interaction_time >= CURRENT_DATE - INTERVAL '7 DAYS' THEN 'Recent'
        ELSE 'Inactive'
    END as activity_status
ORDER BY engagement_level DESC, activity_status
```

## Engagement Benchmarking

### Institution-Wide Benchmarks
```sql
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY avg_interaction_per_student) as q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY avg_interaction_per_student) as median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_interaction_per_student) as q3,
    AVG(avg_interaction_per_student) as mean,
    STDDEV(avg_interaction_per_student) as std_dev
```

### Flag Outliers
```sql
WITH stats AS (
    SELECT
        AVG(avg_interaction_per_student) as mean,
        STDDEV(avg_interaction_per_student) as std_dev
    FROM results
)
SELECT
    r.course_name,
    r.instructors,
    r.avg_interaction_per_student,
    s.mean,
    CASE
        WHEN r.avg_interaction_per_student > s.mean + (2 * s.std_dev) THEN 'Exceptionally High'
        WHEN r.avg_interaction_per_student < s.mean - (2 * s.std_dev) THEN 'Exceptionally Low'
        ELSE 'Normal Range'
    END as engagement_category
FROM results r, stats s
WHERE engagement_category != 'Normal Range'
ORDER BY r.avg_interaction_per_student DESC
```

## Use Cases by Role

### Online Learning Office
- Monitor virtual course health institution-wide
- Identify courses needing support
- Report on online program effectiveness
- Track engagement trends

### Academic Technology
- Support instructors with engagement data
- Share best practices from high-engagement courses
- Plan targeted interventions
- Track online teaching support impact

### Academic Affairs
- Monitor online education quality
- Report to leadership on online programs
- Support strategic planning
- Demonstrate online learning effectiveness

### Department Chairs
- Review department virtual courses
- Recognize high-engagement instructors
- Support improvement for low-engagement courses
- Monitor departmental online quality

### Instructional Design
- Prioritize course review/support
- Identify exemplar courses for case studies
- Track design intervention effectiveness
- Support data-informed course improvement

## Early Warning System

### Courses Needing Immediate Support
```sql
WHERE (avg_interaction_per_student < 25
    OR last_interaction_time < CURRENT_DATE - INTERVAL '10 DAYS')
  AND start_date < CURRENT_DATE - INTERVAL '14 DAYS'
ORDER BY avg_interaction_per_student ASC
```

**Action**: Contact instructors to offer support

### Proactive Monitoring
```sql
WHERE avg_interaction_per_student BETWEEN 25 AND 50
ORDER BY avg_interaction_per_student ASC
```

**Action**: Monitor closely, offer resources

## Identifying Best Practices

### High-Engagement Courses for Case Studies
```sql
WHERE avg_interaction_per_student > (
    SELECT AVG(avg_interaction_per_student) * 1.5
    FROM results
)
ORDER BY avg_interaction_per_student DESC
LIMIT 10
```

**Next Steps**:
1. Interview instructors about course design
2. Review course structure and activities
3. Document best practices
4. Share with peers

## Visualizations

### Distribution Histogram
- X-axis: Engagement Level (bins)
- Y-axis: Number of Courses
- Shows overall engagement distribution

### Scatter Plot: Students vs. Engagement
- X-axis: Unique Students
- Y-axis: Avg Interaction per Student
- Point Size: Total Interactions
- Identify patterns by size

### Box Plot by College
- X-axis: College
- Y-axis: Avg Interaction per Student
- Shows distribution and outliers by unit

## Reporting Template

```markdown
# Virtual Course Engagement Report: [Term]

## Summary Statistics
- **Virtual Courses**: [N] courses
- **Total Students**: [Sum of unique_students_interacted]
- **Average Engagement**: [Mean avg_interaction_per_student] interactions/student
- **Median Engagement**: [Median] interactions/student

## Engagement Distribution
- **High (>100)**: [N] courses ([X]%)
- **Moderate (50-100)**: [N] courses ([X]%)
- **Low (<50)**: [N] courses ([X]%)

## Top Performing Courses
| Course | Instructor | Avg Engagement | Students |
|--------|-----------|----------------|----------|
| [Name] | [Name] | [N] | [N] |
| [Name] | [Name] | [N] | [N] |

## Courses Needing Support
[List of courses below benchmark with contact info]

## Trends
- [Observation compared to previous term]
- [Observation about college/department patterns]

## Recommendations
1. [Action based on data]
2. [Action based on patterns]
3. [Action based on goals]
```

## Privacy Advantages

This query is **FERPA-compliant** for broader sharing:
- ✓ No individual student identification
- ✓ Aggregated statistics only
- ✓ Suitable for department/college reports
- ✓ Safe for executive presentations
- ✓ Appropriate for board reports

## Contextual Considerations

### What "Interaction" Means
- LMS clicks, views, submissions
- Quantitative, not necessarily qualitative
- One measure among many

### Factors Affecting Engagement
- Course design (active vs. passive)
- Discipline norms
- Assignment structure
- Student demographics
- Time in term
- Course format

### Holistic Assessment
Combine engagement data with:
- Student success outcomes
- Course completion rates
- Student satisfaction surveys
- Instructor course design
- Qualitative course reviews

## Related Queries

- **virtual-course-student-interaction**: Student-level detail (includes names - restricted access)
- **virtual-course-total-interaction-per-student-per-course**: Similar aggregation with slightly different focus
- **virtual-course-earliest-due-time**: Virtual course readiness
- **filter-virtual-course-by-college**: Virtual courses filtered by college

## Best Practices

1. **Set Realistic Benchmarks**: Vary by discipline and design
2. **Track Longitudinally**: Compare term-to-term
3. **Support, Don't Punish**: Frame as improvement tool
4. **Combine with Outcomes**: Correlate with success metrics
5. **Respect Design Differences**: Not all courses need high interaction counts
6. **Share Success Stories**: Highlight effective practices
7. **Protect Privacy**: Use aggregated data appropriately
8. **Train Stakeholders**: Help interpret metrics correctly
9. **Regular Monitoring**: Run mid-term and end-term
10. **Document Actions**: Track interventions and their impact
