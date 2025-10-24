# Oracle Database Setup Instructions

## Prerequisites

Before setting up the Library Management System database, ensure you have:

1. **Oracle Database** installed (11g or higher recommended)
   - Oracle Database XE (Express Edition) - Free
   - Oracle Database Standard/Enterprise Edition
   - Oracle Cloud Database

2. **Oracle SQL Developer** installed
   - Download from: https://www.oracle.com/database/sqldeveloper/
   - Version 20.2 or higher recommended

3. **System Requirements**
   - Minimum 2GB RAM
   - 5GB free disk space
   - Windows, macOS, or Linux operating system

---

## Installation Steps

### Step 1: Install Oracle Database

#### Option A: Oracle Database XE (Recommended for Development)

1. Download Oracle Database XE from:
   ```
   https://www.oracle.com/database/technologies/xe-downloads.html
   ```

2. Run the installer and follow the installation wizard

3. Set the password for SYS and SYSTEM users during installation
   - Remember this password - you'll need it later

4. Complete the installation and note the connection details:
   - Hostname: localhost
   - Port: 1521 (default)
   - SID/Service Name: XE

#### Option B: Oracle Cloud Database

1. Sign up for Oracle Cloud Free Tier at:
   ```
   https://www.oracle.com/cloud/free/
   ```

2. Create an Autonomous Database instance

3. Download the wallet file for secure connections

4. Note your database connection string

---

### Step 2: Install Oracle SQL Developer

1. Download SQL Developer from:
   ```
   https://www.oracle.com/database/sqldeveloper/
   ```

2. Extract the downloaded ZIP file to a location (e.g., C:\SQLDeveloper)

3. Launch SQL Developer:
   - Windows: Run `sqldeveloper.exe`
   - macOS/Linux: Run `sqldeveloper.sh`

4. On first launch, you may need to provide Java JDK path
   - SQL Developer requires Java JDK 8 or higher

---

### Step 3: Create Database Connection in SQL Developer

1. Open Oracle SQL Developer

2. Click the **green plus icon** (New Connection) in the Connections panel

3. Enter connection details:
   ```
   Connection Name: LibraryDB
   Username: SYSTEM
   Password: [Your database password]
   Connection Type: Basic
   Hostname: localhost
   Port: 1521
   SID: XE (or your service name)
   ```

4. Click **Test** to verify the connection

5. If successful, click **Connect**

---

### Step 4: Create Library Database User

1. In SQL Developer, connect as SYSTEM user

2. Create a new user for the library system:

```sql
-- Create the library user
CREATE USER library_admin IDENTIFIED BY YourSecurePassword123;

-- Grant necessary privileges
GRANT CONNECT, RESOURCE TO library_admin;
GRANT CREATE VIEW TO library_admin;
GRANT CREATE SYNONYM TO library_admin;
GRANT CREATE PROCEDURE TO library_admin;
GRANT CREATE TRIGGER TO library_admin;
GRANT CREATE SEQUENCE TO library_admin;

-- Grant unlimited tablespace (for development)
-- In production, specify quota on specific tablespace
GRANT UNLIMITED TABLESPACE TO library_admin;

-- Grant additional system privileges
GRANT CREATE SESSION TO library_admin;
GRANT CREATE TABLE TO library_admin;
```

3. Create a new connection for the library_admin user:
   ```
   Connection Name: LibraryAdmin
   Username: library_admin
   Password: YourSecurePassword123
   (other details same as SYSTEM connection)
   ```

---

### Step 5: Execute Database Scripts

#### 5.1 Create Tables and Sequences

1. Connect as **library_admin** user in SQL Developer

2. Open the DDL script:
   - File → Open → Navigate to `sql/ddl/01_create_tables.sql`

3. Review the script content

4. Execute the script:
   - Click the **Run Script** button (F5) or press F5
   - Alternatively, click the green play button

5. Verify execution:
   - Check the Script Output panel for any errors
   - All statements should execute successfully

6. Verify tables were created:
```sql
SELECT table_name FROM user_tables ORDER BY table_name;
```

Expected output:
- AUTHORS
- BOOKS
- CATEGORIES
- LOANS
- MEMBERS
- RESERVATIONS

#### 5.2 Insert Sample Data

1. Open the DML script:
   - File → Open → `sql/dml/01_insert_data.sql`

2. Execute the script (F5)

3. Verify data insertion:
```sql
SELECT 'Members' AS table_name, COUNT(*) AS record_count FROM MEMBERS
UNION ALL
SELECT 'Authors', COUNT(*) FROM AUTHORS
UNION ALL
SELECT 'Categories', COUNT(*) FROM CATEGORIES
UNION ALL
SELECT 'Books', COUNT(*) FROM BOOKS
UNION ALL
SELECT 'Loans', COUNT(*) FROM LOANS
UNION ALL
SELECT 'Reservations', COUNT(*) FROM RESERVATIONS;
```

#### 5.3 Create PL/SQL Procedures

1. Open the procedures script:
   - File → Open → `plsql/procedures/01_library_procedures.sql`

2. Execute the script (F5)

3. Verify procedures:
```sql
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type = 'PROCEDURE'
ORDER BY object_name;
```

Expected procedures:
- SP_ADD_MEMBER
- SP_BORROW_BOOK
- SP_EXPIRE_OLD_RESERVATIONS
- SP_RESERVE_BOOK
- SP_RETURN_BOOK
- SP_UPDATE_OVERDUE_LOANS

#### 5.4 Create PL/SQL Functions

1. Open the functions script:
   - File → Open → `plsql/functions/01_library_functions.sql`

2. Execute the script (F5)

3. Verify functions:
```sql
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type = 'FUNCTION'
ORDER BY object_name;
```

#### 5.5 Create Database Triggers

1. Open the triggers script:
   - File → Open → `plsql/triggers/01_library_triggers.sql`

2. Execute the script (F5)

3. Verify triggers:
```sql
SELECT trigger_name, table_name, triggering_event, status
FROM user_triggers
ORDER BY table_name, trigger_name;
```

---

### Step 6: Test the System

1. Enable DBMS_OUTPUT to see procedure messages:
```sql
SET SERVEROUTPUT ON;
```

2. Open and execute usage examples:
   - File → Open → `plsql/usage_examples.sql`
   - Run the script or execute individual examples

3. Test CRUD operations:
   - Open `sql/crud/01_create_operations.sql` and execute
   - Open `sql/crud/02_read_operations.sql` and execute
   - Open `sql/crud/03_update_operations.sql` and execute

---

## Verification Checklist

After setup, verify the following:

- [ ] All 6 tables created successfully
- [ ] All 6 sequences created successfully
- [ ] All indexes created successfully
- [ ] Sample data inserted (8+ members, 10+ authors, 10+ categories, 12+ books)
- [ ] All 6 procedures compiled successfully (status: VALID)
- [ ] All 11 functions compiled successfully (status: VALID)
- [ ] All triggers compiled successfully (status: ENABLED)
- [ ] Test queries return expected results
- [ ] CRUD operations work correctly

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "ORA-01031: insufficient privileges"

**Solution:** Ensure proper grants were executed:
```sql
-- Connect as SYSTEM and re-grant privileges
GRANT CONNECT, RESOURCE TO library_admin;
GRANT CREATE VIEW, CREATE SYNONYM TO library_admin;
GRANT CREATE PROCEDURE, CREATE TRIGGER TO library_admin;
```

#### Issue 2: "ORA-00942: table or view does not exist"

**Solution:** 
- Verify you're connected as the correct user (library_admin)
- Check if tables were created: `SELECT * FROM user_tables;`
- Re-run the DDL script if needed

#### Issue 3: "ORA-04043: object [name] does not exist"

**Solution:**
- Sequences/procedures may not have been created
- Check object status: `SELECT object_name, object_type, status FROM user_objects;`
- Re-run the appropriate creation script

#### Issue 4: "PLS-00201: identifier must be declared"

**Solution:**
- Functions or procedures may not be compiled
- Check compilation errors: `SELECT * FROM user_errors;`
- Fix errors and recompile

#### Issue 5: Triggers not firing

**Solution:**
```sql
-- Check trigger status
SELECT trigger_name, status FROM user_triggers;

-- Enable triggers if disabled
ALTER TRIGGER trigger_name ENABLE;
```

#### Issue 6: "ORA-00001: unique constraint violated"

**Solution:**
- You may be re-running insert scripts
- Either drop and recreate tables, or comment out duplicate inserts
- Use MERGE statements for upsert operations

---

## Best Practices

### 1. Regular Backups

```sql
-- Export schema using SQL Developer:
-- Tools → Database Export
-- Select schema and objects to export

-- Or use Data Pump
expdp library_admin/password DIRECTORY=backup_dir DUMPFILE=library_backup.dmp
```

### 2. Monitor Database Size

```sql
-- Check tablespace usage
SELECT tablespace_name, 
       ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
FROM user_segments
GROUP BY tablespace_name;
```

### 3. Regular Statistics Gathering

```sql
-- Gather statistics for better query performance
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname => 'LIBRARY_ADMIN',
        options => 'GATHER AUTO'
    );
END;
/
```

### 4. Monitor Invalid Objects

```sql
-- Check for invalid objects
SELECT object_name, object_type 
FROM user_objects 
WHERE status = 'INVALID';

-- Recompile invalid objects
BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA('LIBRARY_ADMIN');
END;
/
```

### 5. Archive Old Data

```sql
-- Archive loans older than 2 years
CREATE TABLE loans_archive AS
SELECT * FROM loans 
WHERE loan_date < ADD_MONTHS(SYSDATE, -24);

-- Delete archived records
DELETE FROM loans 
WHERE loan_date < ADD_MONTHS(SYSDATE, -24);
COMMIT;
```

---

## Configuration for Production

### Security Hardening

1. **Change Default Passwords**
```sql
ALTER USER library_admin IDENTIFIED BY NewStrongPassword123!;
```

2. **Restrict Privileges**
```sql
-- Remove unnecessary privileges
REVOKE UNLIMITED TABLESPACE FROM library_admin;
ALTER USER library_admin QUOTA 1G ON USERS;
```

3. **Enable Auditing**
```sql
AUDIT SELECT, INSERT, UPDATE, DELETE ON members BY ACCESS;
AUDIT EXECUTE ON sp_borrow_book BY ACCESS;
```

### Performance Tuning

1. **Review Execution Plans**
```sql
EXPLAIN PLAN FOR
SELECT * FROM books WHERE author_id = 1;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

2. **Add Additional Indexes** (if needed based on query patterns)
```sql
CREATE INDEX idx_loan_return_date ON loans(return_date);
```

3. **Enable Query Result Cache** (Oracle 11g+)
```sql
ALTER SYSTEM SET RESULT_CACHE_MODE = FORCE;
```

---

## Maintenance Schedule

### Daily
- Monitor database alerts and logs
- Check for failed jobs

### Weekly
- Review slow-running queries
- Check tablespace usage
- Review invalid objects

### Monthly
- Gather database statistics
- Review and optimize indexes
- Archive old transaction data
- Perform database backup

### Quarterly
- Review and update data retention policies
- Audit user privileges
- Performance tuning review
- Database health check

---

## Support and Resources

### Documentation
- Oracle Database Documentation: https://docs.oracle.com/database/
- SQL Developer Documentation: https://docs.oracle.com/en/database/oracle/sql-developer/

### Community Resources
- Oracle Community Forums: https://community.oracle.com/
- Stack Overflow Oracle Tag: https://stackoverflow.com/questions/tagged/oracle
- Oracle Learning Library: https://apexapps.oracle.com/pls/apex/f?p=44785

### Training
- Oracle University: https://education.oracle.com/
- Oracle Live SQL: https://livesql.oracle.com/

---

## Next Steps

After successful setup:

1. Explore the database structure using SQL Developer's object browser
2. Run sample queries from `sql/crud/02_read_operations.sql`
3. Test procedures and functions from `plsql/usage_examples.sql`
4. Review the database schema documentation in `docs/DATABASE_SCHEMA.md`
5. Customize the system for your specific requirements
6. Consider implementing additional features based on your needs

---

## Contact and Support

For issues or questions about this database system:
- Review the documentation in the `docs/` folder
- Check the usage examples in `plsql/usage_examples.sql`
- Examine the SQL scripts for implementation details
