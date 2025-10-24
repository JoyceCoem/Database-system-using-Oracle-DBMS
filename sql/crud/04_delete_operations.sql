-- =====================================================
-- Library Management System - CRUD Operations
-- DELETE Operations
-- =====================================================

-- =====================================================
-- Delete expired reservations
-- =====================================================
DELETE FROM RESERVATIONS
WHERE reservation_status = 'EXPIRED'
AND reservation_date < ADD_MONTHS(SYSDATE, -6);

-- =====================================================
-- Delete cancelled reservations older than 3 months
-- =====================================================
DELETE FROM RESERVATIONS
WHERE reservation_status = 'CANCELLED'
AND reservation_date < ADD_MONTHS(SYSDATE, -3);

-- =====================================================
-- Delete old returned loans (older than 2 years)
-- This maintains historical data for recent transactions
-- =====================================================
DELETE FROM LOANS
WHERE loan_status = 'RETURNED'
AND return_date < ADD_MONTHS(SYSDATE, -24);

-- =====================================================
-- Delete a specific reservation (soft delete - change status)
-- Preferred over hard delete to maintain data integrity
-- =====================================================
UPDATE RESERVATIONS
SET reservation_status = 'CANCELLED',
    updated_date = SYSDATE
WHERE reservation_id = 2;

-- =====================================================
-- Remove inactive members (no activity for 5 years)
-- First, check if they have any active loans or reservations
-- =====================================================
DELETE FROM MEMBERS
WHERE membership_status = 'INACTIVE'
AND membership_date < ADD_MONTHS(SYSDATE, -60)
AND member_id NOT IN (
    SELECT DISTINCT member_id FROM LOANS WHERE loan_status IN ('ACTIVE', 'OVERDUE')
    UNION
    SELECT DISTINCT member_id FROM RESERVATIONS WHERE reservation_status = 'PENDING'
);

-- =====================================================
-- Delete a category (only if no books are assigned)
-- =====================================================
DELETE FROM CATEGORIES
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM BOOKS)
AND category_name = 'Outdated Category';

-- =====================================================
-- Delete a book (CAUTION: Should only be done if book is lost/destroyed)
-- First ensure no active loans or reservations exist
-- =====================================================
-- Example: Delete book with ID 99 (assuming it doesn't exist in sample data)
DELETE FROM BOOKS
WHERE book_id = 99
AND book_id NOT IN (
    SELECT DISTINCT book_id FROM LOANS WHERE loan_status IN ('ACTIVE', 'OVERDUE')
    UNION
    SELECT DISTINCT book_id FROM RESERVATIONS WHERE reservation_status = 'PENDING'
);

-- =====================================================
-- Delete test data (example for development environment)
-- CAUTION: Use with care in production
-- =====================================================
-- Uncomment below to delete test members
/*
DELETE FROM RESERVATIONS WHERE member_id IN (
    SELECT member_id FROM MEMBERS WHERE email LIKE '%test%'
);

DELETE FROM LOANS WHERE member_id IN (
    SELECT member_id FROM MEMBERS WHERE email LIKE '%test%'
);

DELETE FROM MEMBERS WHERE email LIKE '%test%';
*/

COMMIT;

-- Display confirmation and counts
SELECT 'DELETE operations completed successfully!' AS STATUS FROM DUAL;

-- Show remaining record counts
SELECT 'Members' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT FROM MEMBERS
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
