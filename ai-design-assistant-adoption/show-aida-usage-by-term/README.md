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

