# 🗄️ Database System Using Oracle DBMS

## 📘 Project Overview
This project demonstrates the design and implementation of a **Cultural Facility Management Database** using **Oracle DBMS**.  
It was developed for the **ITDSA2-22 Database Systems** module at **Eduvos – Mowbray Campus** by **Joyce Koloando Coem**.  

The system models and manages information about:
- Provinces  
- Municipalities  
- Facilities  
- Rooms  
- Activities  
- Usage tracking for events  

The database is implemented in **Oracle SQL** and demonstrates table creation, sequence generation, data insertion, relational queries, and stored procedures.

---


## ⚙️ How to Run the Project

### 1. Prerequisites
- **Oracle SQL Developer** or **SQL*Plus**
- Access to an **Oracle Database** (local or remote)

### 2. Setup Steps
1. Clone or download this repository:
   ```bash
   git clone https://github.com/yourusername/Database-system-using-Oracle-dbms.git
   cd Database-system-using-Oracle-dbms

2. Open oracle_script.sql in Oracle SQL Developer.
3. Run the script to:
- Create a new user and grant privileges
- Build all required tables and relationships
- Create sequences for primary keys
- Insert sample data into the database
- Define and execute stored procedures for reporting

## 🧩 Key Features

✅ **Database Creation**
- Normalized schema for provinces, municipalities, facilities, rooms, activities, and usage.
- Referential integrity maintained through primary and foreign key constraints.

✅ **Sequences**
- Auto-generating IDs for all major entities using Oracle sequences.
  
✅ **Data Population**
- Sample data inserted for testing and demonstration.
  
✅ **Queries*
- Count municipalities without music facilities.
- Retrieve provinces with average population above 4 million.
  
✅ **Stored Procedure**
- Calculates facility utilization per province and displays summarized results.

## 🎓 Learning Outcomes
- Through this project, learners will understand how to:
- Design and normalize a relational database.
- Use Oracle SQL to create, populate, and query tables.
- Apply PL/SQL for stored procedures and reporting.
- Implement sequences for auto-incrementing primary keys.
- Manage and query hierarchical data relationships.

## 🧰 Tools & Technologies
- Oracle SQL Developer
- SQL*Plus
- Oracle DBMS
- PL/SQL


## 👩‍💻 Author
Joyce Koloando Coem<br/>
Student Number: CT.2022.T0Q1Q9<br/>
Eduvos – Mowbray Campus<br/>


## ⚙️ Setup Instructions

To run this project, copy and execute the SQL script below in **Oracle SQL Developer** or **SQL*Plus**.  
Everything after this point is under one SQL block — from user creation to stored procedure execution.

```sql
-- ================================================================
-- USER AND PRIVILEGES
-- ================================================================
CREATE USER ModiseCulturalFacility IDENTIFIED BY Eduvos#2025;
GRANT CONNECT, RESOURCE TO ModiseCulturalFacility;
GRANT UNLIMITED TABLESPACE TO ModiseCulturalFacility;
EXIT;
