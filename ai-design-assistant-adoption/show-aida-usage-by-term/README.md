# Show AIDA Usage by Term

## Queries
- `query.sql`: Aggregate AIDA usage statistics grouped by academic term

## Overview

This query groups AI Design Assistant (AIDA) usage by academic term, showing how many courses and content items utilized AIDA in each term. This helps track adoption trends over time.

**Primary Use Cases:**
- Monitor AIDA adoption growth term-by-term
- Identify terms with high/low AI usage
- Report on AI tool trends over time
- Plan future professional development based on trends
- Measure impact of training initiatives

## Output Columns

| Column | Description |
|--------|-------------|
| `term` | Term name (e.g., "F2024", "S2025") |
| `distinct_courses` | Number of unique courses using AIDA this term |
| `total_aida_items` | Total number of content items created with AIDA |
| `items_modified` | Number of items modified after AI generation |
| `items_unmodified` | Number of items used verbatim from AIDA |

## Key Features

- **Term Grouping**: Aggregates all AIDA usage by term
- **Modification Tracking**: Shows whether instructors personalize AI content
- **Longitudinal View**: Easy to see term-by-term trends
- **Course Count**: Distinct courses, not total items

## Performance Tips

**Estimated Execution Time**: 5-8 seconds

**Warehouse Sizing**: Small - Sufficient

## Analysis Examples

### AIDA Adoption Trend
```sql
SELECT
    term,
    distinct_courses,
    total_aida_items,
    ROUND(100.0 * items_modified / total_aida_items, 1) as percent_modified
ORDER BY term
```

### Calculate Growth Rate
```sql
WITH term_data AS (
    SELECT
        term,
        distinct_courses,
        LAG(distinct_courses) OVER (ORDER BY term) as prev_term_courses
    FROM results
)
SELECT
    term,
    distinct_courses,
    prev_term_courses,
    distinct_courses - prev_term_courses as growth,
    ROUND(100.0 * (distinct_courses - prev_term_courses) / NULLIF(prev_term_courses, 0), 1) as growth_percent
```

### Identify Peak Usage Terms
```sql
ORDER BY total_aida_items DESC
LIMIT 5
```

## Visualization Recommendations

### Line Chart: Adoption Over Time
- X-axis: Term
- Y-axis: Distinct Courses (or Total Items)
- Shows adoption trajectory

### Stacked Bar: Modified vs. Unmodified
- X-axis: Term
- Y-axis: Count
- Stacked: Modified (top) + Unmodified (bottom)
- Shows personalization patterns

## Use Cases by Role

### Educational Technology Leadership
- Report AI adoption to leadership
- Track return on AI tool investment
- Plan future AI initiatives

### Faculty Development
- Identify terms for targeted training
- Measure training impact
- Plan follow-up support

### Academic Affairs
- Monitor teaching innovation
- Report on AI integration
- Support strategic planning

## Related Queries

- **show-aida-usage-by-course**: See which specific courses in each term
- **show-aida-item-count-per-week-since-date**: More granular time trends
- **show-aida-usage-by-node**: See which colleges use AIDA most per term
