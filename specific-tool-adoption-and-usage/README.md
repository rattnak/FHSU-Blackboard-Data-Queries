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

