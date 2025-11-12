# Ultra Course Design Adoption Since Date

## Queries
- `query.sql`: Track courses created in Ultra mode since a specific date (template)

## Overview

This query shows all courses created in Ultra or Preview design mode since a specified date. It's a template query where you replace `{date}` with your desired start date to analyze Ultra adoption in a specific time window.

**Primary Use Cases:**
- Track new course creation in Ultra mode
- Monitor recent Ultra adoption
- Measure impact of training initiatives
- Report on conversion projects
- Track post-migration Ultra usage

## Design Modes Tracked

Courses with `design_mode` IN ('U', 'P'):
- **U** = Ultra
- **P** = Preview (Ultra with Classic fallback)

## Output Columns

| Column | Description |
|--------|-------------|
| `term` | Term name |
| `start_date` | Course start date |
| `design_mode` | Course design mode (U or P) |
| `course_count` | Number of courses in this mode |

Results grouped by term, start date, and design mode.

## How to Use

### Replace the Date Placeholder

Find this line in the query:
```sql
WHERE start_date >= '{date}'
```

Replace `{date}` with your desired date:
```sql
WHERE start_date >= '2024-01-01'  -- Courses since Jan 1, 2024
WHERE start_date >= '2024-08-01'  -- Courses since Aug 1, 2024
WHERE start_date >= '2025-01-01'  -- Courses since Jan 1, 2025
```

### Common Use Cases

**Track Current Academic Year**:
```sql
WHERE start_date >= '2024-07-01'  -- FY 2024-25
```

**Post-Training Adoption**:
```sql
WHERE start_date >= '2024-09-15'  -- After September training
```

**Recent Quarter**:
```sql
WHERE start_date >= CURRENT_DATE - INTERVAL '90 DAYS'
```

**Post-Migration**:
```sql
WHERE start_date >= '2024-05-01'  -- After migration initiative
```

## Performance Tips

**Estimated Execution Time:**
- Narrow date range: 3-5 seconds
- Wide date range: 8-12 seconds

**Warehouse Sizing:**
- Small: Sufficient

## Analysis Examples

### Count Total Ultra Courses Since Date
```sql
SELECT
    SUM(course_count) as total_ultra_courses
WHERE start_date >= '2024-01-01'
  AND design_mode IN ('U', 'P')
```

### Monthly Ultra Course Creation
```sql
SELECT
    DATE_TRUNC('month', start_date) as month,
    SUM(course_count) as courses_created
WHERE start_date >= '2024-01-01'
GROUP BY month
ORDER BY month
```

### Ultra vs Preview Distribution
```sql
SELECT
    design_mode,
    SUM(course_count) as total,
    ROUND(100.0 * SUM(course_count) / (SELECT SUM(course_count) FROM results), 1) as percentage
GROUP BY design_mode
```

## Measuring Initiative Impact

### Before/After Analysis

**Step 1**: Count courses created BEFORE initiative
```sql
WHERE start_date BETWEEN '2023-08-01' AND '2024-07-31'  -- Year before
```

**Step 2**: Count courses created AFTER initiative
```sql
WHERE start_date >= '2024-08-01'  -- Year after
```

**Step 3**: Compare adoption rates

### Training Impact Example
```markdown
**Ultra Training Initiative**: September 2024

Before Training (Aug 2023 - Aug 2024):
- Total Courses Created: [N]
- Ultra Courses: [X]
- Ultra Percentage: [Y]%

After Training (Sept 2024 - Present):
- Total Courses Created: [N]
- Ultra Courses: [X]
- Ultra Percentage: [Y]%

Impact: [+/-Z]% change in Ultra adoption
```

## Use Cases by Role

### EdTech Leadership
- Measure training ROI
- Track migration progress
- Report on adoption trends
- Plan future initiatives

### Faculty Development
- Demonstrate training impact
- Identify continued training needs
- Celebrate adoption milestones
- Plan follow-up support

### Academic Affairs
- Monitor modernization progress
- Support strategic planning
- Report to leadership
- Track institutional innovation

## Related Queries

- **ultra-adoption-by-term**: Shows adoption across all terms (not date-filtered)
- **filter-virtual-course-by-college**: Includes Ultra filter for virtual courses
- **course-tool-interaction**: Can segment by design mode

## Best Practices

1. **Choose Meaningful Dates**: Align with initiatives, trainings, or fiscal years
2. **Compare Periods**: Use equal time windows for fair comparison
3. **Consider Course Types**: New courses vs. conversions vs. copies
4. **Track Longitudinally**: Run regularly with rolling date window
5. **Combine with Qualitative**: Survey faculty about Ultra experience
6. **Celebrate Wins**: Share positive adoption trends
7. **Support Continued Growth**: Plan ongoing training and support
