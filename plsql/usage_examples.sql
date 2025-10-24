-- =====================================================
-- Library Management System - Usage Examples
-- Demonstrations of Procedures, Functions, and Queries
-- =====================================================

SET SERVEROUTPUT ON;

-- =====================================================
-- Example 1: Add a New Member
-- =====================================================

DECLARE
    v_result VARCHAR2(500);
BEGIN
    sp_add_member(
        p_first_name => 'Tom',
        p_last_name => 'Hardy',
        p_email => 'tom.hardy@email.com',
        p_phone => '555-0301',
        p_address => '789 Actor Ave',
        p_city => 'Los Angeles',
        p_state => 'CA',
        p_zip_code => '90210',
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- =====================================================
-- Example 2: Borrow a Book
-- =====================================================

DECLARE
    v_result VARCHAR2(500);
BEGIN
    -- Member ID 1 borrows Book ID 5 (Harry Potter) for 14 days
    sp_borrow_book(
        p_member_id => 1,
        p_book_id => 5,
        p_loan_days => 14,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- =====================================================
-- Example 3: Check if Member Can Borrow
-- =====================================================

DECLARE
    v_result VARCHAR2(500);
BEGIN
    v_result := fn_can_member_borrow(1);
    DBMS_OUTPUT.PUT_LINE('Member 1 Status: ' || v_result);
    
    v_result := fn_can_member_borrow(5);
    DBMS_OUTPUT.PUT_LINE('Member 5 Status: ' || v_result);
END;
/

-- =====================================================
-- Example 4: Calculate Fine for Overdue Book
-- =====================================================

DECLARE
    v_fine NUMBER;
BEGIN
    -- Calculate fine for book due 10 days ago
    v_fine := fn_calculate_fine(
        p_due_date => SYSDATE - 10,
        p_return_date => SYSDATE
    );
    DBMS_OUTPUT.PUT_LINE('Fine for 10 days overdue: $' || TO_CHAR(v_fine, '999.99'));
    
    -- Calculate fine for book returned on time
    v_fine := fn_calculate_fine(
        p_due_date => SYSDATE + 5,
        p_return_date => SYSDATE
    );
    DBMS_OUTPUT.PUT_LINE('Fine for on-time return: $' || TO_CHAR(v_fine, '999.99'));
END;
/

-- =====================================================
-- Example 5: Reserve a Book
-- =====================================================

DECLARE
    v_result VARCHAR2(500);
BEGIN
    sp_reserve_book(
        p_member_id => 1,
        p_book_id => 7,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- =====================================================
-- Example 6: Return a Book
-- =====================================================

DECLARE
    v_result VARCHAR2(500);
BEGIN
    -- Return loan ID 2
    sp_return_book(
        p_loan_id => 2,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- =====================================================
-- Example 7: Get Active Loan Count for Member
-- =====================================================

DECLARE
    v_loan_count NUMBER;
BEGIN
    v_loan_count := fn_get_active_loans_count(1);
    DBMS_OUTPUT.PUT_LINE('Member 1 has ' || v_loan_count || ' active loans');
    
    v_loan_count := fn_get_active_loans_count(3);
    DBMS_OUTPUT.PUT_LINE('Member 3 has ' || v_loan_count || ' active loans');
END;
/

-- =====================================================
-- Example 8: Get Member Total Fines
-- =====================================================

DECLARE
    v_fines NUMBER;
BEGIN
    v_fines := fn_get_member_fines(4);
    DBMS_OUTPUT.PUT_LINE('Member 4 total fines: $' || TO_CHAR(v_fines, '999.99'));
END;
/

-- =====================================================
-- Example 9: Update Overdue Loans (Batch Operation)
-- =====================================================

DECLARE
    v_updated_count NUMBER;
BEGIN
    sp_update_overdue_loans(v_updated_count);
    DBMS_OUTPUT.PUT_LINE(v_updated_count || ' loans marked as overdue');
END;
/

-- =====================================================
-- Example 10: Expire Old Reservations (Batch Operation)
-- =====================================================

DECLARE
    v_expired_count NUMBER;
BEGIN
    sp_expire_old_reservations(v_expired_count);
    DBMS_OUTPUT.PUT_LINE(v_expired_count || ' reservations expired');
END;
/

-- =====================================================
-- Example 11: Get Book Details with Author
-- =====================================================

DECLARE
    v_book_info VARCHAR2(500);
BEGIN
    v_book_info := fn_get_book_with_author(1);
    DBMS_OUTPUT.PUT_LINE('Book 1: ' || v_book_info);
    
    v_book_info := fn_get_book_with_author(5);
    DBMS_OUTPUT.PUT_LINE('Book 5: ' || v_book_info);
END;
/

-- =====================================================
-- Example 12: Get Formatted Member Name
-- =====================================================

DECLARE
    v_member_name VARCHAR2(200);
BEGIN
    v_member_name := fn_format_member_name(1);
    DBMS_OUTPUT.PUT_LINE('Member 1: ' || v_member_name);
    
    v_member_name := fn_format_member_name(2);
    DBMS_OUTPUT.PUT_LINE('Member 2: ' || v_member_name);
END;
/

-- =====================================================
-- Example 13: Check Book Availability
-- =====================================================

DECLARE
    v_available BOOLEAN;
BEGIN
    v_available := fn_is_book_available(1);
    IF v_available THEN
        DBMS_OUTPUT.PUT_LINE('Book 1 is available');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Book 1 is not available');
    END IF;
END;
/

-- =====================================================
-- Example 14: Get Book Loan History Count
-- =====================================================

DECLARE
    v_loan_count NUMBER;
BEGIN
    v_loan_count := fn_get_book_loan_count(5);
    DBMS_OUTPUT.PUT_LINE('Book 5 has been borrowed ' || v_loan_count || ' times');
END;
/

-- =====================================================
-- Example 15: Calculate Membership Duration
-- =====================================================

DECLARE
    v_duration NUMBER;
BEGIN
    v_duration := fn_membership_duration(1);
    DBMS_OUTPUT.PUT_LINE('Member 1 has been a member for ' || v_duration || ' days');
END;
/

-- =====================================================
-- Example 16: Get Days Until Loan Due
-- =====================================================

DECLARE
    v_days_remaining NUMBER;
BEGIN
    v_days_remaining := fn_days_until_due(3);
    IF v_days_remaining IS NOT NULL THEN
        IF v_days_remaining > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Loan 3 is due in ' || v_days_remaining || ' days');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Loan 3 is overdue by ' || ABS(v_days_remaining) || ' days');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Loan 3 not found or already returned');
    END IF;
END;
/

-- =====================================================
-- Example 17: Complex Query - Member Dashboard
-- =====================================================

SELECT 
    m.member_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    m.membership_status,
    fn_get_active_loans_count(m.member_id) AS active_loans,
    m.max_books_allowed,
    fn_get_member_fines(m.member_id) AS total_fines,
    fn_membership_duration(m.member_id) AS days_as_member,
    fn_can_member_borrow(m.member_id) AS can_borrow_status
FROM MEMBERS m
WHERE m.member_id IN (1, 2, 3, 4, 5)
ORDER BY m.member_id;

-- =====================================================
-- Example 18: Complex Query - Book Status Report
-- =====================================================

SELECT 
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    c.category_name,
    b.copies_available || ' / ' || b.copies_total AS availability,
    b.book_status,
    fn_get_book_loan_count(b.book_id) AS times_borrowed
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
ORDER BY times_borrowed DESC, b.title;

-- =====================================================
-- Example 19: Complex Query - Overdue Loans Report
-- =====================================================

SELECT 
    l.loan_id,
    fn_format_member_name(l.member_id) AS member_name,
    m.email,
    m.phone,
    fn_get_book_with_author(l.book_id) AS book_info,
    l.loan_date,
    l.due_date,
    TRUNC(SYSDATE - l.due_date) AS days_overdue,
    fn_calculate_fine(l.due_date, SYSDATE) AS calculated_fine,
    l.fine_amount AS current_fine
FROM LOANS l
JOIN MEMBERS m ON l.member_id = m.member_id
WHERE l.loan_status IN ('ACTIVE', 'OVERDUE')
AND l.due_date < SYSDATE
ORDER BY days_overdue DESC;

-- =====================================================
-- Example 20: Complex Query - Popular Books Report
-- =====================================================

SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    c.category_name,
    fn_get_book_loan_count(b.book_id) AS total_loans,
    COUNT(CASE WHEN l.loan_status = 'ACTIVE' THEN 1 END) AS currently_borrowed,
    b.copies_available,
    b.copies_total
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
LEFT JOIN LOANS l ON b.book_id = l.book_id
GROUP BY 
    b.book_id, b.title, a.first_name, a.last_name, 
    c.category_name, b.copies_available, b.copies_total
ORDER BY total_loans DESC
FETCH FIRST 10 ROWS ONLY;

-- Display completion message
SELECT 'All usage examples executed successfully!' AS STATUS FROM DUAL;
