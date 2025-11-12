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

## Performance Tips

**Estimated Execution Time**: 8-12 seconds

**Warehouse Sizing**: Small to Medium

**Note**: This query returns MANY rows (one per AI item), so results can be large.

## Analysis Examples

### Most Common AI-Generated Content Types
```sql
SELECT
    item_type,
    COUNT(*) as item_count,
    COUNT(DISTINCT course_name) as courses_using,
    COUNT(DISTINCT creator_name) as creators_using
GROUP BY item_type
ORDER BY item_count DESC
```

### Recently Created AI Content
```sql
WHERE created_time >= CURRENT_DATE - INTERVAL '30 DAYS'
ORDER BY created_time DESC
```

### Unmodified AI Content (Potential Quality Concern)
```sql
WHERE modification_status = 'Unmodified'
ORDER BY created_time DESC
```

### AI Content by Specific Creator
```sql
WHERE creator_name = 'Dr. Jane Smith'
ORDER BY created_time DESC
```

### AI Content in Specific Course
```sql
WHERE course_name LIKE '%ENGL101%'
ORDER BY item_type, item_name
```

### Find Specific Content Patterns
```sql
WHERE item_name LIKE '%discussion%'
  OR item_name LIKE '%prompt%'
ORDER BY created_time DESC
```

## Use Cases by Role

### Instructional Designers
- Review specific AI-generated content
- Provide feedback on AI use quality
- Identify items needing personalization
- Share exemplar AI-generated content

### Faculty Development
- Develop AI use case studies
- Show examples in training
- Discuss AI content quality
- Support best practices

### Quality Assurance
- Audit AI content appropriateness
- Monitor AI integration quality
- Ensure academic integrity
- Review modification patterns

### Educational Technology
- Understand AI content types
- Support effective AI use
- Track AI tool capabilities
- Identify training needs

## Quality Review Workflow

### Step 1: Identify Unmodified High-Stakes Content
```sql
WHERE modification_status = 'Unmodified'
  AND item_type IN ('Assignment', 'Assessment', 'Quiz')
ORDER BY created_time DESC
```

**Action**: Review for quality and encourage personalization

### Step 2: Find Recently Modified Items (Good Practice)
```sql
WHERE modification_status = 'Modified'
  AND created_time >= CURRENT_DATE - INTERVAL '7 DAYS'
ORDER BY creator_name
```

**Action**: Recognize thoughtful AI use

### Step 3: Analyze Time Between Creation and Modification
```sql
SELECT
    item_name,
    creator_name,
    course_name,
    created_time,
    modified_time,
    DATEDIFF('minute', created_time, modified_time) as minutes_to_modify,
    CASE
        WHEN DATEDIFF('minute', created_time, modified_time) <= 10 THEN 'Quick Edit'
        WHEN DATEDIFF('minute', created_time, modified_time) <= 60 THEN 'Same Session'
        WHEN DATEDIFF('day', created_time, modified_time) = 0 THEN 'Same Day'
        ELSE 'Later Review'
    END as modification_timing
WHERE modification_status = 'Modified'
```

## Content Type Analysis

### Group by Type and Modification
```sql
SELECT
    item_type,
    COUNT(*) as total_items,
    SUM(CASE WHEN modification_status = 'Modified' THEN 1 ELSE 0 END) as modified_count,
    ROUND(100.0 * SUM(CASE WHEN modification_status = 'Modified' THEN 1 ELSE 0 END) / COUNT(*), 1) as percent_modified
GROUP BY item_type
ORDER BY total_items DESC
```

**Insight**: Which content types are most/least likely to be personalized?

### Most Common AI Item Names
```sql
SELECT
    item_name,
    COUNT(*) as occurrences,
    COUNT(DISTINCT course_name) as in_courses
GROUP BY item_name
HAVING COUNT(*) > 1  -- Only duplicates
ORDER BY occurrences DESC
```

**Insight**: Are instructors reusing generic AI-generated names?

## Privacy and Quality Considerations

### Appropriate Uses
- Quality improvement (confidential)
- Professional development (anonymized examples)
- Pattern analysis (aggregated)
- Support for individual creators (with consent)

### Inappropriate Uses
- Public criticism of individuals
- Punitive measures for AI use
- Shaming unmodified content
- Competitive rankings

### Ethical Review Questions
1. Is the AI-generated content appropriately personalized?
2. Does it reflect the instructor's voice and pedagogy?
3. Is it appropriate for the disciplinary context?
4. Does it maintain academic integrity standards?
5. Is student use of AI disclosed appropriately?

## Export and Analysis

### Export for External Analysis
This detailed data is excellent for:
- Excel pivot tables
- Tableau/Power BI dashboards
- Statistical analysis (R, Python)
- Text analysis of item names
- Longitudinal studies

### Combine with Other Data
Join with:
- Student engagement metrics
- Grade data
- Course evaluations
- Retention outcomes

**Research Question**: Does AI-assisted content correlate with student success?

## Related Queries

- **show-item-types**: Aggregated view of content types
- **show-aida-usage-by-creator**: See creator summaries
- **show-aida-usage-by-course**: See course summaries
- **show-aida-usage-by-term**: See temporal patterns

## Best Practices

1. **Protect Privacy**: Use appropriately and confidentially
2. **Support Quality**: Frame findings as improvement opportunities
3. **Celebrate Excellence**: Highlight well-personalized AI content
4. **Provide Examples**: Use anonymized items for training
5. **Track Trends**: Monitor modification rates over time
6. **Respect Faculty**: Honor autonomy in AI tool use
7. **Ethical AI Use**: Ensure alignment with institutional values
8. **Student Transparency**: Encourage disclosure of AI-assisted content
