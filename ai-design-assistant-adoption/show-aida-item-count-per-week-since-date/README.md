# Show AIDA Item Count Per Week Since Date

## Queries
- `query.sql`: Weekly time-series of AIDA usage since a specified date (template)

## Overview

This query provides a week-by-week breakdown of AI Design Assistant (AIDA) usage since a specified date. It shows how many AI-generated items were created each week, enabling analysis of adoption trends, growth patterns, and the impact of specific events or initiatives.

**Primary Use Cases:**
- Track AIDA adoption growth over time
- Identify adoption acceleration or slowdown
- Measure impact of training initiatives
- Detect usage patterns and seasonality
- Report on AI integration progress

## Template Usage

This is a **template query** - replace `{date}` with your desired start date:

```sql
WHERE created_time >= '{date}'
```

**Examples**:
```sql
WHERE created_time >= '2023-09-18'  -- AIDA launch date
WHERE created_time >= '2024-01-01'  -- Calendar year
WHERE created_time >= '2024-08-01'  -- Academic year
```

## Output Columns

| Column | Description |
|--------|-------------|
| `week_start_date` | First day of the week (typically Monday or Sunday) |
| `week_number` | Week number in the year |
| `aida_items_created` | Number of AI items created during this week |
| `distinct_courses` | Number of courses with AIDA activity this week |
| `distinct_creators` | Number of unique creators using AIDA this week |
| `cumulative_items` | Running total of all AIDA items to date |

## Key Features

- **Weekly Granularity**: More detailed than monthly, less noisy than daily
- **Longitudinal View**: Track trends over months/years
- **Multiple Metrics**: Items, courses, creators per week
- **Cumulative Tracking**: See total adoption growth
- **Event Correlation**: Align with training dates, term starts, etc.

