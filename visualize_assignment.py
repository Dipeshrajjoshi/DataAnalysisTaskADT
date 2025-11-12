import pymssql
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Set style for better-looking plots
sns.set_style("whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)

# Create output directory for images
os.makedirs('visualizations', exist_ok=True)

# Database connection details
SERVER = 'localhost'
DATABASE = 'ADTAssignment2'
USERNAME = 'sa'
PASSWORD = 'MyStrongPass123'

# Connect to SQL Server
print("Connecting to SQL Server...")
conn = pymssql.connect(server=SERVER, user=USERNAME, password=PASSWORD, database=DATABASE)
print("Connected successfully!\n")

# Query a: Total number of times a course has been visited
query_a = """
SELECT 
    c.courseID,
    c.deptName,
    p.name AS programName,
    COUNT(*) AS TotalVisits
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY c.courseID, c.deptName, p.name
ORDER BY TotalVisits DESC
"""

print("Query a: Total visits per course")
df_a = pd.read_sql(query_a, conn)
print(df_a)
print()

# Visualization for Query a
plt.figure(figsize=(12, 6))
bars = plt.bar(df_a['courseID'].astype(str), df_a['TotalVisits'], color='steelblue')
plt.xlabel('Course ID', fontsize=12)
plt.ylabel('Total Visits', fontsize=12)
plt.title('Total Number of Visits per Course', fontsize=14, fontweight='bold')
plt.xticks(rotation=0)
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{int(height)}', ha='center', va='bottom', fontsize=10)
plt.tight_layout()
plt.savefig('visualizations/query_a_total_visits_per_course.png', dpi=300, bbox_inches='tight')
print("Saved: query_a_total_visits_per_course.png\n")
plt.close()

# Query b: Total visits for each course, categorized by program
query_b = """
SELECT 
    p.name AS ProgramName,
    c.courseID,
    c.deptName,
    COUNT(*) AS TotalVisits
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY p.name, c.courseID, c.deptName
ORDER BY p.name, TotalVisits DESC
"""

print("Query b: Visits by course and program")
df_b = pd.read_sql(query_b, conn)
print(df_b)
print()

# Visualization for Query b
plt.figure(figsize=(14, 6))
programs = df_b['ProgramName'].unique()
x = range(len(df_b))
colors = ['#1f77b4' if prog == programs[0] else '#ff7f0e' for prog in df_b['ProgramName']]
bars = plt.bar(x, df_b['TotalVisits'], color=colors)
plt.xlabel('Course ID', fontsize=12)
plt.ylabel('Total Visits', fontsize=12)
plt.title('Total Visits by Course and Program', fontsize=14, fontweight='bold')
plt.xticks(x, df_b['courseID'].astype(str), rotation=0)
plt.legend([programs[0], programs[1]], loc='upper right')
plt.tight_layout()
plt.savefig('visualizations/query_b_visits_by_program.png', dpi=300, bbox_inches='tight')
print("Saved: query_b_visits_by_program.png\n")
plt.close()

# Query c: Total users enrolled in each program
query_c = """
SELECT 
    p.programID,
    p.name AS ProgramName,
    COUNT(u.userID) AS TotalUsers
FROM program p
LEFT JOIN users u ON p.programID = u.programID
GROUP BY p.programID, p.name
ORDER BY p.programID
"""

print("Query c: Total users per program")
df_c = pd.read_sql(query_c, conn)
print(df_c)
print()

# Visualization for Query c
plt.figure(figsize=(8, 6))
colors_pie = ['#ff9999', '#66b3ff']
plt.pie(df_c['TotalUsers'], labels=df_c['ProgramName'], autopct='%1.1f%%', 
        startangle=90, colors=colors_pie, textprops={'fontsize': 12})
plt.title('Total Users Enrolled in Each Program', fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('visualizations/query_c_users_per_program.png', dpi=300, bbox_inches='tight')
print("Saved: query_c_users_per_program.png\n")
plt.close()

# Query d: Unique visitors per department by program
query_d = """
SELECT 
    c.deptName,
    p.name AS ProgramName,
    COUNT(DISTINCT csv.userID) AS UniqueVisitors
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY c.deptName, p.name
ORDER BY c.deptName, p.name
"""

print("Query d: Unique visitors per department by program")
df_d = pd.read_sql(query_d, conn)
print(df_d)
print()

# Visualization for Query d
plt.figure(figsize=(10, 6))
df_d_pivot = df_d.pivot(index='deptName', columns='ProgramName', values='UniqueVisitors')
df_d_pivot.plot(kind='bar', color=['steelblue', 'orange'])
plt.xlabel('Department', fontsize=12)
plt.ylabel('Unique Visitors', fontsize=12)
plt.title('Unique Visitors per Department by Program', fontsize=14, fontweight='bold')
plt.xticks(rotation=45, ha='right')
plt.legend(title='Program')
plt.tight_layout()
plt.savefig('visualizations/query_d_unique_visitors.png', dpi=300, bbox_inches='tight')
print("Saved: query_d_unique_visitors.png\n")
plt.close()

# Query e: Most recent date user visited each course
query_e = """
SELECT 
    csv.userID,
    csv.courseID,
    c.deptName,
    MAX(csv.date) AS LastVisitDate
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
GROUP BY csv.userID, csv.courseID, c.deptName
ORDER BY csv.userID, csv.courseID
"""

print("Query e: Most recent visit date per user per course")
df_e = pd.read_sql(query_e, conn)
print(df_e.head(10))
print()

# Visualization for Query e - Heatmap
plt.figure(figsize=(12, 8))
df_e_pivot = df_e.pivot(index='userID', columns='courseID', values='LastVisitDate')
# Convert dates to numeric for heatmap
df_e_pivot_numeric = df_e_pivot.apply(pd.to_datetime).apply(lambda x: x.astype(int) / 10**9)
sns.heatmap(df_e_pivot_numeric, cmap='YlOrRd', cbar_kws={'label': 'Date (timestamp)'}, 
            linewidths=0.5, annot=False)
plt.xlabel('Course ID', fontsize=12)
plt.ylabel('User ID', fontsize=12)
plt.title('Most Recent Visit Date - Heatmap (User vs Course)', fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('visualizations/query_e_recent_visits_heatmap.png', dpi=300, bbox_inches='tight')
print("Saved: query_e_recent_visits_heatmap.png\n")
plt.close()

# Query f: Number of times user visited each course
query_f = """
SELECT 
    csv.userID,
    csv.courseID,
    c.deptName,
    p.name AS ProgramName,
    COUNT(*) AS VisitCount
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY csv.userID, csv.courseID, c.deptName, p.name
ORDER BY csv.userID, VisitCount DESC
"""

print("Query f: Visit count per user per course")
df_f = pd.read_sql(query_f, conn)
print(df_f.head(10))
print()

# Visualization for Query f - Top 20 user-course combinations
plt.figure(figsize=(14, 6))
df_f_top = df_f.nlargest(20, 'VisitCount')
df_f_top['UserCourse'] = 'U' + df_f_top['userID'].astype(str) + '-C' + df_f_top['courseID'].astype(str)
bars = plt.barh(df_f_top['UserCourse'], df_f_top['VisitCount'], color='teal')
plt.xlabel('Visit Count', fontsize=12)
plt.ylabel('User-Course', fontsize=12)
plt.title('Top 20 User-Course Visit Counts', fontsize=14, fontweight='bold')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig('visualizations/query_f_visit_counts.png', dpi=300, bbox_inches='tight')
print("Saved: query_f_visit_counts.png\n")
plt.close()

# Query g: Most frequent visitor per course
query_g = """
WITH CourseVisitCounts AS (
    SELECT 
        courseID,
        userID,
        COUNT(*) AS VisitCount,
        ROW_NUMBER() OVER (PARTITION BY courseID ORDER BY COUNT(*) DESC) AS rn
    FROM courseSiteVisit
    GROUP BY courseID, userID
)
SELECT 
    cvc.courseID,
    c.deptName,
    cvc.userID,
    cvc.VisitCount AS MaxVisits
FROM CourseVisitCounts cvc
JOIN depCourse c ON cvc.courseID = c.courseID
WHERE cvc.rn = 1
ORDER BY cvc.courseID
"""

print("Query g: Most frequent visitor per course")
df_g = pd.read_sql(query_g, conn)
print(df_g)
print()

# Visualization for Query g
plt.figure(figsize=(12, 6))
bars = plt.bar(df_g['courseID'].astype(str), df_g['MaxVisits'], color='coral')
plt.xlabel('Course ID', fontsize=12)
plt.ylabel('Max Visits by Single User', fontsize=12)
plt.title('Most Frequent Visitor Per Course', fontsize=14, fontweight='bold')
for i, (bar, user) in enumerate(zip(bars, df_g['userID'])):
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'U{user}\n{int(height)}', ha='center', va='bottom', fontsize=9)
plt.tight_layout()
plt.savefig('visualizations/query_g_most_frequent_visitor.png', dpi=300, bbox_inches='tight')
print("Saved: query_g_most_frequent_visitor.png\n")
plt.close()

# Query h: Most visits in single day per course
query_h = """
WITH DailyVisitCounts AS (
    SELECT 
        courseID,
        userID,
        date,
        COUNT(*) AS VisitsInDay,
        ROW_NUMBER() OVER (PARTITION BY courseID ORDER BY COUNT(*) DESC) AS rn
    FROM courseSiteVisit
    GROUP BY courseID, userID, date
)
SELECT 
    dvc.courseID,
    c.deptName,
    dvc.userID,
    dvc.date,
    dvc.VisitsInDay AS MaxVisitsInSingleDay
FROM DailyVisitCounts dvc
JOIN depCourse c ON dvc.courseID = c.courseID
WHERE dvc.rn = 1
ORDER BY dvc.courseID
"""

print("Query h: Most visits in single day per course")
df_h = pd.read_sql(query_h, conn)
print(df_h)
print()

# Visualization for Query h
plt.figure(figsize=(12, 6))
bars = plt.bar(df_h['courseID'].astype(str), df_h['MaxVisitsInSingleDay'], color='mediumpurple')
plt.xlabel('Course ID', fontsize=12)
plt.ylabel('Max Visits in Single Day', fontsize=12)
plt.title('Most Visits in Single Day Per Course', fontsize=14, fontweight='bold')
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{int(height)}', ha='center', va='bottom', fontsize=10)
plt.tight_layout()
plt.savefig('visualizations/query_h_single_day_visits.png', dpi=300, bbox_inches='tight')
print("Saved: query_h_single_day_visits.png\n")
plt.close()

# Query i: Longest visit streak
query_i = """
WITH VisitDates AS (
    SELECT DISTINCT 
        userID, 
        courseID, 
        date,
        DATEDIFF(day, date, LAG(date) OVER (PARTITION BY userID, courseID ORDER BY date)) AS dayDiff
    FROM courseSiteVisit
),
Streaks AS (
    SELECT 
        userID,
        courseID,
        date,
        CASE 
            WHEN dayDiff = -1 OR dayDiff IS NULL THEN 0 
            ELSE 1 
        END AS isNewStreak,
        SUM(CASE WHEN dayDiff = -1 OR dayDiff IS NULL THEN 0 ELSE 1 END) 
            OVER (PARTITION BY userID, courseID ORDER BY date) AS streakGroup
    FROM VisitDates
),
StreakLengths AS (
    SELECT 
        userID,
        courseID,
        streakGroup,
        COUNT(*) AS streakLength
    FROM Streaks
    GROUP BY userID, courseID, streakGroup
)
SELECT 
    sl.userID,
    sl.courseID,
    c.deptName,
    MAX(sl.streakLength) AS LongestStreak
FROM StreakLengths sl
JOIN depCourse c ON sl.courseID = c.courseID
GROUP BY sl.userID, sl.courseID, c.deptName
ORDER BY LongestStreak DESC
"""

print("Query i: Longest visit streak")
df_i = pd.read_sql(query_i, conn)
print(df_i.head(10))
print()

# Visualization for Query i - Top 15 streaks
plt.figure(figsize=(12, 6))
df_i_top = df_i.nlargest(15, 'LongestStreak')
df_i_top['UserCourse'] = 'U' + df_i_top['userID'].astype(str) + '-C' + df_i_top['courseID'].astype(str)
bars = plt.barh(df_i_top['UserCourse'], df_i_top['LongestStreak'], color='forestgreen')
plt.xlabel('Longest Streak (days)', fontsize=12)
plt.ylabel('User-Course', fontsize=12)
plt.title('Top 15 Longest Visit Streaks', fontsize=14, fontweight='bold')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig('visualizations/query_i_longest_streaks.png', dpi=300, bbox_inches='tight')
print("Saved: query_i_longest_streaks.png\n")
plt.close()

# Query j: Longest gap between visits
query_j = """
WITH VisitGaps AS (
    SELECT 
        userID,
        courseID,
        date,
        LEAD(date) OVER (PARTITION BY userID, courseID ORDER BY date) AS nextVisitDate,
        DATEDIFF(day, date, LEAD(date) OVER (PARTITION BY userID, courseID ORDER BY date)) AS gapDays
    FROM (
        SELECT DISTINCT userID, courseID, date 
        FROM courseSiteVisit
    ) AS distinctVisits
)
SELECT 
    vg.userID,
    vg.courseID,
    c.deptName,
    MAX(vg.gapDays) AS LongestGapDays
FROM VisitGaps vg
JOIN depCourse c ON vg.courseID = c.courseID
WHERE vg.gapDays IS NOT NULL
GROUP BY vg.userID, vg.courseID, c.deptName
ORDER BY LongestGapDays DESC
"""

print("Query j: Longest gap between visits")
df_j = pd.read_sql(query_j, conn)
print(df_j.head(10))
print()

# Visualization for Query j - Top 15 gaps
plt.figure(figsize=(12, 6))
df_j_top = df_j.nlargest(15, 'LongestGapDays')
df_j_top['UserCourse'] = 'U' + df_j_top['userID'].astype(str) + '-C' + df_j_top['courseID'].astype(str)
bars = plt.barh(df_j_top['UserCourse'], df_j_top['LongestGapDays'], color='crimson')
plt.xlabel('Longest Gap (days)', fontsize=12)
plt.ylabel('User-Course', fontsize=12)
plt.title('Top 15 Longest Gaps Between Visits', fontsize=14, fontweight='bold')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig('visualizations/query_j_longest_gaps.png', dpi=300, bbox_inches='tight')
print("Saved: query_j_longest_gaps.png\n")
plt.close()

# Query k: User who visited most courses in short duration
query_k = """
WITH UserCourseDates AS (
    SELECT DISTINCT 
        userID,
        courseID,
        date
    FROM courseSiteVisit
),
WindowVisits AS (
    SELECT 
        userID,
        date,
        COUNT(DISTINCT courseID) AS coursesVisited,
        MIN(date) AS windowStart,
        MAX(date) AS windowEnd
    FROM UserCourseDates
    GROUP BY userID, date
),
ThreeDayWindow AS (
    SELECT 
        w1.userID,
        w1.date AS startDate,
        COUNT(DISTINCT w2.courseID) AS totalCourses,
        DATEDIFF(day, w1.date, MAX(w2.date)) AS duration
    FROM WindowVisits w1
    CROSS APPLY (
        SELECT courseID, date
        FROM UserCourseDates w2
        WHERE w2.userID = w1.userID 
        AND w2.date BETWEEN w1.date AND DATEADD(day, 3, w1.date)
    ) w2
    GROUP BY w1.userID, w1.date
)
SELECT TOP 10
    userID,
    startDate,
    DATEADD(day, duration, startDate) AS endDate,
    totalCourses,
    duration AS DurationInDays
FROM ThreeDayWindow
ORDER BY totalCourses DESC, duration ASC
"""

print("Query k: Users who visited most courses in short duration")
df_k = pd.read_sql(query_k, conn)
print(df_k)
print()

# Visualization for Query k
plt.figure(figsize=(10, 6))
bars = plt.bar(df_k['userID'].astype(str), df_k['totalCourses'], color='dodgerblue')
plt.xlabel('User ID', fontsize=12)
plt.ylabel('Total Courses Visited', fontsize=12)
plt.title('Users Who Visited Most Courses in Short Duration (3 days)', fontsize=14, fontweight='bold')
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{int(height)}', ha='center', va='bottom', fontsize=10)
plt.tight_layout()
plt.savefig('visualizations/query_k_most_courses_short_duration.png', dpi=300, bbox_inches='tight')
print("Saved: query_k_most_courses_short_duration.png\n")
plt.close()

# Close connection
conn.close()
print("\n" + "="*60)
print("All visualizations have been saved in 'visualizations' folder!")
print("="*60)