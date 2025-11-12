# Filter Courses by College

## Queries
- `by-term-query.sql`: Filter courses by college for a specific term
- `between-date-query.sql`: Filter courses by college between specific dates

## Overview

This query retrieves all courses offered in a specific college (e.g., College of Education) for a given term or date range, including instructor assignments and organizational hierarchy information.

**Primary Use Cases:**
- Generate college-specific course rosters
- Analyze course offerings within a particular college
- Create college-level instructor assignment reports
- Track course distribution for accreditation reporting

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level (within the filtered college) |

## Key Features

- **College Filter**: Uses `SPLIT_PART(ih.hierarchy_name_seq, '||', 4)` to extract and filter by college name
- **Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Sorting**: Results ordered by start date and course name

## How to Use

### Modify the College Filter

To change the college being filtered, update this line in the query:

```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
```

Replace `'College of Education'` with your desired college name (must match exactly).

### Common College Names
- College of Education
- College of Arts, Humanities & Social Sciences
- College of Business and Entrepreneurship
- College of Health and Life Sciences

## Performance Tips

**Estimated Execution Time:**
- Single term, single college: 3-5 seconds
- Date range query: 10-20 seconds

**Warehouse Sizing:**
- Small: Sufficient for single college queries
- Medium: Recommended for multiple terms

## Troubleshooting

### No Results
**Check**:
1. College name spelling matches exactly (case-sensitive)
2. Term filter is correct (`term.name = 'S2025'`)
3. Date range is valid (for between-date-query.sql)
4. Courses in that college have instructors assigned

### Unexpected Courses
**Issue**: Courses from wrong college appear
**Cause**: Courses may be cross-listed or assigned to multiple hierarchies
**Solution**: Verify hierarchy assignments in Blackboard admin

### Missing Departments
**Issue**: `institutional_hierarchy_level_4` shows as empty
**Cause**: Some courses may only be assigned at college level, not department level
**Solution**: This is expected for certain course types (workshops, special topics, etc.)
