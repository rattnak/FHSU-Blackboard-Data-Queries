# All College Department Query

## Overview

This query retrieves a comprehensive list of courses with their assigned instructors and organizational hierarchy information (colleges and departments).

**Primary Use Cases:**
- Generate departmental course rosters
- Identify course distribution across colleges and departments
- Create instructor assignment reports
- Audit course-to-organizational unit mappings

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview' |
| `start_date` | Course start date |
| `term` | Term name (e.g., "Fall 2024") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | University level |
| `institutional_hierarchy_level_2` | College level |
| `institutional_hierarchy_level_3` | Department level |
| `institutional_hierarchy_level_4` | Program/sub-department level |

## Key Features

- **Filters**: Only includes courses with instructors (role 'I')
- **Aggregation**: Combines multiple instructors into comma-separated lists
- **Hierarchy Parsing**: Extracts 4 levels from pipe-delimited hierarchy strings
- **Sorting**: Results ordered alphabetically by course name

## Performance Tips

**Recommended Filters:**
- Always filter by term for better performance
- Use specific college/department filters when possible

**Estimated Execution Time:**
- Single term: 5-10 seconds
- Academic year: 20-40 seconds
- All courses: 30-60+ seconds

**Warehouse Sizing:**
- Small: OK with term filters
- Medium/Large: Recommended for full dataset

## Troubleshooting

### Duplicate Courses
**Issue**: Same course appears multiple times  
**Cause**: Course assigned to multiple hierarchies  
**Solution**: Add `DISTINCT` to main SELECT or filter to primary hierarchy only

### Missing Hierarchy (Shows "Unknown")
**Issue**: Hierarchy levels show as "Unknown"  
**Cause**: Course not assigned to organizational hierarchy  
**Solution**: 
- Verify course assignment in Blackboard
- Use LEFT JOIN instead of INNER JOIN for hierarchy tables if you want to include unassigned courses

### No Results
**Check**:
1. Courses have instructors assigned
2. Courses are mapped to organizational hierarchy
3. Term filter isn't too restrictive
