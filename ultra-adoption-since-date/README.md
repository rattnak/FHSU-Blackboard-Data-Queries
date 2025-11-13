# Ultra Course Design Adoption Since Date

## Queries
- `query.sql`: Track courses created in Ultra mode since a specific date (template)

## Overview

This query shows all courses created in Ultra or Preview design mode since a specified date. It's a template query where you replace `{date}` with your desired start date to analyze Ultra adoption in a specific time window.

**Primary Use Cases:**
- Track new course creation in Ultra mode
- Monitor recent Ultra adoption
- Measure impact of training initiatives
- Report on conversion projects
- Track post-migration Ultra usage

## Design Modes Tracked

Courses with `design_mode` IN ('U', 'P'):
- **U** = Ultra
- **P** = Preview (Ultra with Classic fallback)

## Output Columns

| Column | Description |
|--------|-------------|
| `term` | Term name |
| `start_date` | Course start date |
| `design_mode` | Course design mode (U or P) |
| `course_count` | Number of courses in this mode |

Results grouped by term, start date, and design mode.

## How to Use

### Replace the Date Placeholder

Find this line in the query:
```sql
WHERE start_date >= '{date}'
```

Replace `{date}` with your desired date:
```sql
WHERE start_date >= '2024-01-01'  -- Courses since Jan 1, 2024
WHERE start_date >= '2024-08-01'  -- Courses since Aug 1, 2024
WHERE start_date >= '2025-01-01'  -- Courses since Jan 1, 2025
```

### Common Use Cases

**Track Current Academic Year**:
```sql
WHERE start_date >= '2024-07-01'  -- FY 2024-25
```

**Post-Training Adoption**:
```sql
WHERE start_date >= '2024-09-15'  -- After September training
```

**Recent Quarter**:
```sql
WHERE start_date >= CURRENT_DATE - INTERVAL '90 DAYS'
```

**Post-Migration**:
```sql
WHERE start_date >= '2024-05-01'  -- After migration initiative
```

