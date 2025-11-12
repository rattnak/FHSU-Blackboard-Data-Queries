# Ultra Course Design Adoption by Term

## Queries
- `query.sql`: Track adoption of Blackboard Ultra course design mode by term

## Overview

This query tracks the adoption of Blackboard's Ultra course design mode over time by counting courses in each design mode (Classic, Ultra, Preview) for each term. This helps monitor the institution's migration from Classic to Ultra course experience.

**Primary Use Cases:**
- Track Ultra migration progress
- Report on course design modernization
- Plan Ultra training and support needs
- Monitor term-by-term adoption trends
- Support strategic planning for Ultra transition

## Blackboard Design Modes

| Mode | Code | Description |
|------|------|-------------|
| **Classic** | C | Traditional Blackboard course experience |
| **Ultra** | U | Modern, responsive Blackboard course experience |
| **Preview** | P | Ultra mode with Classic preview enabled |

**Note**: For adoption tracking, both Ultra (U) and Preview (P) are typically counted as "Ultra" courses.

## Output Columns

| Column | Description |
|--------|-------------|
| `term` | Term name (e.g., "F2024", "S2025") |
| `start_date` | Term start date |
| `end_date` | Term end date |
| `design_mode` | Course design mode (C, U, or P) |
| `course_count` | Number of courses in this mode for this term |

## Key Features

- **Longitudinal Tracking**: Shows adoption trends over multiple terms
- **Mode Breakdown**: Separates Classic, Ultra, and Preview
- **Chronological Order**: Sorted by term start date
- **Simple Aggregation**: Easy to visualize in charts

## Performance Tips

**Estimated Execution Time:**
- All terms: 5-10 seconds

**Warehouse Sizing:**
- Small: Sufficient

**Very Fast Query**: Simple aggregation with minimal joins.

## Analysis Examples

### Calculate Ultra Adoption Percentage by Term
```sql
SELECT
    term,
    start_date,
    SUM(CASE WHEN design_mode IN ('U', 'P') THEN course_count ELSE 0 END) as ultra_courses,
    SUM(course_count) as total_courses,
    ROUND(100.0 * SUM(CASE WHEN design_mode IN ('U', 'P') THEN course_count ELSE 0 END) / SUM(course_count), 1) as ultra_percentage
FROM results
GROUP BY term, start_date
ORDER BY start_date
```

### Show Recent 5 Terms
```sql
WHERE start_date >= CURRENT_DATE - INTERVAL '18 MONTHS'
ORDER BY start_date DESC
```

### Year-Over-Year Comparison
```sql
-- Compare Fall 2024 vs Fall 2023
SELECT
    SUBSTRING(term, 1, 1) as semester,  -- F or S
    SUBSTRING(term, 2) as year,
    SUM(CASE WHEN design_mode IN ('U', 'P') THEN course_count ELSE 0 END) as ultra_courses,
    SUM(course_count) as total_courses
GROUP BY semester, year
ORDER BY year, semester
```

## Visualization Recommendations

### Stacked Bar Chart
- X-axis: Term
- Y-axis: Course count
- Stacked bars: Classic (bottom), Ultra+Preview (top)
- Shows absolute growth and mode distribution

### Line Chart
- X-axis: Term
- Y-axis: Percentage
- Line: Ultra adoption percentage
- Shows trend over time

### Donut Chart (for single term)
- Slices: Classic vs. Ultra+Preview
- Shows current state of adoption

## Typical Adoption Patterns

### Early Stage (0-25% Ultra)
- Most courses still in Classic
- Early adopters experimenting
- Heavy training needed

### Growth Stage (25-75% Ultra)
- Visible momentum
- Mix of modes common
- Support infrastructure building

### Mature Stage (75-100% Ultra)
- Majority in Ultra
- Classic becoming legacy
- Sunset planning for Classic

## Troubleshooting

### Missing Terms
**Issue**: Some terms don't appear
**Cause**: No courses in that term OR term not in system
**Solution**: Verify term exists and has courses

### Unexpected Mode Distribution
**Issue**: All courses showing as one mode
**Possible Causes**:
- Bulk conversion happened
- New term created with default mode
- Data sync issue

### Preview Mode Counts
**Issue**: Many courses in Preview (P) mode
**Explanation**:
- Preview mode allows Ultra with Classic fallback
- Common during transition periods
- Should be counted as "Ultra" for most reporting

## Migration Planning

### Setting Goals
```markdown
Current State:
- Term: Fall 2024
- Ultra Adoption: [X]%
- Classic Courses: [N]

Goals:
- End of Academic Year: [Y]% Ultra
- Courses to Convert: [N]
- Terms Remaining: [T]
- Avg Conversions Needed per Term: [N/T]
```

### Tracking Progress
Run query after each term:
```sql
SELECT
    term,
    ROUND(100.0 * SUM(CASE WHEN design_mode IN ('U', 'P') THEN course_count ELSE 0 END) / SUM(course_count), 1) as ultra_percentage,
    SUM(CASE WHEN design_mode = 'C' THEN course_count ELSE 0 END) as remaining_classic
GROUP BY term
ORDER BY start_date DESC
LIMIT 5
```

## Use Cases by Role

### Academic Technology Leadership
- Monitor migration progress
- Report to executive leadership
- Plan support resources
- Set institutional goals

### Training & Support Teams
- Identify conversion training needs
- Plan professional development
- Allocate support resources
- Celebrate milestones

### Academic Affairs
- Monitor teaching innovation
- Support faculty transition
- Track institutional modernization
- Report to accreditation

### Institutional Research
- Document technological change
- Correlate with student outcomes
- Support strategic planning
- Benchmark against peers

## Reporting Template

```markdown
# Ultra Adoption Report
**Report Date**: [Date]
**Term Reviewed**: [Current Term]

## Current Status
- **Ultra Courses**: [N] ([X]%)
- **Classic Courses**: [N] ([Y]%)
- **Preview Courses**: [N] ([Z]%)

## Trend
- **Previous Term**: [X]% Ultra
- **Change**: [+/-N]% Ultra adoption
- **Trajectory**: [On track / Ahead / Behind] for goal

## Recent Progress
| Term | Ultra % | Classic Courses Remaining |
|------|---------|---------------------------|
| [Term 1] | [X]% | [N] |
| [Term 2] | [X]% | [N] |
| [Term 3] | [X]% | [N] |

## Next Steps
1. [Action item based on data]
2. [Action item based on data]
3. [Action item based on data]
```

## Related Queries

- **ultra-adoption-since-date**: Ultra courses created since a specific date
- **filter-virtual-course-by-college**: Includes design mode filter
- **course-tool-interaction**: Shows tool use by design mode

## Best Practices

1. **Track Regularly**: Run after each term for trends
2. **Set Realistic Goals**: Plan multi-year migration
3. **Celebrate Progress**: Share milestones with community
4. **Support Faculty**: Provide training and resources
5. **Communicate Rationale**: Explain benefits of Ultra
6. **Plan for Holdouts**: Identify courses that can't convert
7. **Document Challenges**: Learn from conversion obstacles
8. **Share Success Stories**: Highlight positive Ultra experiences
9. **Compare to Peers**: Benchmark against similar institutions
10. **Update Strategy**: Adjust plans based on actual adoption rates
