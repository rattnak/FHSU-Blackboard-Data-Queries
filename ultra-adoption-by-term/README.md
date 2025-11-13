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

