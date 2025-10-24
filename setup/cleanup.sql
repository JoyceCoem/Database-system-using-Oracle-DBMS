-- =====================================================
-- Library Management System - Cleanup Script
-- WARNING: This will drop all database objects!
-- =====================================================

SET SERVEROUTPUT ON;
SET VERIFY OFF;

PROMPT ========================================================
PROMPT Library Management System - Database Cleanup
PROMPT ========================================================
PROMPT
PROMPT WARNING: This script will DROP ALL database objects
PROMPT including tables, sequences, procedures, functions,
PROMPT and triggers. ALL DATA WILL BE LOST!
PROMPT
PROMPT ========================================================

-- Prompt for confirmation
ACCEPT confirm_cleanup CHAR PROMPT 'Are you ABSOLUTELY SURE you want to continue? (YES/NO): '

-- Check confirmation
BEGIN
    IF UPPER('&confirm_cleanup') != 'YES' THEN
        RAISE_APPLICATION_ERROR(-20000, 'Cleanup cancelled by user');
    END IF;
END;
/

PROMPT
PROMPT Starting cleanup process...
PROMPT

-- =====================================================
-- Drop Triggers
-- =====================================================

PROMPT Dropping triggers...

BEGIN
    FOR t IN (SELECT trigger_name FROM user_triggers) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || t.trigger_name;
        DBMS_OUTPUT.PUT_LINE('Dropped trigger: ' || t.trigger_name);
    END LOOP;
END;
/

-- =====================================================
-- Drop Procedures
-- =====================================================

PROMPT Dropping procedures...

BEGIN
    FOR p IN (SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE') LOOP
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || p.object_name;
        DBMS_OUTPUT.PUT_LINE('Dropped procedure: ' || p.object_name);
    END LOOP;
END;
/

-- =====================================================
-- Drop Functions
-- =====================================================

PROMPT Dropping functions...

BEGIN
    FOR f IN (SELECT object_name FROM user_objects WHERE object_type = 'FUNCTION') LOOP
        EXECUTE IMMEDIATE 'DROP FUNCTION ' || f.object_name;
        DBMS_OUTPUT.PUT_LINE('Dropped function: ' || f.object_name);
    END LOOP;
END;
/

-- =====================================================
-- Drop Tables
-- =====================================================

PROMPT Dropping tables...

BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Dropped table: ' || t.table_name);
    END LOOP;
END;
/

-- =====================================================
-- Drop Sequences
-- =====================================================

PROMPT Dropping sequences...

BEGIN
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
        DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || s.sequence_name);
    END LOOP;
END;
/

-- =====================================================
-- Verification
-- =====================================================

PROMPT
PROMPT ========================================================
PROMPT Cleanup Verification
PROMPT ========================================================

PROMPT
PROMPT Remaining Tables:
SELECT COUNT(*) AS table_count FROM user_tables;

PROMPT
PROMPT Remaining Sequences:
SELECT COUNT(*) AS sequence_count FROM user_sequences;

PROMPT
PROMPT Remaining Procedures:
SELECT COUNT(*) AS procedure_count FROM user_objects WHERE object_type = 'PROCEDURE';

PROMPT
PROMPT Remaining Functions:
SELECT COUNT(*) AS function_count FROM user_objects WHERE object_type = 'FUNCTION';

PROMPT
PROMPT Remaining Triggers:
SELECT COUNT(*) AS trigger_count FROM user_triggers;

PROMPT
PROMPT ========================================================
PROMPT Cleanup Complete!
PROMPT ========================================================
PROMPT
PROMPT All database objects have been removed.
PROMPT To recreate the database, run: @setup/master_setup.sql
PROMPT
PROMPT ========================================================
