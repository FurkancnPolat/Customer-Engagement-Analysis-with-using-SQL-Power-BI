# Customer-Engagement-Analysis-with-using-SQL-Power-BI
Project Description:
This project focuses on analyzing customer engagement with an online learning platform. The analysis combines SQL and Power BI to extract insights and create a dynamic dashboard. 
Using SQL, we retrieved and prepared data from multiple tables to generate CSV files, which were later visualized in Power BI. 
The goal was to evaluate student behavior, course popularity, and subscription trends while identifying areas for improvement.



# Key Objectives:
Extract and preprocess data from a relational database using SQL.
Generate metrics such as minutes watched, onboarding rates, and paid subscription statuses.
Create a comprehensive Power BI dashboard to visualize insights from the data.


Project Title: Customer Engagement Analysis with SQL and Power BI
Project Description:
This project focuses on analyzing customer engagement with an online learning platform. The analysis combines SQL and Power BI to extract insights and create a dynamic dashboard. Using SQL, we retrieved and prepared data from multiple tables to generate CSV files, which were later visualized in Power BI. The goal was to evaluate student behavior, course popularity, and subscription trends while identifying areas for improvement.

Key Objectives:
Extract and preprocess data from a relational database using SQL.
Generate metrics such as minutes watched, onboarding rates, and paid subscription statuses.
Create a comprehensive Power BI dashboard to visualize insights from the data.

# Tasks Overview:

Task 1: Retrieving Course Information with SQL
Extracted a summary of all courses, including:
Total minutes watched.
Average minutes per student.
Number of ratings and average rating.
Saved the result as sql-task1-courses.csv.

Task 2: Creating the Purchases Info View
Used the 365_student_purchases table to:
Calculate subscription start and end dates based on the subscription type (monthly, quarterly, annual).
Created the purchases_info view with columns:
purchase_id, student_id, purchase_type, date_start, date_end.
Ensured the output had 3,041 rows.

Task 3: Retrieving Student Engagement Information
Merged data from the 365_student_info, 365_student_learning, and purchases_info tables.
Generated a dataset with:
student_id, student_country, date_registered, date_watched, minutes_watched, onboarded (0 or 1), paid (0 or 1).
Ensured inclusion of all students, even those without learning records.
Saved the result as sql-task3-courses.csv.

# Outcome:
This project successfully demonstrated the integration of SQL data extraction and Power BI visualization. The insights helped identify trends in user engagement, popular courses, and paid subscription behavior, contributing to data-driven decisions for platform improvement.
