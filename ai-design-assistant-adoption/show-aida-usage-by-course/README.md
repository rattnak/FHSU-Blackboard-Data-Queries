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

## Performance Tips

**Estimated Execution Time**: 5-8 seconds

**Warehouse Sizing**: Small - Sufficient

## Analysis Examples

### Top 20 Courses by AIDA Usage
```sql
SELECT
    course_name,
    instructor,
    term,
    aida_item_count,
    ROUND(100.0 * items_modified / aida_item_count, 1) as percent_modified
ORDER BY aida_item_count DESC
LIMIT 20
```

### Courses Using AIDA Extensively
```sql
WHERE aida_item_count > 10  -- More than 10 AI items
ORDER BY aida_item_count DESC
```

### Courses with All Modified Content (Thoughtful Use)
```sql
WHERE items_modified = aida_item_count
ORDER BY aida_item_count DESC
```

### Courses with Unmodified Content (May Need Guidance)
```sql
WHERE items_unmodified > 0
  AND items_modified = 0  -- No personalization
ORDER BY aida_item_count DESC
```

### AIDA Usage by Specific Term
```sql
WHERE term = 'S2025'
ORDER BY aida_item_count DESC
```

## Use Cases by Role

### Instructional Designers
- Identify courses for AI integration reviews
- Support instructors with high AI usage
- Share exemplar AI-assisted course designs
- Offer personalization guidance

### Faculty Development
- Recruit AI champions for peer training
- Develop AI use case studies
- Plan workshops featuring real examples
- Connect faculty using AI

### Department Chairs
- Monitor AI adoption in department
- Recognize innovative faculty
- Understand AI integration patterns
- Support departmental AI literacy

### Educational Technology
- Track AI tool effectiveness
- Identify support needs
- Share best practices
- Plan targeted training

## Identifying Champions

### High-Use, High-Modification (Ideal Pattern)
```sql
WHERE aida_item_count >= 5
  AND items_modified >= aida_item_count * 0.8  -- 80%+ modified
ORDER BY aida_item_count DESC
```

**Action**: Invite for case study, peer training, or presentation

### High-Use, Low-Modification (Needs Guidance)
```sql
WHERE aida_item_count >= 5
  AND items_modified < aida_item_count * 0.3  -- <30% modified
```

**Action**: Offer support on personalizing AI content

## Related Queries

- **show-aida-usage-by-creator**: See which instructors across all their courses
- **show-details-of-items**: See specific items within courses
- **show-item-types**: Understand what content types are being created
- **show-aida-usage-by-term**: See term-by-term trends
