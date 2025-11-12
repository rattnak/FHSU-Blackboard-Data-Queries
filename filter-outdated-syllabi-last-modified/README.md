# Filter Outdated Syllabi by Last Modified Date

## Queries
- `by-term-query.sql`: Show ONLY syllabi not modified in past year for a specific term
- `between-date-query.sql`: Show ONLY syllabi not modified in past year for courses between specific dates
- `hans-by-term-query.sql`: Alternative variant (possibly customized for specific user)
- `hans-between-date-query.sql`: Alternative variant (possibly customized for specific user)

## Overview

This query filters to show ONLY courses with outdated syllabi, where "outdated" means the syllabus has NOT been modified in the past 1 year (absolute time measurement). This is a filtered subset of the `course-syllabi-last-modified` query.

**Primary Use Cases:**
- Generate action lists for stale content
- Prioritize syllabus refresh projects
- Create instructor outreach campaigns
- Target course quality interventions
- Support pre-term course preparation

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the outdated syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified (>1 year ago) |
| `status` | Always 'Outdated' (filtered to this value only) |
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

- **Filtered Results**: Shows ONLY outdated syllabi (status = 'Outdated')
- **"Outdated" Definition**: `modified_time < CURRENT_DATE - INTERVAL '1 YEAR'`
- **Absolute Age**: Measures time since last modification (not relative to creation)
- **Action-Oriented**: Results are courses needing immediate attention
- **Contact Information**: Includes instructor emails for outreach

## "Outdated" Classification

A syllabus is flagged as "Outdated" if:
```sql
ci.modified_time < CURRENT_DATE - INTERVAL '1 YEAR'
```

This means the syllabus has NOT been modified in the past year (measured from today).

**Important Difference**:
- This query uses **absolute age** (time since last modification)
- `filter-outdated-syllabi-age` uses **relative age** (creation to modification interval)

## How to Use

### By-Term Query
Focus on specific term:
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
Focus on date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Adjust Outdated Threshold

To change the 1-year threshold:
```sql
-- 6 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '6 MONTHS'

-- 18 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '18 MONTHS'

-- 90 days
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '90 DAYS'
```

### "Hans" Variants

The `hans-*` query files may contain customizations such as:
- Different outdated thresholds
- Additional filters or exclusions
- Modified output columns
- Specific reporting formats

Check these files for variations that might better suit specific needs.

## Performance Tips

**Estimated Execution Time:**
- Single term: 4-8 seconds
- Full academic year: 12-20 seconds

**Warehouse Sizing:**
- Small: Sufficient for most queries

**Optimization**: Results typically smaller than unfiltered queries, so performance is good.

## Analysis Examples

### Count by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(*) as outdated_count,
    COUNT(DISTINCT instructors) as affected_instructors
GROUP BY college
ORDER BY outdated_count DESC
```

### Find Oldest Syllabi
```sql
SELECT
    course_name,
    instructors,
    modified_time,
    DATEDIFF('day', modified_time, CURRENT_DATE) as days_since_modified
ORDER BY days_since_modified DESC
LIMIT 100
```

### Courses Starting Soon with Outdated Syllabi
```sql
SELECT *
WHERE start_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 DAYS'
ORDER BY start_date ASC
```

### Instructor Summary
```sql
SELECT
    instructors,
    instructor_emails,
    COUNT(*) as outdated_courses,
    MIN(modified_time) as oldest_syllabus_date
GROUP BY instructors, instructor_emails
ORDER BY outdated_courses DESC
```

## Troubleshooting

### No Results
**Possible Interpretations**:
1. **Excellent!** All syllabi have been updated recently
2. No syllabi exist with "syllabus" in name
3. Term/date filter excludes all courses
4. Different naming conventions used

**Solutions**:
- Run parent query (`course-syllabi-last-modified`) to see all
- Check for alternative naming patterns
- Verify term/date filters

### Too Many Results
**Issue**: Large number of outdated syllabi
**This is common** and indicates need for refresh campaign

**Prioritization**:
1. Courses starting soonest
2. High enrollment courses
3. Required/core curriculum courses
4. Recently rolled-over courses needing updates

### Syllabi Recently "Touched" But Not Updated
**Issue**: Modified date recent but content still outdated
**Cause**: Opening/saving updates `modified_time` without content changes
**Solution**:
- Manual content review may still be needed
- Consider adding content hash comparisons
- Train instructors on meaningful updates

## Prioritization and Workflow

### Priority Levels

**Critical (Contact Immediately)**:
```sql
WHERE start_date <= CURRENT_DATE + INTERVAL '14 DAYS'
```

**High (Contact Soon)**:
```sql
WHERE start_date BETWEEN CURRENT_DATE + INTERVAL '14 DAYS'
              AND CURRENT_DATE + INTERVAL '30 DAYS'
```

**Medium (Monitor)**:
```sql
WHERE start_date > CURRENT_DATE + INTERVAL '30 DAYS'
```

### Workflow Example

1. **Week -6**: Run query for next term
2. **Week -5**: Send instructor notifications with priorities
3. **Week -4**: Follow up with Priority 1 instructors
4. **Week -3**: Assign instructional design support as needed
5. **Week -2**: Re-run query to track progress
6. **Week -1**: Final reminders for remaining courses
7. **Week 0**: Document completion rates for reporting

## Communication Templates

### Subject Line Options
- "Action Needed: Syllabus Update for [Term]"
- "Course Maintenance Reminder: [Course Name]"
- "Syllabus Refresh Required Before [Start Date]"

### Email Body Template
```
Dear [Instructor Name],

Our course quality review indicates that the syllabus in your
[Term] course has not been updated recently:

Course: [Course Name]
Course ID: [Course ID]
Start Date: [Start Date]
Last Modified: [Modified Time]
Days Since Update: [Days]

Please review and update your syllabus to ensure students receive
current information regarding:
- Course policies reflecting current practices
- Up-to-date contact information
- Accurate schedule and due dates
- Current institutional policies

Need help? Contact [Support Team] at [Contact Info]

We recommend updating by [Deadline Date].

Thank you for your attention to course quality.
```

## Use Cases by Role

### Instructional Design Team
- Create prioritized work queues
- Assign courses to team members
- Track update completion
- Provide templates and support
- Report on course readiness metrics

### Department Chairs
- Monitor departmental course quality
- Identify instructors needing support
- Allocate departmental resources
- Prepare for reviews and audits

### Academic Affairs
- Institution-wide quality monitoring
- Strategic planning for course refresh
- Policy compliance tracking
- Leadership reporting

### Quality Assurance
- Accreditation preparation
- Audit documentation
- Trend analysis over time
- Benchmarking against standards

### Faculty Development
- Target training opportunities
- Identify support needs
- Create resource materials
- Offer consultation services

## Related Queries

- **course-syllabi-last-modified**: Parent query showing ALL syllabi with status
- **filter-outdated-syllabi-age**: Filters by relative age (creation to modification)
- **course-syllabi-age**: Shows all syllabi with relative age classification

## Comparison: Two "Outdated" Definitions

| Aspect | This Query (Last Modified) | filter-outdated-syllabi-age |
|--------|---------------------------|----------------------------|
| **Measures** | Time since last modification | Time from creation to modification |
| **Outdated If** | Not modified in past year | Modified >1 year after creation |
| **Flag Example 1** | Created 2020, Modified 2020 → Outdated | Created 2020, Modified 2020 → Current |
| **Flag Example 2** | Created 2024, Modified 2024 → Current | Created 2020, Modified 2024 → Outdated |
| **Best For** | Finding stale content | Finding infrequently maintained content |
| **Action Focus** | Immediate refresh needed | Review maintenance patterns |

**Recommendation**: Use BOTH for comprehensive analysis.

## Best Practices

1. **Set Clear Expectations**: Define institutional standards for syllabus currency
2. **Run Proactively**: 4-8 weeks before term allows sufficient update time
3. **Prioritize Strategically**: Start date, enrollment, program requirements
4. **Provide Resources**: Templates, examples, training, one-on-one support
5. **Track Progress**: Re-run weekly to monitor completion
6. **Close the Loop**: Thank instructors who complete updates
7. **Document Patterns**: Identify courses/instructors consistently current or outdated
8. **Share Success**: Highlight departments with excellent maintenance
9. **Consider Context**: Master courses, templates may intentionally be static
10. **Combine Metrics**: Use with relative-age query for complete picture
