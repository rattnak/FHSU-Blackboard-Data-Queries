# Filter Courses by College and Department

## Queries
- `by-term-query.sql`: Filter courses by college and department for a specific term
- `between-date-query.sql`: Filter courses by college and department between specific dates

## Overview

This query retrieves all courses offered in a specific college AND department (e.g., College of Education, Teacher Education) for a given term or date range. This provides more granular filtering than college-only queries.

**Primary Use Cases:**
- Generate department-specific course rosters
- Analyze course offerings within a particular department
- Create department-level instructor assignment reports
- Support department chair reviews and planning
- Track course distribution for program accreditation

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
| `institutional_hierarchy_level_4` | Department Level (filtered value) |

## Key Features

- **Dual Filter**: Uses both college and department hierarchy levels
  - College: `SPLIT_PART(ih.hierarchy_name_seq, '||', 4)`
  - Department: `SPLIT_PART(ih.hierarchy_name_seq, '||', 5)`
- **Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Sorting**: Results ordered by start date and course name

## How to Use

### Modify the College and Department Filters

To change the college and department being filtered, update these lines in the query:

```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 5) = 'Teacher Education'
```

Replace with your desired college and department names (must match exactly).

### Example Combinations
- College of Education / Teacher Education
- College of Arts, Humanities & Social Sciences / History
- College of Business and Entrepreneurship / Management
- College of Health and Life Sciences / Nursing

## Performance Tips

**Estimated Execution Time:**
- Single term, specific department: 2-4 seconds
- Date range query: 8-15 seconds

**Warehouse Sizing:**
- Small: Sufficient for department-level queries
- Medium: Recommended for multiple terms or departments

## Troubleshooting

### No Results
**Check**:
1. Both college AND department names match exactly (case-sensitive)
2. Term filter is correct (`term.name = 'S2025'`)
3. Date range is valid (for between-date-query.sql)
4. Courses exist for that specific college-department combination
5. Courses have instructors assigned

### Fewer Results Than Expected
**Issue**: Missing some expected courses
**Possible Causes**:
- Courses assigned at college level only (not department level)
- Courses assigned to different department within same college
- Cross-listed courses assigned to multiple departments

**Solution**:
- Run college-only filter to see all courses
- Verify department assignments in Blackboard hierarchy

### Department Name Variations
**Issue**: Department name doesn't match
**Cause**: Department names may have changed or have variations
**Solution**: Run the parent college query first to see exact department names, then copy the exact string

## Finding Valid Department Names

To find the exact department names for your college, run the college-only filter first:

```sql
-- See all departments within a college
SELECT DISTINCT
    SPLIT_PART(ih.hierarchy_name_seq, '||', 5) as department
FROM ...
WHERE SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'Your College Name'
ORDER BY department;
```
