# Show AIDA Usage by Creator

## Queries
- `query.sql`: Show AIDA usage aggregated by content creator (instructor/staff)

## Overview

This query identifies the top users of AI Design Assistant (AIDA) by aggregating how many AI-generated content items each creator has made. This helps identify AI champions, early adopters, and patterns of AI tool adoption across faculty.

**Primary Use Cases:**
- Identify AI adoption leaders
- Recruit peer trainers and mentors
- Recognize innovative faculty
- Understand who is experimenting with AI
- Target support to new AI users

## Output Columns

| Column | Description |
|--------|-------------|
| `creator_name` | Full name of person who created content |
| `total_aida_items` | Total number of items created with AIDA |
| `distinct_courses` | Number of different courses with AIDA usage |
| `items_modified` | Number of items modified after generation |
| `items_unmodified` | Number of items used verbatim |

## Key Features

- **Person-Level Aggregation**: One row per AIDA user
- **Cross-Course View**: Shows usage across all their courses
- **Modification Patterns**: Indicates personalization habits
- **Adoption Depth**: Course count shows breadth of use

