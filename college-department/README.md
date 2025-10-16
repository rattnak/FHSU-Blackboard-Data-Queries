# Instructor Course Hierarchy Query

## Queries
- `by-term-query.sql`: filter data by term (e.g., S2025)
- `between-date-query.sql`: filter data between specific dates

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
| `instructors` | Comma-separated list of instructor full names |
| `instructor_emails` | Comma-separated list of instructor emails |
| `institutional_hierarchy_level_1` | Top-level institution (may show 'Unknown' if not assigned) |
| `institutional_hierarchy_level_2` | College/secondary unit (may show 'Unknown') |
| `institutional_hierarchy_level_3` | College-level name (may show 'Unknown') |
| `institutional_hierarchy_level_4` | Department-level name (may show 'Unknown') |

## Key Features

- **Filters**: Only includes courses with instructors (`course_role = 'I'`)  
- **Aggregation**: Combines multiple instructors and emails into comma-separated lists  
- **Hierarchy Parsing**: Extracts up to 4 levels from pipe-delimited hierarchy strings (`||`)  
- **Sorting**: Results ordered by course start date and course name  

## Performance Tips

**Recommended Filters:**
- Always filter by term for faster performance  
- Apply specific college or department filters when analyzing subsets  

**Estimated Execution Time:**
- Single term: 5–10 seconds  
- Academic year: 20–40 seconds  
- All courses: 30–60+ seconds  

**Warehouse Sizing:**
- Small: OK for term-level queries  
- Medium/Large: Recommended for full-dataset queries  

## Troubleshooting

### Duplicate Courses
**Issue:** Same course appears multiple times  
**Cause:** Course assigned to multiple hierarchy records  
**Solution:** Add `DISTINCT` in the SELECT clause or filter to the primary hierarchy only  

### Missing Hierarchy (Shows "Unknown")
**Issue:** Hierarchy levels display “Unknown”  
**Cause:** Course not assigned to an institutional hierarchy  
**Solution:**  
- Verify course assignment in LMS / CDM tables  
- Use `LEFT JOIN` instead of `INNER JOIN` to include unmapped courses  

### No Results
**Check:**
1. The term filter matches an existing term (`lt.name = 'S2025'`)  
2. Courses have at least one instructor (`course_role = 'I'`)  
3. Courses are linked to an institutional hierarchy  
