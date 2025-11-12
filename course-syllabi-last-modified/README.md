# Course Syllabi Last Modified Query

## Queries
- `by-term-query.sql`: Analyze when syllabi were last modified for courses in a specific term
- `between-date-query.sql`: Analyze when syllabi were last modified for courses between specific dates

## Overview

This query identifies courses containing syllabus content items and classifies them as "Current" or "Outdated" based on when the syllabus was last modified. A syllabus is considered "Outdated" if it has NOT been modified in the past 1 year (absolute time measurement).

**Primary Use Cases:**
- Audit syllabus currency and maintenance
- Identify courses with stale syllabus documents
- Track syllabus update frequency
- Support course quality assurance initiatives
- Monitor compliance with syllabus policies

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
- **Absolute Age Classification**:
  - **Outdated**: `modified_time < CURRENT_DATE - INTERVAL '1 YEAR'`
  - **Current**: Modified within the past 1 year
- **Creation & Modification Tracking**: Shows both timestamps for analysis
- **All Syllabi Included**: Shows both current and outdated (not filtered)

## Classification Logic

```sql
CASE
    WHEN ci.modified_time < CURRENT_DATE - INTERVAL '1 YEAR'
    THEN 'Outdated'
    ELSE 'Current'
END AS status
```

**"Outdated" means**: The syllabus has NOT been modified in the past year (measured from current date).

**Important Difference from "syllabi-age"**:
- This query measures absolute time since last modification
- The "syllabi-age" query measures time between creation and last modification

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

### Adjust Outdated Threshold

To change the 1-year threshold:
```sql
-- 6 months
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '6 MONTHS'

-- 2 years
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '2 YEARS'

-- 180 days
WHERE ci.modified_time < CURRENT_DATE - INTERVAL '180 DAYS'
```

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

### Find Oldest Last-Modified Dates
```sql
ORDER BY modified_time ASC
LIMIT 100
```

### Calculate Days Since Last Modification
```sql
SELECT
    course_name,
    syllabus_item_name,
    modified_time,
    DATEDIFF('day', modified_time, CURRENT_DATE) as days_since_modified
ORDER BY days_since_modified DESC
```

## Troubleshooting

### No Results
**Possible Causes**:
1. No content items named "syllabus" exist in filtered courses
2. Term/date filter excludes all courses
3. Syllabi use different naming convention (e.g., "Course Info")

**Solutions**:
- Modify the LIKE clause to search for alternative terms
- Check syllabus naming conventions at your institution
- Remove term filter to verify syllabi exist

### All Syllabi Show as "Outdated"
**Issue**: Even recent courses have outdated syllabi
**Possible Causes**:
1. Syllabi rolled over from old terms without modification
2. Course copies preserve old modification dates
3. Instructors not updating syllabi term-to-term

**This is common** - often indicates need for syllabus refresh initiative

### Unexpected "Current" Classification
**Issue**: Obviously old syllabus marked as "Current"
**Cause**: Someone may have opened/saved the item recently (even without substantive changes)
**Note**: Blackboard updates `modified_time` when items are saved, even if content unchanged

### Too Many Results
**Issue**: Multiple syllabi per course
**Cause**: Courses may have multiple items with "syllabus" in name
**Examples**: "Syllabus", "Syllabus Quiz", "Syllabus Acknowledgement Form"
**Solution**: Add more specific filters or aggregate by course

## Comparison: Last Modified vs. Age

| Metric | This Query (Last Modified) | course-syllabi-age |
|--------|---------------------------|-------------------|
| **Measures** | Time since last modification | Time between creation and modification |
| **Outdated If** | Not modified in past year | Modified >1 year after creation |
| **Best For** | Finding stale content | Understanding update patterns |
| **Use Case** | Identifying syllabi needing refresh | Tracking maintenance frequency |

**Recommendation**: Use BOTH queries for complete picture of syllabus maintenance.

## Use Cases by Role

### Academic Affairs
- Monitor syllabus freshness across institution
- Identify courses needing policy updates
- Track compliance with syllabus requirements
- Support accreditation documentation

### Department Chairs
- Review syllabus maintenance in department
- Identify instructors needing support
- Plan syllabus update initiatives
- Monitor departmental quality standards

### Instructional Designers
- Prioritize course refresh projects
- Support instructors with updates
- Track course maintenance metrics
- Identify template and master course needs

### Faculty Development
- Target professional development on syllabus best practices
- Support new faculty with syllabus creation
- Share examples of well-maintained courses

## Related Queries

- **course-syllabi-age**: Measures time between creation and modification (relative age)
- **filter-outdated-syllabi-last-modified**: Shows ONLY outdated syllabi (filtered)
- **filter-outdated-syllabi-age**: Shows ONLY syllabi outdated by relative age metric

## Best Practices

1. **Define Institutional Standard**: Decide what "outdated" means (1 year is common)
2. **Run Regularly**: Monthly or quarterly monitoring catches issues early
3. **Share Proactively**: Send reports to instructors before term starts
4. **Consider Context**: Some master courses intentionally don't need frequent updates
5. **Combine Metrics**: Use both last-modified and age queries for complete analysis
6. **Support, Don't Police**: Frame as support for quality teaching, not compliance
7. **Document Patterns**: Track which departments maintain syllabi well and share practices
