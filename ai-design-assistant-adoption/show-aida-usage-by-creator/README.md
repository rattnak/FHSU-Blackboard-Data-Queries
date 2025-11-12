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

## Performance Tips

**Estimated Execution Time**: 5-8 seconds

**Warehouse Sizing**: Small - Sufficient

## Analysis Examples

### Top 25 AIDA Users
```sql
SELECT
    creator_name,
    total_aida_items,
    distinct_courses,
    ROUND(100.0 * items_modified / total_aida_items, 1) as percent_modified,
    ROUND(total_aida_items * 1.0 / distinct_courses, 1) as items_per_course
ORDER BY total_aida_items DESC
LIMIT 25
```

### Power Users (High Volume, Multiple Courses)
```sql
WHERE total_aida_items >= 20
  AND distinct_courses >= 3
ORDER BY total_aida_items DESC
```

### Thoughtful Users (High Modification Rate)
```sql
WHERE total_aida_items >= 5
  AND items_modified >= total_aida_items * 0.8  -- 80%+ modified
ORDER BY total_aida_items DESC
```

### New/Experimental Users
```sql
WHERE total_aida_items BETWEEN 1 AND 5
ORDER BY creator_name
```

## Use Cases by Role

### Faculty Development
- Recruit AI champions for workshops
- Create peer mentor network
- Develop AI use case studies
- Plan targeted training

### Educational Technology
- Identify support needs
- Connect AI users for community
- Share best practices
- Celebrate innovation

### Department Chairs
- Recognize faculty innovation
- Identify departmental AI leaders
- Encourage AI literacy
- Support strategic adoption

### Academic Affairs
- Track faculty engagement with AI
- Monitor innovation culture
- Report on teaching modernization
- Support AI policy development

## Recognition and Support Strategies

### AI Champions (Invite for Leadership Roles)
```sql
WHERE total_aida_items >= 30
  OR (total_aida_items >= 15 AND items_modified >= total_aida_items * 0.7)
```

**Recognition Ideas**:
- Invite to present at teaching symposium
- Feature in faculty newsletter
- Nominate for teaching innovation award
- Recruit for AI advisory committee

### Growing Users (Encourage Continued Growth)
```sql
WHERE total_aida_items BETWEEN 6 AND 20
  AND distinct_courses >= 2
```

**Support Ideas**:
- Share advanced AI tips
- Connect with power users
- Invite to AI user group
- Offer personalized consultation

### New Users (Provide Foundational Support)
```sql
WHERE total_aida_items <= 5
```

**Support Ideas**:
- Send beginner resources
- Invite to intro workshop
- Offer one-on-one training
- Share getting-started guide

## AI Adoption Cohort Analysis

### Categorize by Adoption Level
```sql
SELECT
    creator_name,
    total_aida_items,
    distinct_courses,
    CASE
        WHEN total_aida_items >= 30 THEN 'Power User'
        WHEN total_aida_items >= 10 THEN 'Frequent User'
        WHEN total_aida_items >= 5 THEN 'Regular User'
        ELSE 'Experimenting'
    END as adoption_level,
    CASE
        WHEN items_modified >= total_aida_items * 0.8 THEN 'High Personalization'
        WHEN items_modified >= total_aida_items * 0.5 THEN 'Moderate Personalization'
        ELSE 'Low Personalization'
    END as personalization_pattern
```

## Privacy and Ethical Considerations

**Important**: This query identifies individual faculty by name.

### Appropriate Uses
- Recognition and celebration
- Professional development planning
- Peer mentor recruitment
- Voluntary case studies

### Inappropriate Uses
- Pressure or criticism
- Punitive measures
- Public shaming for non-use
- Mandatory requirements

### Best Practices
1. **Voluntary Participation**: Never force AI use
2. **Support, Don't Surveil**: Frame as support for innovation
3. **Celebrate, Don't Compare**: Avoid competitive rankings
4. **Respect Choice**: Honor faculty autonomy in tool selection
5. **Confidentiality**: Share names only with appropriate consent

## Related Queries

- **show-aida-usage-by-course**: See specific courses for each creator
- **show-details-of-items**: See specific items created by person
- **show-aida-usage-by-node**: Compare creators across departments
- **show-aida-usage-by-term**: See creator adoption over time

## Communication Templates

### Recognition Email
```
Subject: Recognition for AI Innovation in Teaching

Dear [Creator Name],

We noticed your innovative use of AI Design Assistant in [N] of your
courses this term. Your willingness to explore new teaching tools
demonstrates your commitment to effective pedagogy.

Would you be interested in sharing your experience with colleagues
at an upcoming teaching circle or workshop?

Thank you for your continued innovation!
```

### Support Offer
```
Subject: Support for AI-Enhanced Course Design

Dear [Creator Name],

We see you've been experimenting with Blackboard's AI Design Assistant.
We'd love to support your continued exploration of AI tools for teaching.

Would you like to schedule a consultation to:
- Share tips for effective AI use
- Discuss personalization strategies
- Explore advanced features
- Connect with other AI users

Let us know how we can support your work!
```
