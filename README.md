# Course Visit Analytics System

A database-driven analytics platform for tracking and analyzing student engagement with online course materials.

## What is this?

This project analyzes how students interact with online courses. It tracks visits to course sites and provides insights into:
- Which courses are most popular
- How engaged students are
- Patterns in learning behavior
- Gaps in student engagement

## Tech Stack

- **Database**: SQL Server 2022
- **Visualization**: Python (matplotlib, seaborn)
- **Data Analysis**: SQL with window functions and CTEs
- **Platform**: Docker for easy deployment

## Quick Start

### 1. Start the Database
### 2. Setup the Database
### 3. Generate Visualizations

```bash
pip install pymssql pandas matplotlib seaborn
python visualize_assignment.py
```

This creates charts in the `visualizations/` folder.

## What's Inside

```
├── ADTAssignment2_Complete.sql    # Database setup + queries
├── visualize_assignment.py        # Generate charts
├── visualizations/                # Chart output folder
└── ADTAssignment2_Report.docx    # Full documentation
```

## Database Structure

**Programs** → **Courses** → **Users** → **Visits**

- Programs: Undergraduate, Master
- Departments: Computer Science, Mathematics
- 8 courses total (2 per department per program)
- 9 users across both programs
- 102 course site visits tracked

## Sample Analytics

### Most Popular Courses
See which courses get the most traffic.

### User Engagement Levels
Identify highly engaged vs. at-risk students.

### Visit Patterns
- Consecutive day streaks
- Gaps between visits
- Peak activity times

### Cross-Program Analysis
Compare engagement between Undergraduate and Master students.

## Key Features

✅ Real-world data modeling  
✅ Advanced SQL analytics  
✅ Professional visualizations  
✅ Containerized deployment  
✅ Comprehensive documentation  

## Requirements

- Docker
- Python 3.x
- SQL Server compatible tools (optional: Azure Data Studio)

## Use Cases

- **Educational Institutions**: Track student engagement
- **Online Learning Platforms**: Analyze course popularity
- **Data Analysis Learning**: Practice advanced SQL techniques
- **Portfolio Projects**: Demonstrate database and analytics skills

## Screenshots

<details>
<summary>View Sample Visualizations</summary>

### Total Course Visits
Bar chart showing visit counts per course.

### User Distribution
Pie chart of students per program.

### Engagement Heatmap
When users last accessed each course.

### Visit Streaks
Longest consecutive engagement periods.

</details>

## SQL Highlights

This project demonstrates:
- Window functions (`ROW_NUMBER`, `LAG`, `LEAD`)
- Common Table Expressions (CTEs)
- Complex joins and aggregations
- Date calculations and analytics
- Partitioning and ranking

## Installation Options

**Option 1: Docker (Recommended)**
```bash
docker-compose up -d
```

**Option 2: Local SQL Server**
- Install SQL Server
- Run the setup script
- Update connection strings

**Option 3: Cloud Database**
- Deploy to Azure SQL Database
- Update credentials in script

## Contributing

Feel free to:
- Add new analytical queries
- Improve visualizations
- Optimize database performance
- Enhance documentation

## Data Privacy

This project uses **synthetic data** for demonstration purposes. All user IDs and visit records are fictional.


## Questions?

Open an issue or reach out if you have questions about:
- Setting up the database
- Running the queries
- Understanding the analytics
- Customizing for your use case

---

**Built with SQL Server, Python, and data science best practices.**

*Perfect for learning advanced database analytics and building your portfolio!*
