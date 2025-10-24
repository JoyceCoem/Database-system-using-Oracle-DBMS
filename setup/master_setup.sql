-- =====================================================
-- Library Management System - Master Setup Script
-- Execute this script to set up the entire database
-- =====================================================

-- Enable output
SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Display start message
PROMPT ========================================================
PROMPT Library Management System - Complete Setup
PROMPT ========================================================
PROMPT
PROMPT This script will:
PROMPT 1. Drop existing objects (if any)
PROMPT 2. Create all tables and sequences
PROMPT 3. Insert sample data
PROMPT 4. Create PL/SQL procedures
PROMPT 5. Create PL/SQL functions
PROMPT 6. Create database triggers
PROMPT
PROMPT ========================================================

-- Prompt for confirmation
ACCEPT continue_setup CHAR PROMPT 'Continue with setup? (Y/N): '

-- Check if user wants to continue
WHENEVER SQLERROR EXIT SQL.SQLCODE

BEGIN
    IF UPPER('&continue_setup') != 'Y' THEN
        RAISE_APPLICATION_ERROR(-20000, 'Setup cancelled by user');
    END IF;
END;
/

-- =====================================================
-- Step 1: Create Tables and Sequences
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Step 1: Creating Tables and Sequences
PROMPT ========================================================

@@sql/ddl/01_create_tables.sql

PROMPT
PROMPT Tables and sequences created successfully!
PROMPT

-- =====================================================
-- Step 2: Insert Sample Data
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Step 2: Inserting Sample Data
PROMPT ========================================================

@@sql/dml/01_insert_data.sql

PROMPT
PROMPT Sample data inserted successfully!
PROMPT

-- =====================================================
-- Step 3: Create PL/SQL Procedures
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Step 3: Creating PL/SQL Procedures
PROMPT ========================================================

@@plsql/procedures/01_library_procedures.sql

PROMPT
PROMPT Procedures created successfully!
PROMPT

-- =====================================================
-- Step 4: Create PL/SQL Functions
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Step 4: Creating PL/SQL Functions
PROMPT ========================================================

@@plsql/functions/01_library_functions.sql

PROMPT
PROMPT Functions created successfully!
PROMPT

-- =====================================================
-- Step 5: Create Database Triggers
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Step 5: Creating Database Triggers
PROMPT ========================================================

@@plsql/triggers/01_library_triggers.sql

PROMPT
PROMPT Triggers created successfully!
PROMPT

-- =====================================================
-- Verification
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Verification Summary
PROMPT ========================================================
PROMPT

-- Check tables
PROMPT Tables Created:
SELECT table_name FROM user_tables ORDER BY table_name;

PROMPT
PROMPT Sequences Created:
SELECT sequence_name FROM user_sequences ORDER BY sequence_name;

PROMPT
PROMPT Procedures Created:
SELECT object_name, status FROM user_objects 
WHERE object_type = 'PROCEDURE' 
ORDER BY object_name;

PROMPT
PROMPT Functions Created:
SELECT object_name, status FROM user_objects 
WHERE object_type = 'FUNCTION' 
ORDER BY object_name;

PROMPT
PROMPT Triggers Created:
SELECT trigger_name, status FROM user_triggers 
ORDER BY trigger_name;

PROMPT
PROMPT Record Counts:
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
SELECT 'Reservations', COUNT(*) FROM RESERVATIONS
ORDER BY table_name;

-- =====================================================
-- Check for Invalid Objects
-- =====================================================

PROMPT
PROMPT Checking for Invalid Objects:

SELECT object_name, object_type, status
FROM user_objects
WHERE status = 'INVALID'
ORDER BY object_type, object_name;

PROMPT
PROMPT ========================================================
PROMPT Setup Complete!
PROMPT ========================================================
PROMPT
PROMPT Next Steps:
PROMPT 1. Review the verification summary above
PROMPT 2. Run usage examples: @plsql/usage_examples.sql
PROMPT 3. Test CRUD operations in sql/crud/ folder
PROMPT 4. Review documentation in docs/ folder
PROMPT
PROMPT For help, see docs/SETUP_INSTRUCTIONS.md
PROMPT ========================================================
