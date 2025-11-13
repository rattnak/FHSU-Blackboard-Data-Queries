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

