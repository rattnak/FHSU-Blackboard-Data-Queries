# FHSU Blackboard Data Queries

A collection of SQL queries for analyzing Blackboard Learn data at Fort Hays State University (FHSU). These queries are customized for FHSU's internal use and provide insights into course activity, tool adoption, student engagement, and institutional effectiveness.

## About This Repository

This repository is maintained by Nak Mong at Technology and Innovation in Learning and Teaching (TILT) team at FHSU. The queries are built on the Blackboard Data Common Data Model (CDM) schema and have been adapted to meet FHSU's specific reporting and analytics needs.

**Original Repository**: [Blackboard Data Queries](https://github.com/blackboard/BBDN-BlackboardData-Queries)
**Customized for**: Fort Hays State University
**Database**: Blackboard Learn Data (CDM Schema)

## Repository Structure

Each folder contains specific queries with detailed documentation:

### Course Analysis
- **[college-department/](college-department/)** - Course counts by college and department
- **[all-college-department/](all-college-department/)** - All college and department combinations
- **[filter-course-by-college/](filter-course-by-college/)** - Filter courses to specific college
- **[filter-course-by-college-department/](filter-course-by-college-department/)** - Filter courses to specific college and department
- **[extract-mismatch-title/](extract-mismatch-title/)** - Identify course title mismatches

### Virtual Course Analysis
- **[virtual-course-student-interaction/](virtual-course-student-interaction/)** - Student-level interaction data for virtual courses
- **[virtual-course-instructor-student-interaction/](virtual-course-instructor-student-interaction/)** - Combined instructor and student activity metrics
- **[virtual-course-total-interaction-per-student-per-course/](virtual-course-total-interaction-per-student-per-course/)** - Aggregated virtual course engagement
- **[student-level-virtual-course-engagement/](student-level-virtual-course-engagement/)** - Course-level engagement statistics
- **[filter-virtual-course-by-college/](filter-virtual-course-by-college/)** - Virtual courses filtered by college
- **[virtual-course-earliest-due-time/](virtual-course-earliest-due-time/)** - Due date tracking for virtual courses
- **[filter-virtual-course-earliest-due-time-by-college/](filter-virtual-course-earliest-due-time-by-college/)** - Virtual course due dates by college

### Educational Technology Tools
- **[course-tool-interaction/](course-tool-interaction/)** - Track adoption of 8+ educational technology tools
- **[specific-tool-adoption-and-usage/](specific-tool-adoption-and-usage/)** - Detailed metrics for specific tools
- **[filter-specific-tool-interaction/](filter-specific-tool-interaction/)** - Tool interactions filtered by course criteria
- **[filter-all-tool-interaction-by-college/](filter-all-tool-interaction-by-college/)** - Tool usage at college level
- **[filter-all-tool-interaction-by-college-department/](filter-all-tool-interaction-by-college-department/)** - Tool usage at department level

### Course Content & Due Dates
- **[course-due-time/](course-due-time/)** - All course due dates
- **[course-earliest-due-time/](course-earliest-due-time/)** - Next upcoming due date per course
- **[course-overdue-time/](course-overdue-time/)** - Overdue assignments
- **[filter-each-course-due-time/](filter-each-course-due-time/)** - Individual course due date analysis

### Syllabus Analysis
- **[course-syllabi-age/](course-syllabi-age/)** - Track syllabus age in courses
- **[course-syllabi-last-modified/](course-syllabi-last-modified/)** - Syllabus update tracking
- **[filter-outdated-syllabi-age/](filter-outdated-syllabi-age/)** - Identify outdated syllabi by age
- **[filter-outdated-syllabi-last-modified/](filter-outdated-syllabi-last-modified/)** - Identify outdated syllabi by modification date

### Blackboard Ultra Adoption
- **[ultra-adoption-by-term/](ultra-adoption-by-term/)** - Ultra adoption rates per term
- **[ultra-adoption-since-date/](ultra-adoption-since-date/)** - Ultra adoption trends over time

### AI Design Assistant (AIDA)
- **[ai-design-assistant-adoption/](ai-design-assistant-adoption/)** - Comprehensive AIDA usage analytics
  - Usage by term, course, creator, and node
  - Item count trends over time
  - Detailed item type analysis

## Common Query Patterns

Most query folders include multiple files:
- **`by-term-query.sql`** - Filter data by specific term (e.g., S2025, F2024)
- **`between-date-query.sql`** - Filter data by date range
- **`query.sql`** - General purpose query without date filters

## Key Features Across Queries

### FHSU-Specific Filters
All queries include filters customized for FHSU:
- **Student Employee Account Exclusion**: Filters out `%.se@fhsu.edu` emails
- **Specific User Exclusions**: Removes TILT Members' Emails
- **Institutional Hierarchy**: Uses FHSU's 5-level organizational structure
- **Virtual Course Detection**: Pattern matching for FHSU's virtual course naming conventions
- **Design Mode Filtering**: P (Primary), U (Ultra), C (Classic)

### Standard Output Columns
Most queries include:
- Course identification (ID, name, design mode)
- Term information
- Instructor details (count, names, emails)
- Organizational hierarchy (college, department)
- Engagement metrics
- Timestamps (last interaction, due dates)

### Institutional Hierarchy Levels
FHSU's organizational structure in Blackboard:
1. **Level 1**: Fort Hays State University
2. **Level 2**: FHSU - Academic Colleges and Departments
3. **Level 3**: College name
4. **Level 4**: College name (repeated)
5. **Level 5**: Department name

## Technology Stack

- **Platform**: Anthology Illuminate 
- **Database**: Snowflake Data Warehouse
- **Query Language**: SQL (Snowflake SQL dialect, PostgreSQL-compatible)
- **Data Source**: Blackboard Learn SaaS
- **Schema**: Common Data Model (CDM)

## Getting Started

1. **Choose a Query**: Browse folders to find relevant analysis
2. **Read Documentation**: Each folder has a README.md explaining the query
3. **Select Query Type**: Choose between term-based or date-range queries
4. **Customize Parameters**:
   - Update term names (e.g., `WHERE term.name = 'S2025'`)
   - Adjust date ranges
   - Modify college/department filters
   - Add or remove tool names
5. **Execute Query**: Run against your Blackboard Data warehouse

## Common Customizations

### Change Term
```sql
WHERE term.name = 'S2025'  -- Update to desired term
```

### Change Date Range
```sql
WHERE start_date BETWEEN '2024-07-31' AND '2025-04-01'
```

### Filter by College
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 4) = 'College of Education'
```

### Filter by Department
```sql
AND SPLIT_PART(ih.hierarchy_name_seq, '||', 5) = 'Teacher Education'
```

## Virtual Course Detection

FHSU uses specific naming patterns for virtual courses:
- **Pattern**: `course_name LIKE '%_V_%'`
- **Variants**: _VA_, _VB_, _VC_, etc. (A-Z suffixes for sections)
- **Exclusions**: Courses with hyphen before V (`NOT LIKE '%-%V%'`)

## Tracked Educational Tools

Standard tools across multiple queries:
- YellowDig Engage
- Packback
- Feedback
- Inscribe
- GoReact
- Qwickly
- VoiceThread
- Zoom

## Support

For questions or issues with these queries:
- Contact the FHSU TILT team
- Review individual folder README files
- Check the original Blackboard repository for CDM schema documentation

## License

This repository inherits its license from the original Blackboard Data Queries repository. Please refer to the [LICENSE](LICENSE) file for details.

## Contributing

This repository is maintained for FHSU internal use. If you're part of the FHSU team and want to contribute:
1. Create queries in appropriately named folders
2. Include a detailed README.md following the existing format
3. Document all customizations and filters
4. Test queries against production data before committing

## Acknowledgments

- **Blackboard Inc.** - For the original CDM query templates
- **FHSU TILT Team** - For ongoing query development and maintenance
- **Blackboard Data Team** - For CDM schema documentation and support

---

**Last Updated**: December 2025
**Maintained By**: Chanrattnak Mong at [FHSU Technology and Innovation in Learning and Teaching (TILT)](https://www.fhsu.edu/learningtechnologies/about-tilt/staff-page)
