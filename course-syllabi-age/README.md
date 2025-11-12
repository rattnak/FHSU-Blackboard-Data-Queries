# Course Syllabi Age Query

## Queries
- `by-term-query.sql`: Analyze syllabus age for courses in a specific term
- `between-date-query.sql`: Analyze syllabus age for courses between specific dates

## Overview

This query identifies courses containing syllabus content items and classifies them as "Current" or "Outdated" based on when the syllabus was last modified relative to its creation date. A syllabus is considered "Outdated" if it was modified more than 1 year after its creation date.

**Primary Use Cases:**
- Audit syllabus currency and maintenance
- Identify courses with outdated syllabus documents
- Track syllabus update patterns
- Support course quality assurance initiatives
- Monitor compliance with syllabus requirements

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `syllabus_item_name` | Name of the syllabus content item |
| `created_time` | When the syllabus item was originally created |
| `modified_time` | When the syllabus item was last modified |
| `status` | 'Current' or 'Outdated' classification |
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

- **Syllabus Detection**: Searches for content items with 'syllabus' in the name (case-insensitive)
- **Age Classification Logic**:
  - **Outdated**: `modified_time > created_time + INTERVAL '1 YEAR'`
  - **Current**: Modified within 1 year of creation
- **Creation & Modification Tracking**: Shows both timestamps for analysis
- **All Syllabi Included**: Shows both current and outdated (not filtered)

## Classification Logic

```sql
CASE
    WHEN ci.modified_time > ci.created_time + INTERVAL '1 YEAR'
    THEN 'Outdated'
    ELSE 'Current'
END AS status
```

**"Outdated" means**: The syllabus was last modified MORE than 1 year after it was created.

**Important Note**: This measures time between creation and last modification, not absolute age. A syllabus created 5 years ago but updated recently may still show as "Current" depending on when the last update occurred relative to creation.

## How to Use

### By-Term Query
Filter by specific term:
```sql
WHERE term.name = 'S2025'
```

### Between-Date Query
Filter by course start date range:
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Finding Syllabus Items
The query searches for items where:
```sql
LOWER(ci.name) LIKE '%syllabus%'
```

Common matches: "Syllabus", "Course Syllabus", "SYLLABUS.pdf", "Syllabus_Fall2024", etc.

## Performance Tips

**Estimated Execution Time:**
- Single term: 5-10 seconds
- Full academic year: 15-25 seconds

**Warehouse Sizing:**
- Small: Sufficient for single term
- Medium: Recommended for multiple terms

## Analysis Examples

### Count Outdated vs. Current by College
```sql
SELECT
    institutional_hierarchy_level_3 as college,
    status,
    COUNT(*) as count
GROUP BY college, status
ORDER BY college, status
```

### Identify Courses with Oldest Syllabi
```sql
ORDER BY created_time ASC
LIMIT 100
```

### Find Syllabi Never Modified
```sql
WHERE created_time = modified_time
```

## Troubleshooting

### No Results
**Possible Causes**:
1. No content items named "syllabus" exist in filtered courses
2. Term/date filter excludes all courses
3. Syllabi use different naming convention (e.g., "Course Info", "Overview")

**Solutions**:
- Modify the LIKE clause to search for alternative terms
- Check syllabus naming conventions at your institution
- Remove term filter to see if any syllabi exist

### Unexpected "Current" Classification
**Issue**: Old syllabus marked as "Current"
**Cause**: This query measures modification age RELATIVE to creation, not absolute age
**Example**:
  - Created: 2020-01-01
  - Modified: 2020-06-01 (6 months later)
  - Status: "Current" (modified within 1 year of creation)

**Solution**: Use `course-syllabi-last-modified` query for absolute age measurement

### Too Many Results
**Issue**: Multiple syllabi per course
**Cause**: Courses may have multiple items with "syllabus" in the name
**Examples**: "Syllabus", "Syllabus Acknowledgement", "Syllabus Quiz"
**Solution**: Add more specific name filters or review item types

### Different Syllabus Naming
**Issue**: Your institution uses different terms
**Solution**: Modify the search pattern:
```sql
WHERE (LOWER(ci.name) LIKE '%syllabus%'
    OR LOWER(ci.name) LIKE '%course info%'
    OR LOWER(ci.name) LIKE '%course outline%')
```

## Alternative Age Definition

If you need to measure absolute age (time since last modification), see the related query:
- **course-syllabi-last-modified**: Classifies as outdated if not modified in past year (absolute)

## Use Cases by Role

### Academic Affairs
- Monitor syllabus quality across institution
- Identify courses needing syllabus updates
- Track compliance with syllabus policies

### Department Chairs
- Review syllabus maintenance in department
- Support faculty with course updates
- Prepare for accreditation reviews

### Instructional Designers
- Prioritize course refresh projects
- Identify instructors needing syllabus template support
- Track course maintenance metrics

### Quality Assurance
- Audit course content currency
- Support accreditation documentation
- Monitor institutional quality standards

## Related Queries

- **course-syllabi-last-modified**: Uses absolute age (time since last modification)
- **filter-outdated-syllabi-age**: Shows ONLY outdated syllabi (filtered subset)
- **filter-outdated-syllabi-last-modified**: Shows ONLY syllabi not modified in past year

## Best Practices

1. **Understand Both Age Metrics**: Use both "age" and "last-modified" queries for complete picture
2. **Set Institutional Standards**: Define what "outdated" means for your context
3. **Communicate with Faculty**: Share results to support course maintenance
4. **Run Before Terms**: Generate reports before term starts for proactive updates
5. **Consider Course Types**: Templates and master courses may intentionally have old dates
