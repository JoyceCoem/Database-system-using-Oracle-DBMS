-- =====================================================
-- Library Management System - CRUD Operations
-- UPDATE Operations
-- =====================================================

-- =====================================================
-- Update member information
-- =====================================================
UPDATE MEMBERS
SET phone = '555-9999',
    address = '999 Updated St',
    city = 'Updated City',
    updated_date = SYSDATE
WHERE email = 'john.smith@email.com';

-- =====================================================
-- Update member status
-- =====================================================
UPDATE MEMBERS
SET membership_status = 'SUSPENDED',
    updated_date = SYSDATE
WHERE member_id = 5;

-- =====================================================
-- Update member max books allowed
-- =====================================================
UPDATE MEMBERS
SET max_books_allowed = 10,
    updated_date = SYSDATE
WHERE membership_status = 'ACTIVE' 
AND member_id IN (SELECT member_id FROM MEMBERS WHERE TRUNC(SYSDATE - membership_date) > 365);

-- =====================================================
-- Update book information
-- =====================================================
UPDATE BOOKS
SET publisher = 'New Publisher Name',
    updated_date = SYSDATE
WHERE isbn = '978-0-452-28423-4';

-- =====================================================
-- Update book copies when new copies arrive
-- =====================================================
UPDATE BOOKS
SET copies_total = copies_total + 2,
    copies_available = copies_available + 2,
    updated_date = SYSDATE
WHERE book_id = 1;

-- =====================================================
-- Update book status to maintenance
-- =====================================================
UPDATE BOOKS
SET book_status = 'MAINTENANCE',
    copies_available = copies_available - 1,
    updated_date = SYSDATE
WHERE book_id = 6 AND copies_available > 0;

-- =====================================================
-- Update loan when book is returned
-- =====================================================
UPDATE LOANS
SET return_date = SYSDATE,
    loan_status = 'RETURNED',
    updated_date = SYSDATE
WHERE loan_id = 4;

-- Update book availability when loan is returned
UPDATE BOOKS
SET copies_available = copies_available + 1,
    book_status = CASE 
        WHEN copies_available + 1 > 0 THEN 'AVAILABLE'
        ELSE book_status
    END,
    updated_date = SYSDATE
WHERE book_id = (SELECT book_id FROM LOANS WHERE loan_id = 4);

-- =====================================================
-- Update overdue loan status and calculate fine
-- =====================================================
UPDATE LOANS
SET loan_status = 'OVERDUE',
    fine_amount = GREATEST(0, TRUNC(SYSDATE - due_date)) * 0.50,
    updated_date = SYSDATE
WHERE loan_status = 'ACTIVE' 
AND due_date < SYSDATE
AND return_date IS NULL;

-- =====================================================
-- Update reservation status to fulfilled
-- =====================================================
UPDATE RESERVATIONS
SET reservation_status = 'FULFILLED',
    updated_date = SYSDATE
WHERE reservation_id = 1;

-- =====================================================
-- Update expired reservations
-- =====================================================
UPDATE RESERVATIONS
SET reservation_status = 'EXPIRED',
    updated_date = SYSDATE
WHERE reservation_status = 'PENDING'
AND expiry_date < SYSDATE;

-- =====================================================
-- Update author information
-- =====================================================
UPDATE AUTHORS
SET biography = 'Updated biography with more detailed information',
    updated_date = SYSDATE
WHERE author_id = 1;

-- =====================================================
-- Update category description
-- =====================================================
UPDATE CATEGORIES
SET description = 'Updated category description',
    updated_date = SYSDATE
WHERE category_name = 'Fiction';

COMMIT;

-- Display confirmation
SELECT 'UPDATE operations completed successfully!' AS STATUS FROM DUAL;
