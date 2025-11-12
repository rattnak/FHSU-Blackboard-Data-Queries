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

## Performance Tips

**Estimated Execution Time**: 8-12 seconds

**Warehouse Sizing**: Small to Medium

**Note**: Longer date ranges produce more rows but query remains fast.

## Analysis Examples

### Basic Trend Visualization
```sql
SELECT
    week_start_date,
    aida_items_created,
    distinct_creators,
    cumulative_items
WHERE week_start_date >= '2024-01-01'
ORDER BY week_start_date
```

### Identify Peak Usage Weeks
```sql
ORDER BY aida_items_created DESC
LIMIT 10
```

### Calculate Week-Over-Week Growth
```sql
WITH weekly AS (
    SELECT
        week_start_date,
        aida_items_created,
        LAG(aida_items_created) OVER (ORDER BY week_start_date) as prev_week
    FROM results
)
SELECT
    week_start_date,
    aida_items_created,
    prev_week,
    aida_items_created - prev_week as growth,
    ROUND(100.0 * (aida_items_created - prev_week) / NULLIF(prev_week, 0), 1) as growth_percent
ORDER BY week_start_date
```

### Identify Sustained Growth Periods
```sql
SELECT
    week_start_date,
    aida_items_created,
    AVG(aida_items_created) OVER (
        ORDER BY week_start_date
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) as four_week_avg
ORDER BY week_start_date
```

### Compare Academic Terms
```sql
SELECT
    CASE
        WHEN week_start_date BETWEEN '2024-08-01' AND '2024-12-31' THEN 'Fall 2024'
        WHEN week_start_date BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Spring 2025'
        ELSE 'Other'
    END as term,
    SUM(aida_items_created) as total_items,
    AVG(aida_items_created) as avg_per_week,
    MAX(aida_items_created) as peak_week
GROUP BY term
ORDER BY term
```

## Visualizations

### Line Chart: Adoption Over Time
- X-axis: Week Start Date
- Y-axis: AIDA Items Created
- Line: Weekly counts
- Trend Line: Show overall trajectory
- **Best for**: Seeing trends and patterns

### Area Chart: Cumulative Growth
- X-axis: Week Start Date
- Y-axis: Cumulative Items
- Area: Filled cumulative total
- **Best for**: Showing total growth

### Dual-Axis Chart: Items and Creators
- X-axis: Week Start Date
- Y-axis 1 (Left): AIDA Items (bars)
- Y-axis 2 (Right): Distinct Creators (line)
- **Best for**: Comparing volume vs. breadth

## Identifying Inflection Points

### Sudden Increases (Positive Events)
```sql
WHERE aida_items_created > (
    SELECT AVG(aida_items_created) * 1.5
    FROM results
)
ORDER BY week_start_date
```

**Questions to Ask**:
- What training happened that week?
- Did a term start?
- Was there a teaching workshop?
- Did we send communications about AI?

### Sudden Decreases (Investigate)
```sql
WHERE aida_items_created < (
    SELECT AVG(aida_items_created) * 0.5
    FROM results
)
AND week_start_date >= '2024-01-01'
ORDER BY week_start_date
```

**Possible Causes**:
- Term break / winter break
- Summer slow-down
- Technical issues
- Competing initiatives

## Measuring Initiative Impact

### Template for Event Analysis

**Event**: AI Training Workshop on [Date]

```sql
-- 4 weeks before
SELECT AVG(aida_items_created) as avg_before
FROM results
WHERE week_start_date BETWEEN '[date - 4 weeks]' AND '[date - 1 week]'

-- 4 weeks after
SELECT AVG(aida_items_created) as avg_after
FROM results
WHERE week_start_date BETWEEN '[date]' AND '[date + 4 weeks]'

-- Calculate impact
-- Impact = (avg_after - avg_before) / avg_before * 100
```

### Longitudinal Cohort Analysis
Track first-time AIDA users each week:

```sql
-- Requires modification to track first-ever use per creator
WITH first_use AS (
    SELECT
        creator_name,
        MIN(week_start_date) as first_week
    FROM detailed_items
    GROUP BY creator_name
)
SELECT
    first_week,
    COUNT(*) as new_aida_users
FROM first_use
GROUP BY first_week
ORDER BY first_week
```

## Seasonal Patterns

### Expected Patterns

**Academic Calendar**:
- **High**: Weeks before term starts (course prep)
- **High**: Early in term (content creation)
- **Medium**: Mid-term
- **Low**: End of term (grading, not creating)
- **Very Low**: Between terms

**Calendar Year**:
- **Low**: Late December / early January (holidays)
- **Low**: Summer (if summer courses are fewer)
- **High**: August (fall prep)

### Adjust Expectations
Compare to known institutional patterns to contextualize data.

## Reporting Template

```markdown
# AI Design Assistant: Weekly Adoption Trends

**Analysis Period**: [Start Date] to [End Date]
**Total Weeks**: [N]

## Summary Statistics
- **Total AI Items Created**: [N]
- **Average per Week**: [N]
- **Peak Week**: [Date] with [N] items
- **Unique Creators**: [N] total

## Growth Trend
- **Overall Trend**: [Growing / Stable / Declining]
- **Growth Rate**: [X]% [increase/decrease] compared to [period]

## Key Observations
1. [Observation about trend]
2. [Observation about events]
3. [Observation about patterns]

## Recommendations
1. [Action based on trend]
2. [Action based on patterns]
3. [Action based on goals]
```

## Use Cases by Role

### Educational Technology Leadership
- Report adoption progress to leadership
- Demonstrate ROI on AI initiatives
- Plan future AI support
- Justify resource allocation

### Faculty Development
- Measure training effectiveness
- Plan timing of future workshops
- Identify optimal training periods
- Track sustained adoption

### Institutional Research
- Document innovation adoption
- Support strategic planning
- Benchmark against peers
- Research adoption patterns

### Academic Affairs
- Monitor teaching innovation
- Report to board/president
- Support AI strategy
- Guide policy development

## Related Queries

- **show-aida-usage-by-term**: Coarser (term-level) time grouping
- **show-aida-usage-by-creator**: See who's using AI each week
- **show-aida-usage-by-node**: Compare colleges over time
- **show-item-types**: See what content types each week

## Best Practices

1. **Choose Meaningful Start Date**: AIDA launch or institutional initiative
2. **Track Regularly**: Update dashboard weekly or monthly
3. **Contextualize**: Note term starts, breaks, training events
4. **Share Trends**: Communicate progress to community
5. **Celebrate Milestones**: Mark 100th, 500th, 1000th item
6. **Adjust Strategy**: Respond to slowdowns with support
7. **Long View**: Don't overreact to single-week fluctuations
8. **Compare Fairly**: Account for seasonal patterns
