# Show AIDA Item Types

## Queries
- `query.sql`: Breakdown of AI-generated content by content type

## Overview

This query categorizes all AI Design Assistant (AIDA) generated content by type (e.g., assignments, discussions, documents), showing which types of content are most commonly created with AI assistance.

**Primary Use Cases:**
- Understand what instructors are using AI to create
- Identify most popular AI use cases
- Plan targeted training for specific content types
- Compare AI use across content types
- Report on AI tool effectiveness

## Output Columns

| Column | Description |
|--------|-------------|
| `item_type` | Type/category of content item |
| `total_items` | Total number of items of this type created with AIDA |
| `distinct_courses` | Number of courses using AIDA for this content type |
| `distinct_creators` | Number of unique creators using AIDA for this type |
| `items_modified` | Number of items of this type that were modified |
| `items_unmodified` | Number of items used verbatim |

## Common Content Types

### Expected Types (may vary by Blackboard version)
- **Assignment** - Assignments and projects
- **Document** - Content pages, files, links
- **Discussion** - Discussion boards and prompts
- **Assessment** / **Quiz** / **Test** - Quizzes and exams
- **Rubric** - Grading rubrics
- **Module** - Course modules/folders
- **Announcement** - Course announcements
- **Learning Objective** - Learning outcomes

## Key Features

- **Type-Level Aggregation**: One row per content type
- **Usage Breadth**: Shows how many courses/creators use each type
- **Modification Patterns**: Personalization by content type
- **Comparative**: Easy to compare across types

