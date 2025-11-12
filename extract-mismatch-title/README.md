# Extract Course Name / Term Mismatch

## Queries
- `query.sql`: Identify courses where the course name doesn't match the assigned term

## Overview

This data quality query identifies courses where the term embedded in the course name (e.g., "2025S" in the course title) doesn't match the actual term the course is assigned to in Blackboard. This helps identify naming inconsistencies and potential course assignment errors.

**Primary Use Cases:**
- Data quality auditing
- Identify incorrectly assigned courses
- Find courses needing renaming
- Support course cleanup projects
- Validate course creation processes

## How It Works

The query:
1. Extracts term pattern from course name using regex (e.g., "2025S", "2024F")
2. Compares extracted term to actual `term_id`
3. Returns courses where these don't match

### Term Pattern Examples
- `2025S` = Spring 2025
- `2024F` = Fall 2024
- `2025_S` = Spring 2025 (with underscore)
- `F2024` = Fall 2024 (reversed format)

## Output Columns

| Column | Description |
|--------|-------------|
| `course_id` | Unique Blackboard course identifier |
| `course_name` | Full display name (with embedded term) |
| `extracted_term_from_name` | Term pattern found in course name |
| `actual_term_id` | Term the course is actually assigned to |
| `term_name` | Human-readable term name |
| `design_mode` | Course design mode (C/U/P) |

## Common Mismatch Scenarios

### Scenario 1: Copy from Previous Term
```
Course Name: 2024F_MATH101_College Algebra
Assigned Term: S2025
Issue: Course copied but name not updated
```

### Scenario 2: Wrong Term Assignment
```
Course Name: 2025S_ENGL102_Composition
Assigned Term: F2024
Issue: Course created for wrong term
```

### Scenario 3: Manual Name Entry Error
```
Course Name: 2025_HIST201_US History
Assigned Term: F2025
Issue: Typo or incorrect term code in name
```

### Scenario 4: Naming Convention Change
```
Course Name: F2024_BIOL101_Biology
Assigned Term: 2024F
Issue: Different term naming format
```

## Performance Tips

**Estimated Execution Time:**
- All courses: 10-15 seconds

**Warehouse Sizing:**
- Small: Sufficient

## Analysis Examples

### Count Mismatches by Term
```sql
SELECT
    term_name,
    COUNT(*) as mismatch_count
GROUP BY term_name
ORDER BY mismatch_count DESC
```

### Identify Pattern Inconsistencies
```sql
SELECT
    extracted_term_from_name,
    actual_term_id,
    COUNT(*) as occurrence_count
GROUP BY extracted_term_from_name, actual_term_id
ORDER BY occurrence_count DESC
```

### Find Recent Mismatches
```sql
WHERE term.start_date >= CURRENT_DATE - INTERVAL '6 MONTHS'
ORDER BY term.start_date DESC
```

## Troubleshooting

### Many False Positives
**Issue**: Courses flagged but seem correct
**Cause**: Different term naming formats (e.g., "S2025" vs "2025S")
**Solution**: Review regex pattern to handle format variations

### No Results
**Possible Interpretations**:
1. **Excellent!** No naming mismatches exist
2. Course names don't follow expected pattern
3. Regex pattern doesn't match your naming convention

### Regex Not Matching
**Issue**: `extracted_term_from_name` is NULL for many courses
**Cause**: Course naming doesn't follow expected pattern
**Solution**: Modify regex to match your institution's naming convention

## Fixing Mismatches

### Option 1: Rename Course
Update course name to match assigned term:
```
Old: 2024F_MATH101_College Algebra
New: 2025S_MATH101_College Algebra
```

### Option 2: Reassign Term
Move course to correct term matching its name.

### Option 3: Document Exception
Some courses may legitimately have different naming (cross-term courses, templates, etc.).

## Preventing Future Mismatches

### Process Improvements
1. **Automated Course Creation**: Use naming templates
2. **Validation Rules**: Check name/term match at creation
3. **Copy Workflows**: Prompt for name update when copying
4. **Training**: Educate course creators on naming conventions
5. **Regular Audits**: Run this query quarterly

### Naming Convention Documentation
```markdown
Standard Format: [TERM]_[COURSE CODE]_[COURSE TITLE]

Examples:
- 2025S_ENGL101_English Composition
- 2024F_MATH210_Calculus I
- 2025_S_HIST101_World History (alternative)

Term Codes:
- Spring: S or _S
- Fall: F or _F
- Summer: SU or _SU
- Year: YYYY

Format: [YEAR][TERM] or [TERM][YEAR]
```

## Use Cases by Role

### System Administrators
- Data quality monitoring
- Course cleanup projects
- Process improvement
- System hygiene

### Academic Technology Staff
- Support course creation
- Train faculty on naming
- Validate course setups
- Troubleshoot access issues

### Registrar's Office
- Verify course-term assignments
- Support enrollment integrity
- Maintain data accuracy
- Coordinate with SIS

### Quality Assurance
- Audit data quality
- Track process adherence
- Document improvements
- Report on data health

## Automation Opportunities

### Weekly Report
```markdown
**Course Name/Term Mismatch Report**
Week of: [Date]

New Mismatches: [N]
Total Mismatches: [N]

Top Issues:
1. [Term]: [N] courses
2. [Term]: [N] courses

Action: Contact course creators to fix naming
```

### Alert Threshold
```sql
-- Set up alert if mismatches exceed threshold
SELECT COUNT(*) as mismatch_count
HAVING COUNT(*) > 50  -- Alert if >50 mismatches
```

## Related Queries

- **college-department**: Verify organizational assignments
- **course-due-time**: Check if mismatched courses have content
- **ultra-adoption-by-term**: Design mode doesn't affect this issue

## Best Practices

1. **Run Regularly**: Monthly or quarterly audits
2. **Act Quickly**: Fix new mismatches promptly
3. **Document Standards**: Clear naming convention guide
4. **Train Creators**: Educate all course creators
5. **Automate Where Possible**: Use templates and validation
6. **Communicate Findings**: Share results with stakeholders
7. **Track Trends**: Monitor if mismatches are increasing/decreasing
8. **Exception List**: Document legitimate exceptions
