# Show AIDA Usage by Course

## Queries
- `query.sql`: Show AIDA usage aggregated by individual course

## Overview

This query lists all courses that have used AI Design Assistant (AIDA), showing how many AI-generated content items exist in each course. This helps identify which specific courses are integrating AI tools.

**Primary Use Cases:**
- Identify courses with high AI integration
- Find AI adoption champions for case studies
- Support targeted course reviews
- Share exemplar courses with peers
- Connect instructors using AI

## Output Columns

| Column | Description |
|--------|-------------|
| `course_name` | Full display name of the course |
| `aida_item_count` | Number of content items created with AIDA |
| `items_modified` | Number of items modified after generation |
| `items_unmodified` | Number of items used verbatim |
| `term` | Term name (if available) |
| `instructor` | Course instructor name (if available) |

## Key Features

- **Course-Level Detail**: One row per course with AIDA usage
- **Item Count**: Total AI-generated items per course
- **Modification Insight**: Shows personalization patterns
- **Context**: Includes term and instructor for follow-up

