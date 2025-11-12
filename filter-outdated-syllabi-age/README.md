# Filter Outdated Syllabi by Age

## Queries
- `by-term-query.sql`: Show ONLY outdated syllabi for courses in a specific term
- `between-date-query.sql`: Show ONLY outdated syllabi for courses between specific dates

## Overview

This query filters to show ONLY courses with outdated syllabus content, where "outdated" means the syllabus was last modified more than 1 year after its creation date. This is a filtered subset of the `course-syllabi-age` query.

**Primary Use Cases:**
- Generate action lists for course maintenance
- Prioritize syllabus update projects
- Create instructor outreach lists
- Target interventions for course quality
- Support pre-term course readiness

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the outdated syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified |
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
- **"Outdated" Definition**: `modified_time > created_time + INTERVAL '1 YEAR'`
- **Syllabus Detection**: Searches for content items with 'syllabus' in name (case-insensitive)
- **Action-Oriented**: Results are courses that need attention
- **Contact Information**: Includes instructor emails for outreach

## "Outdated" Classification

A syllabus is flagged as "Outdated" if:
```sql
ci.modified_time > ci.created_time + INTERVAL '1 YEAR'
```

This means the time between creation and last modification is MORE than 1 year.

**Important**: This measures relative age (creation to modification interval), not absolute age. See `filter-outdated-syllabi-last-modified` for absolute age filtering.

## How to Use

### By-Term Query
Focus on specific term:
```sql
WHERE term.name = 'S2025'
```

**Best Practice**: Run 2-4 weeks before term starts to give instructors time to update.

### Between-Date Query
Focus on date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Generate Instructor Contact List
Export the results and use the `instructor_emails` column to:
- Send reminder emails
- Create support tickets
- Schedule training sessions
- Assign to instructional design team

## Performance Tips

**Estimated Execution Time:**
- Single term: 4-8 seconds
- Full academic year: 12-20 seconds

**Warehouse Sizing:**
- Small: Sufficient for most queries

**Note**: Usually faster than unfiltered query since results are smaller.

## Analysis Examples

### Count by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    COUNT(*) as outdated_count
GROUP BY college
ORDER BY outdated_count DESC
```

### Count by Department
```sql
SELECT
    institutional_hierarchy_level_4 as department,
    COUNT(*) as outdated_count
GROUP BY department
ORDER BY outdated_count DESC
```

### Identify Instructors with Most Outdated Syllabi
```sql
SELECT
    instructors,
    COUNT(*) as outdated_course_count
GROUP BY instructors
ORDER BY outdated_course_count DESC
```

### Find Oldest Outdated Syllabi
```sql
ORDER BY created_time ASC
LIMIT 50
```

## Troubleshooting

### No Results
**Possible Interpretations**:
1. **Good News**: All syllabi are current!
2. No syllabi exist with "syllabus" in name
3. Term/date filter excludes all courses
4. Institutional naming conventions differ

**Solutions**:
- Run parent query (`course-syllabi-age`) to see all syllabi
- Check for alternative naming ("Course Info", "Overview")
- Verify term filter is correct

### Fewer Results Than Expected
**Issue**: Expected more outdated syllabi
**Possible Causes**:
- Recent institution-wide refresh initiative
- Good course maintenance practices
- Syllabi may be using different names

### More Results Than Expected
**Issue**: Too many outdated syllabi
**Possible Causes**:
- Courses rolled over without syllabus updates
- Master course/template copies need refreshing
- Need for syllabus update campaign

**Action**: Prioritize by term start date and enrollment

## Prioritization Strategies

### Priority 1: Immediate Attention
- Courses starting in next 2 weeks
- High enrollment courses
- Required courses for majors

### Priority 2: Near-Term
- Courses starting in next 4-6 weeks
- Frequently offered courses
- Courses with multiple sections

### Priority 3: Longer-Term
- Courses later in term
- Special topics/electives
- Low enrollment courses

### SQL for Prioritization
```sql
SELECT *,
    CASE
        WHEN start_date <= CURRENT_DATE + INTERVAL '14 DAYS' THEN 'Priority 1'
        WHEN start_date <= CURRENT_DATE + INTERVAL '42 DAYS' THEN 'Priority 2'
        ELSE 'Priority 3'
    END as priority
ORDER BY priority, start_date
```

## Use Cases by Role

### Instructional Design Team
- Generate work queue for course reviews
- Assign courses to designers for updates
- Track completion of syllabus updates
- Report on course readiness metrics

### Department Chairs
- Monitor department course quality
- Contact instructors about updates needed
- Allocate resources for course maintenance
- Prepare for accreditation reviews

### Academic Affairs
- Institution-wide syllabus quality monitoring
- Support strategic course refresh initiatives
- Track compliance with syllabus policies
- Generate board/leadership reports

### Faculty Development
- Identify instructors needing support
- Plan syllabus update workshops
- Create targeted training materials
- Offer one-on-one consultation

## Communication Templates

### Email to Instructors
```
Subject: Action Needed: Syllabus Update for [Course Name]

Dear [Instructor Name],

Our course quality review shows that the syllabus in your course
[Course Name] was last updated more than a year ago. Please review
and update your syllabus to ensure students have current information
for [Term].

Course: [Course Name]
Start Date: [Start Date]
Current Syllabus Modified: [Modified Time]

Please contact [Support Contact] if you need assistance.
```

## Related Queries

- **course-syllabi-age**: Parent query showing ALL syllabi (current and outdated)
- **filter-outdated-syllabi-last-modified**: Filters by absolute age (not modified in past year)
- **course-syllabi-last-modified**: Shows all syllabi with absolute age classification

## Best Practices

1. **Run Proactively**: 4-6 weeks before term for sufficient update time
2. **Prioritize by Start Date**: Focus on immediate term needs first
3. **Provide Support**: Offer templates, examples, and assistance
4. **Track Progress**: Re-run query to monitor completion
5. **Automate Notifications**: Schedule regular reports to stakeholders
6. **Celebrate Success**: Acknowledge instructors who maintain current syllabi
7. **Use Both Age Metrics**: Also run last-modified query for complete picture
8. **Document Context**: Some master courses intentionally don't need frequent updates
