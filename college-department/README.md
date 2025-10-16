# Instructor Course Hierarchy Query

## Overview

This query retrieves a list of all courses offered in a specific term (`S2025`), including their instructors, start dates, and institutional hierarchy levels (e.g., College, Department). It is used to analyze instructor assignments and course distribution across academic units.

**Primary Use Cases:**
- Generate instructor course assignment reports  
- View course offerings by academic hierarchy  
- Audit instructor-to-course mappings  
- Validate institutional hierarchy data consistency  

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique course identifier in the LMS |
| `course_name` | Full display name of the course |
| `design_mode` | Course Design Mode {'C': 'Classic', 'U': 'Ultra', 'P': 'Preview'} |
| `start_date` | Course start date |
| `term` | Term name (e.g., "S2025") |
| `instructor_count` | Number of instructors assigned |
| `instructors` | Comma-separated list of instructor names |
| `instructor_emails` | Comma-separated list of instructor emails|
| `institutional_hierarchy_level_1` | Fort Hays State University |
| `institutional_hierarchy_level_2` | FHSU - Academic Colleges and Departments |
| `institutional_hierarchy_level_3` | College Level |
| `institutional_hierarchy_level_4` | Department Level |

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

**Estimated Execution Time:**
- Single term: 5-10 seconds
- Academic year: 20-40 seconds
- All courses: 30-60+ seconds

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
