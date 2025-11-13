# Show Details of AIDA-Generated Items

## Queries
- `query.sql`: Detailed list of every content item created with AI Design Assistant

## Overview

This query provides a comprehensive, item-by-item list of all content created using AI Design Assistant (AIDA). Each row represents one AI-generated content item with full details including creator, course, timestamps, and modification status.

**Primary Use Cases:**
- Deep-dive analysis of specific AI-generated content
- Quality review of AI-assisted course materials
- Identify specific items for case studies
- Support AI usage audits
- Understand AI content patterns

## Output Columns

| Column | Description |
|--------|-------------|
| `item_id` | Unique identifier for the content item |
| `item_name` | Name/title of the content item |
| `item_type` | Type of content (assignment, document, discussion, etc.) |
| `course_name` | Course containing the item |
| `creator_name` | Person who created the item with AIDA |
| `created_time` | When the item was created |
| `modified_time` | When the item was last modified |
| `modification_status` | 'Modified' or 'Unmodified' |
| `term` | Academic term (if available) |
| `college` | College/department (if available) |

## Key Features

- **Item-Level Detail**: Most granular AIDA data available
- **Full Context**: Course, creator, time, type
- **Modification Tracking**: See if item was personalized
- **Searchable**: Can filter by any field

