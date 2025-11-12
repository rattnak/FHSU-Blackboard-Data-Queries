# Specific Tool Adoption and Usage Statistics

## Queries
- `query.sql`: System-wide tool adoption and usage statistics across all tracked tools

## Overview

This query provides comprehensive, system-wide statistics for all tracked educational technology tools. It calculates high-level metrics including course adoption, content creation, access rates, user engagement, and time spent for each tool.

**Primary Use Cases:**
- Executive reporting on technology adoption
- ROI analysis for tool investments
- Vendor reporting and contract negotiations
- Strategic planning for EdTech initiatives
- Longitudinal tracking of tool adoption trends

## Tracked Tools
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## Output Columns

| Column | Description |
|--------|-------------|
| `tool_name` | Name of the educational technology tool |
| `distinct_courses` | Number of unique courses using the tool |
| `distinct_items_created` | Number of unique content items created |
| `items_accessed_percentage` | Percentage of created items that were accessed |
| `user_engagement` | Total number of user interactions/accesses |
| `time_spent_minutes` | Total time users spent with the tool (in minutes) |

## Key Metrics Explained

### Distinct Courses
Total number of unique courses that have integrated the tool.
- **Interpretation**: Measures adoption breadth

### Distinct Items Created
Number of unique content items/activities created with the tool.
- **Interpretation**: Measures implementation depth
- **Example**: Each YellowDig community = 1 item, each GoReact video = 1 item

### Items Accessed Percentage
```sql
(Items Accessed / Items Created) * 100
```
- **Interpretation**: Measures utilization of created content
- **High %**: Content is actively used by students
- **Low %**: Content created but not accessed (may be unpublished/archived)

### User Engagement
Total number of user interactions (clicks, views, submissions) with the tool.
- **Interpretation**: Measures activity volume
- **Note**: Definition varies by tool (e.g., each click vs. each session)

### Time Spent (Minutes)
Total time users have spent actively engaged with the tool.
- **Interpretation**: Measures depth of engagement
- **Note**: Tracking method varies by tool; not all tools report accurate time

## Performance Tips

**Estimated Execution Time:**
- All tools, all time: 30-45 seconds

**Warehouse Sizing:**
- Medium: Recommended minimum
- Large: Optimal

**Why Slower?**
- Aggregates across entire database
- No time filters (all historical data)
- Complex calculations for percentages and time

## Analysis Examples

### Rank Tools by Adoption
```sql
SELECT
    tool_name,
    distinct_courses,
    distinct_items_created
ORDER BY distinct_courses DESC
```

### Identify Most Engaging Tools
```sql
SELECT
    tool_name,
    user_engagement,
    time_spent_minutes,
    ROUND(time_spent_minutes / NULLIF(user_engagement, 0), 2) as avg_minutes_per_engagement
ORDER BY user_engagement DESC
```

### Find Tools with Low Utilization
```sql
SELECT
    tool_name,
    distinct_items_created,
    items_accessed_percentage
WHERE items_accessed_percentage < 50
ORDER BY items_accessed_percentage ASC
```

### Calculate ROI Metrics
```sql
SELECT
    tool_name,
    distinct_courses,
    user_engagement,
    time_spent_minutes,
    -- Add your tool cost
    distinct_courses * 100 as estimated_cost_per_course,  -- Example
    ROUND(user_engagement / NULLIF(distinct_courses, 0), 0) as engagements_per_course
```

## Executive Summary Template

```markdown
# EdTech Tool Adoption Report
**Date Range**: [All Time / Specific Period]
**Tools Tracked**: 8 platforms

## Adoption Overview
- **Most Adopted Tool**: [Tool] with [N] courses
- **Highest Engagement**: [Tool] with [N] interactions
- **Most Time Spent**: [Tool] with [N] hours total

## Key Findings
1. [Tool Name]: [Courses] courses, [%] access rate, [N] total hours
2. [Tool Name]: [Courses] courses, [%] access rate, [N] total hours
3. [Tool Name]: [Courses] courses, [%] access rate, [N] total hours

## Recommendations
- Expand support for [high-adoption tools]
- Investigate low access rates for [tools with <50%]
- Consider renewal/cancellation based on usage data
```

## Troubleshooting

### Zero Values for Time Spent
**Issue**: Some tools show 0 minutes
**Cause**: Tool doesn't track time or time tracking not enabled
**Solution**: This is expected for some tools; focus on engagement metrics

### Low Access Percentages
**Issue**: Many tools showing <50% access
**Cause**:
- Archived courses with unpublished content
- Content created but course not started
- Draft items not yet released

**Solution**: This is common; consider filtering to active terms for more accurate rates

### Unexpected High Numbers
**Issue**: Numbers seem very large
**Cause**: Includes ALL historical data (not just current term)
**Solution**: This is expected; query shows cumulative all-time statistics

## Adding Time Filters

To limit to specific time period, add WHERE clause:
```sql
WHERE interaction_date >= '2024-01-01'
  AND interaction_date < '2025-01-01'
```

**Note**: You'll need to modify the query to include date filters from the appropriate tables.

## Vendor Reporting

This query is ideal for vendor reporting:

### Annual Review Template
```
Tool: [Tool Name]
Review Period: [Year]

Adoption Metrics:
- Courses Using Tool: [distinct_courses]
- Content Items Created: [distinct_items_created]
- Utilization Rate: [items_accessed_percentage]%

Engagement Metrics:
- Total Interactions: [user_engagement]
- Total Time Spent: [time_spent_minutes] minutes ([hours] hours)
- Average per Course: [engagement/courses]

ROI Assessment:
- Annual Cost: $[X]
- Cost per Course: $[X/courses]
- Cost per Engagement: $[X/engagement]

Recommendation: [Renew / Expand / Reconsider / Cancel]
```

## Use Cases by Role

### Executive Leadership
- Strategic technology investment decisions
- Board reporting on innovation
- Budget justification
- Institutional positioning

### CIO / EdTech Director
- Tool portfolio management
- Contract negotiations with vendors
- Strategic planning for technology
- Resource allocation

### Academic Affairs
- Innovation tracking across institution
- Support for teaching effectiveness
- Accreditation documentation
- Faculty support planning

### Budget / Finance
- ROI analysis
- Cost-benefit assessment
- Renewal decision support
- Budget forecasting

## Related Queries

- **course-tool-interaction**: Course-level tool usage details
- **filter-specific-tool-interaction**: Single tool, course-level data
- **filter-all-tool-interaction-by-college**: College-level breakdown
- **ultra-adoption-by-term**: Track Ultra course design adoption

## Best Practices

1. **Run Annually**: Track year-over-year growth
2. **Before Renewals**: Generate reports 60-90 days before contract renewals
3. **Combine with Qualitative**: Add faculty/student feedback to quantitative data
4. **Set Benchmarks**: Establish institutional adoption goals
5. **Compare Tools**: Identify which tools deliver most value
6. **Share Success**: Communicate adoption wins to community
7. **Support Growth**: Invest in training for high-potential tools
8. **Sunset Low-Use Tools**: Consider discontinuing unused tools
9. **Track Trends**: Monitor whether adoption is growing or declining
10. **Validate with Vendors**: Cross-check data with vendor analytics when possible
