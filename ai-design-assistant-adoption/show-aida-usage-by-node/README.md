# Show AIDA Usage by Node (College/Department)

## Queries
- `query.sql`: Show AIDA usage aggregated by organizational node (college/department)

## Overview

This query breaks down AI Design Assistant (AIDA) usage by organizational unit (college or department), showing which parts of the institution are adopting AI tools most actively.

**Primary Use Cases:**
- Compare AI adoption across colleges/departments
- Identify units needing AI support
- Recognize colleges with high AI innovation
- Plan college-specific training
- Report to college deans

## Output Columns

| Column | Description |
|--------|-------------|
| `node_name` | Organizational unit name (college or department) |
| `distinct_courses` | Number of courses using AIDA in this unit |
| `total_aida_items` | Total AI-generated items in this unit |
| `distinct_creators` | Number of unique faculty using AIDA |
| `items_modified` | Number of items modified after generation |
| `items_unmodified` | Number of items used verbatim |

## Key Features

- **Organizational Breakdown**: Shows adoption by college/department
- **Multiple Metrics**: Courses, items, and users
- **Modification Tracking**: Personalization patterns by unit
- **Comparative**: Easy to compare across units

