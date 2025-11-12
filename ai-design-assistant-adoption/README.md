# AI Design Assistant (AIDA) Adoption Queries

## Overview

This folder contains queries for analyzing the adoption and usage of Blackboard's AI Design Assistant (AIDA) feature. AIDA helps instructors create course content using artificial intelligence, and these queries track when and how AIDA is being used across the institution.

**AIDA Data Available From**: September 18, 2023 onwards

## Subfolders

### 1. [show-aida-usage-by-term](show-aida-usage-by-term/)
Groups AIDA-created content by academic term, showing how many courses and items used AIDA each term.

### 2. [show-aida-usage-by-course](show-aida-usage-by-course/)
Shows which specific courses have used AIDA and how many items were created with AI assistance.

### 3. [show-aida-usage-by-creator](show-aida-usage-by-creator/)
Identifies faculty/staff who are using AIDA most frequently (top AIDA users).

### 4. [show-aida-usage-by-node](show-aida-usage-by-node/)
Breaks down AIDA usage by organizational unit (college/department).

### 5. [show-details-of-items](show-details-of-items/)
Provides detailed information about every content item created with AIDA assistance.

### 6. [show-item-types](show-item-types/)
Categorizes AIDA-generated content by type (e.g., assignments, discussions, documents).

### 7. [show-aida-item-count-per-week-since-date](show-aida-item-count-per-week-since-date/)
Time-series analysis showing weekly AIDA adoption trends since a specific date.

## Common AIDA Tracking Features

All queries track:
- **AI Status Flag**: `ai_status = 'Y'` indicates AIDA was used
- **Modification Indicator**: Items modified more than 10 seconds after creation
- **Creator Information**: Who used AIDA
- **Temporal Tracking**: When AIDA content was created

## Primary Use Cases

- Monitor AI tool adoption across institution
- Identify early adopters and AI champions
- Track AIDA usage trends over time
- Support professional development planning
- Report on instructional innovation
- Guide AI integration strategy

## What is AIDA?

**AI Design Assistant (AIDA)** is Blackboard's built-in AI tool that helps instructors:
- Generate course content
- Create assignments and assessments
- Draft discussion prompts
- Develop learning objectives
- Write course descriptions

## Modification Tracking

Many queries track whether AIDA-generated content was modified:

```sql
CASE
    WHEN modified_time > created_time + INTERVAL '10 SECONDS'
    THEN 'Modified'
    ELSE 'Unmodified'
END
```

**Why This Matters**:
- Shows whether instructors personalize AI-generated content
- Indicates thoughtful vs. verbatim use of AI
- Helps understand AI as starting point vs. final product

## Data Availability

**Important**: AIDA data is only available from September 18, 2023 onwards. Queries should filter accordingly.

## Best Practices Across All AIDA Queries

1. **Respect Privacy**: AIDA usage should support faculty, not surveil
2. **Celebrate Innovation**: Recognize faculty experimenting with AI
3. **Share Learning**: Connect AIDA users to share practices
4. **Provide Training**: Use data to target AI literacy programs
5. **Track Thoughtfully**: Monitor for quality, not just quantity
6. **Support Modification**: Encourage personalization of AI content
7. **Ethical Use**: Ensure AIDA use aligns with institutional policies
8. **Student Transparency**: Encourage disclosure of AI-assisted content

## Reporting Recommendations

### Executive Summary
- Total AIDA usage (courses, items, faculty)
- Adoption trend (growing/stable/declining)
- Distribution across colleges/departments
- Top use cases (content types)

### Faculty Development
- Identify champions for peer training
- Target departments with low adoption
- Share examples of effective AIDA use
- Plan AI literacy workshops

### Strategic Planning
- Monitor ROI on AI tools
- Compare to peer institutions
- Guide future AI tool investments
- Support responsible AI integration

## Related Topics

- Course content creation workflows
- Instructional design support
- Educational technology adoption
- Faculty professional development
- AI in higher education

## Questions These Queries Answer

1. How many instructors are using AIDA?
2. Which colleges/departments use AIDA most?
3. Is AIDA adoption growing over time?
4. What types of content are created with AIDA?
5. Do instructors modify AI-generated content?
6. Which courses have the most AI-assisted items?
7. Who are our AI adoption leaders?
8. When did AIDA usage accelerate?

## See Individual Folders

Each subfolder contains:
- Specific query SQL file(s)
- Detailed README with use cases
- Analysis examples
- Interpretation guidance
