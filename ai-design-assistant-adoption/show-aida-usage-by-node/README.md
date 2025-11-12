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

## Performance Tips

**Estimated Execution Time**: 5-8 seconds

**Warehouse Sizing**: Small - Sufficient

## Analysis Examples

### Rank Colleges by AIDA Adoption
```sql
SELECT
    node_name,
    distinct_courses,
    distinct_creators,
    total_aida_items,
    ROUND(total_aida_items * 1.0 / distinct_creators, 1) as items_per_creator,
    ROUND(100.0 * items_modified / total_aida_items, 1) as percent_modified
ORDER BY distinct_courses DESC
```

### Colleges with High AI Engagement
```sql
WHERE distinct_courses >= 10
  OR distinct_creators >= 5
ORDER BY total_aida_items DESC
```

### Identify Units Needing Support
```sql
WHERE distinct_creators <= 2
  OR total_aida_items <= 5
ORDER BY node_name
```

### Compare Modification Rates Across Units
```sql
SELECT
    node_name,
    ROUND(100.0 * items_modified / total_aida_items, 1) as percent_modified,
    total_aida_items
WHERE total_aida_items >= 5  -- Only units with significant usage
ORDER BY percent_modified DESC
```

## Use Cases by Role

### Academic Affairs
- Compare innovation across colleges
- Allocate AI support resources
- Report to executive leadership
- Plan institutional AI strategy

### College Deans
- Monitor AI adoption in college
- Compare college to peers
- Plan college-level AI initiatives
- Recognize faculty innovation

### Faculty Development
- Target training by college needs
- Identify college champions
- Plan college-specific workshops
- Share college-level best practices

### Educational Technology
- Prioritize support by college
- Build college-specific communities
- Share adoption patterns
- Plan targeted outreach

## Strategic Insights

### Adoption Leaders (To Study and Share)
```sql
WHERE distinct_creators >= 5
  AND items_modified >= total_aida_items * 0.7
ORDER BY distinct_creators DESC
```

**Question**: What makes these units successful AI adopters?

### Growth Opportunities (To Support)
```sql
WHERE distinct_creators BETWEEN 1 AND 3
ORDER BY node_name
```

**Action**: Targeted outreach and training

### Non-Adopters (To Engage)
Units NOT appearing in results need introduction to AIDA.

## Visualizations

### Bar Chart: Courses Using AIDA by College
- X-axis: College Name
- Y-axis: Distinct Courses
- Shows relative adoption breadth

### Scatter Plot: Creators vs. Items
- X-axis: Distinct Creators
- Y-axis: Total AIDA Items
- Shows engagement depth and breadth
- Identify high-leverage and high-volume units

### Heatmap: Adoption Metrics by College
- Rows: Colleges
- Columns: Courses, Creators, Items
- Color: Intensity of adoption

## Comparative Benchmarking

### Calculate Adoption Rates
If you have total faculty/course counts by unit:

```sql
SELECT
    node_name,
    distinct_creators as aida_users,
    [total_faculty] as total_faculty,
    ROUND(100.0 * distinct_creators / [total_faculty], 1) as faculty_adoption_percent,
    distinct_courses as courses_with_aida,
    [total_courses] as total_courses,
    ROUND(100.0 * distinct_courses / [total_courses], 1) as course_adoption_percent
```

### Set Institutional Goals
```markdown
Goal: 25% of faculty using AIDA within 2 years

Current Status by College:
- College A: [X]% ([N]/[Total])
- College B: [X]% ([N]/[Total])
- College C: [X]% ([N]/[Total])

Colleges on track: [List]
Colleges needing support: [List]
```

## Context Considerations

### Discipline Differences
Some disciplines may be:
- More comfortable with AI tools
- More concerned about academic integrity
- More/less able to use AI for their content types

**Action**: Understand and respect disciplinary context

### College Size
Larger colleges naturally have more raw numbers.

**Better Metric**: Adoption rates (% of faculty, % of courses)

### Resource Differences
Consider variations in:
- Instructional design support
- Professional development access
- Technology literacy
- Teaching loads

## Communication with College Leadership

### Report Template
```markdown
# AI Design Assistant Adoption: [College Name]

## Current Adoption (as of [Date])
- **Faculty Using AIDA**: [N] instructors
- **Courses with AI Content**: [N] courses
- **Total AI-Generated Items**: [N]
- **Personalization Rate**: [X]% modified

## Institutional Comparison
- **Institutional Average**: [Avg] faculty per college
- **Your College Ranking**: [#N] of [Total] colleges
- **Peer Colleges**: [Similar adoption rates]

## Strengths
- [Positive observations]

## Opportunities
- [Suggestions for growth]

## Support Available
- [Training resources]
- [Consultation offerings]
- [Peer connections]
```

## Related Queries

- **show-aida-usage-by-creator**: See specific faculty within each unit
- **show-aida-usage-by-course**: See specific courses within each unit
- **show-aida-usage-by-term**: Track unit adoption over time
- **show-details-of-items**: Deep dive into content types by unit
