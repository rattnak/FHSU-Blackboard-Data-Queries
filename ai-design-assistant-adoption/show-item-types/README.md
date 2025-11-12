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

## Performance Tips

**Estimated Execution Time**: 5-8 seconds

**Warehouse Sizing**: Small - Sufficient

## Analysis Examples

### Most Popular AI Content Types
```sql
SELECT
    item_type,
    total_items,
    distinct_courses,
    distinct_creators,
    ROUND(100.0 * items_modified / total_items, 1) as percent_modified,
    ROUND(total_items * 1.0 / distinct_creators, 1) as items_per_creator
ORDER BY total_items DESC
```

### Content Types with High Personalization
```sql
WHERE items_modified >= total_items * 0.8  -- 80%+ modified
ORDER BY total_items DESC
```

### Content Types Rarely Personalized
```sql
WHERE items_unmodified >= total_items * 0.5  -- 50%+ unmodified
ORDER BY total_items DESC
```

### Calculate Adoption Breadth
```sql
SELECT
    item_type,
    total_items,
    distinct_creators,
    CASE
        WHEN distinct_creators >= 20 THEN 'Widely Adopted'
        WHEN distinct_creators >= 10 THEN 'Moderately Adopted'
        WHEN distinct_creators >= 5 THEN 'Emerging'
        ELSE 'Niche'
    END as adoption_level
ORDER BY distinct_creators DESC
```

## Use Cases by Role

### Faculty Development
- Target training to popular content types
- Develop type-specific AI guidance
- Share best practices by content type
- Plan content-type workshops

### Instructional Designers
- Understand AI use patterns
- Support content type-specific quality
- Share exemplars by type
- Develop templates and guides

### Educational Technology
- Track AI tool capabilities
- Prioritize support for popular types
- Identify gaps in AI usage
- Report on AI effectiveness

### Academic Leadership
- Understand AI integration patterns
- Report on AI adoption breadth
- Support strategic AI planning
- Monitor teaching innovation

## Strategic Insights

### High-Volume, High-Modification (Good Pattern)
```sql
WHERE total_items >= 50
  AND items_modified >= total_items * 0.7
```

**Interpretation**: Instructors find AI helpful for these types and personalize thoughtfully.

**Example**: "Discussions have 200 AI-generated items with 85% modified - great use case!"

### High-Volume, Low-Modification (Needs Attention)
```sql
WHERE total_items >= 50
  AND items_modified < total_items * 0.3
```

**Interpretation**: Heavy AI use but little personalization - may need quality review.

**Action**: Provide guidance on personalizing this content type.

### Low-Volume Types (Explore Why)
```sql
WHERE total_items < 10
ORDER BY item_type
```

**Questions**:
- Is AI not effective for these types?
- Do instructors not know they can use AI for this?
- Are these content types less commonly used overall?

## Professional Development Planning

### Workshop Ideas Based on Data

**If Discussions are Popular**:
```markdown
Workshop: "Using AI to Create Engaging Discussion Prompts"
- Review most-used discussion prompts
- Demonstrate personalization techniques
- Share high-quality examples
- Practice AI prompt engineering
```

**If Assignments are Common**:
```markdown
Workshop: "AI-Assisted Assignment Design"
- Generate assignment drafts with AI
- Personalize for course context
- Align with learning objectives
- Maintain academic rigor
```

**If Rubrics are Emerging**:
```markdown
Session: "Leveraging AI for Rubric Development"
- Introduce AI rubric capabilities
- Show examples and customization
- Discuss alignment with outcomes
- Support rubric quality
```

## Visualizations

### Bar Chart: Items by Type
- X-axis: Content Type
- Y-axis: Total Items
- Color: Modified vs. Unmodified (stacked)
- Shows volume and personalization

### Bubble Chart: Adoption Pattern
- X-axis: Total Items (volume)
- Y-axis: Distinct Creators (breadth)
- Bubble Size: Percent Modified (quality)
- Shows holistic view

### Heatmap: Type × Modification
- Rows: Content Types
- Columns: Modified, Unmodified, Total
- Color Intensity: Count
- Shows patterns at a glance

## Reporting Template

```markdown
# AI Design Assistant: Content Type Analysis

## Most Popular AI Use Cases
1. **[Type 1]**: [N] items created by [M] instructors
   - Modification Rate: [X]%
   - Use: [Description of how it's used]

2. **[Type 2]**: [N] items created by [M] instructors
   - Modification Rate: [X]%
   - Use: [Description]

3. **[Type 3]**: [N] items created by [M] instructors
   - Modification Rate: [X]%
   - Use: [Description]

## Emerging Use Cases
- [Type A]: [N] items, [M] instructors
- [Type B]: [N] items, [M] instructors

## Recommendations
1. **Expand Support**: Focus training on [popular types]
2. **Quality Review**: [Types with low modification] need guidance
3. **Promote Awareness**: [Under-utilized types] could be useful
4. **Celebrate Success**: [Types with high quality use]

## Training Opportunities
- [Specific workshop ideas based on data]
```

## Content Quality by Type

### Review Checklist

For each content type, consider:

**Assignments**
- ✓ Clear instructions?
- ✓ Appropriate for course level?
- ✓ Aligned with learning objectives?
- ✓ Personalized to instructor's pedagogy?

**Discussions**
- ✓ Thought-provoking prompts?
- ✓ Relevant to course content?
- ✓ Appropriate depth?
- ✓ Instructor's voice evident?

**Assessments**
- ✓ Academically rigorous?
- ✓ Appropriate difficulty?
- ✓ Fair and clear?
- ✓ Aligned with course objectives?

## Related Queries

- **show-details-of-items**: See specific items of each type
- **show-aida-usage-by-creator**: See which creators use which types
- **show-aida-usage-by-course**: Course-level patterns
- **show-aida-usage-by-term**: How types change over time

## Best Practices

1. **Understand Context**: Different types serve different purposes
2. **Support Quality**: Provide type-specific guidance
3. **Share Examples**: Show effective use of each type
4. **Track Trends**: Monitor which types grow/decline
5. **Avoid Blanket Rules**: Appropriate use varies by type
6. **Celebrate Innovation**: Recognize creative use of AI
7. **Maintain Standards**: Quality expectations regardless of AI use
8. **Support Learning**: Focus on AI as pedagogical tool
