-- =====================================================
-- Library Management System - PL/SQL Functions
-- Calculations and Validations
-- =====================================================

-- =====================================================
-- Function: Calculate Fine Amount
-- Description: Calculates fine for overdue books
-- =====================================================

CREATE OR REPLACE FUNCTION fn_calculate_fine (
    p_due_date IN DATE,
    p_return_date IN DATE DEFAULT SYSDATE,
    p_fine_per_day IN NUMBER DEFAULT 0.50
) RETURN NUMBER
AS
    v_days_overdue NUMBER;
    v_fine_amount NUMBER;
BEGIN
    -- Calculate days overdue
    v_days_overdue := TRUNC(p_return_date - p_due_date);
    
    -- If not overdue, return 0
    IF v_days_overdue <= 0 THEN
        RETURN 0;
    END IF;
    
    -- Calculate fine
    v_fine_amount := v_days_overdue * p_fine_per_day;
    
    RETURN v_fine_amount;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_calculate_fine;
/

-- =====================================================
-- Function: Check Book Availability
-- Description: Returns TRUE if book is available for borrowing
-- =====================================================

CREATE OR REPLACE FUNCTION fn_is_book_available (
    p_book_id IN NUMBER
) RETURN BOOLEAN
AS
    v_copies_available NUMBER;
    v_book_status VARCHAR2(20);
BEGIN
    SELECT copies_available, book_status
    INTO v_copies_available, v_book_status
    FROM BOOKS
    WHERE book_id = p_book_id;
    
    IF v_copies_available > 0 AND v_book_status IN ('AVAILABLE', 'RESERVED') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RETURN FALSE;
END fn_is_book_available;
/

-- =====================================================
-- Function: Get Member Active Loans Count
-- Description: Returns number of active loans for a member
-- =====================================================

CREATE OR REPLACE FUNCTION fn_get_active_loans_count (
    p_member_id IN NUMBER
) RETURN NUMBER
AS
    v_loan_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_loan_count
    FROM LOANS
    WHERE member_id = p_member_id
    AND loan_status = 'ACTIVE';
    
    RETURN v_loan_count;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_get_active_loans_count;
/

-- =====================================================
-- Function: Get Member Total Fines
-- Description: Returns total outstanding fines for a member
-- =====================================================

CREATE OR REPLACE FUNCTION fn_get_member_fines (
    p_member_id IN NUMBER
) RETURN NUMBER
AS
    v_total_fines NUMBER;
BEGIN
    SELECT NVL(SUM(fine_amount), 0)
    INTO v_total_fines
    FROM LOANS
    WHERE member_id = p_member_id
    AND loan_status IN ('ACTIVE', 'OVERDUE');
    
    RETURN v_total_fines;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_get_member_fines;
/

-- =====================================================
-- Function: Can Member Borrow
-- Description: Checks if member can borrow books
-- =====================================================

CREATE OR REPLACE FUNCTION fn_can_member_borrow (
    p_member_id IN NUMBER
) RETURN VARCHAR2
AS
    v_member_status VARCHAR2(20);
    v_max_books NUMBER;
    v_active_loans NUMBER;
    v_total_fines NUMBER;
BEGIN
    -- Get member information
    BEGIN
        SELECT membership_status, max_books_allowed
        INTO v_member_status, v_max_books
        FROM MEMBERS
        WHERE member_id = p_member_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO: Member not found';
    END;
    
    -- Check member status
    IF v_member_status != 'ACTIVE' THEN
        RETURN 'NO: Member status is ' || v_member_status;
    END IF;
    
    -- Check active loans
    v_active_loans := fn_get_active_loans_count(p_member_id);
    IF v_active_loans >= v_max_books THEN
        RETURN 'NO: Maximum books limit reached (' || v_max_books || ')';
    END IF;
    
    -- Check for outstanding fines
    v_total_fines := fn_get_member_fines(p_member_id);
    IF v_total_fines > 0 THEN
        RETURN 'NO: Outstanding fines $' || TO_CHAR(v_total_fines, '999.99');
    END IF;
    
    RETURN 'YES: Member can borrow books';
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;
END fn_can_member_borrow;
/

-- =====================================================
-- Function: Get Book Loan History Count
-- Description: Returns number of times a book has been borrowed
-- =====================================================

CREATE OR REPLACE FUNCTION fn_get_book_loan_count (
    p_book_id IN NUMBER
) RETURN NUMBER
AS
    v_loan_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_loan_count
    FROM LOANS
    WHERE book_id = p_book_id;
    
    RETURN v_loan_count;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_get_book_loan_count;
/

-- =====================================================
-- Function: Get Days Until Due
-- Description: Calculates days remaining until loan is due
-- =====================================================

CREATE OR REPLACE FUNCTION fn_days_until_due (
    p_loan_id IN NUMBER
) RETURN NUMBER
AS
    v_due_date DATE;
    v_days_remaining NUMBER;
BEGIN
    SELECT due_date
    INTO v_due_date
    FROM LOANS
    WHERE loan_id = p_loan_id
    AND loan_status = 'ACTIVE';
    
    v_days_remaining := TRUNC(v_due_date - SYSDATE);
    
    RETURN v_days_remaining;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END fn_days_until_due;
/

-- =====================================================
-- Function: Format Member Name
-- Description: Returns formatted full name of member
-- =====================================================

CREATE OR REPLACE FUNCTION fn_format_member_name (
    p_member_id IN NUMBER
) RETURN VARCHAR2
AS
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
BEGIN
    SELECT first_name, last_name
    INTO v_first_name, v_last_name
    FROM MEMBERS
    WHERE member_id = p_member_id;
    
    RETURN v_last_name || ', ' || v_first_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Member';
    WHEN OTHERS THEN
        RETURN 'Error';
END fn_format_member_name;
/

-- =====================================================
-- Function: Get Book Title with Author
-- Description: Returns formatted book title with author name
-- =====================================================

CREATE OR REPLACE FUNCTION fn_get_book_with_author (
    p_book_id IN NUMBER
) RETURN VARCHAR2
AS
    v_title VARCHAR2(200);
    v_author_name VARCHAR2(100);
BEGIN
    SELECT b.title, a.first_name || ' ' || a.last_name
    INTO v_title, v_author_name
    FROM BOOKS b
    JOIN AUTHORS a ON b.author_id = a.author_id
    WHERE b.book_id = p_book_id;
    
    RETURN v_title || ' by ' || v_author_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Book';
    WHEN OTHERS THEN
        RETURN 'Error';
END fn_get_book_with_author;
/

-- =====================================================
-- Function: Validate Email Format
-- Description: Validates email address format
-- =====================================================

CREATE OR REPLACE FUNCTION fn_validate_email (
    p_email IN VARCHAR2
) RETURN BOOLEAN
AS
    v_at_count NUMBER;
    v_dot_after_at NUMBER;
BEGIN
    -- Check for @ symbol
    v_at_count := LENGTH(p_email) - LENGTH(REPLACE(p_email, '@', ''));
    
    IF v_at_count != 1 THEN
        RETURN FALSE;
    END IF;
    
    -- Check for dot after @
    v_dot_after_at := INSTR(p_email, '.', INSTR(p_email, '@'));
    
    IF v_dot_after_at = 0 THEN
        RETURN FALSE;
    END IF;
    
    -- Check minimum length
    IF LENGTH(p_email) < 5 THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END fn_validate_email;
/

-- =====================================================
-- Function: Calculate Membership Duration
-- Description: Returns number of days since membership started
-- =====================================================

CREATE OR REPLACE FUNCTION fn_membership_duration (
    p_member_id IN NUMBER
) RETURN NUMBER
AS
    v_membership_date DATE;
    v_duration NUMBER;
BEGIN
    SELECT membership_date
    INTO v_membership_date
    FROM MEMBERS
    WHERE member_id = p_member_id;
    
    v_duration := TRUNC(SYSDATE - v_membership_date);
    
    RETURN v_duration;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END fn_membership_duration;
/

-- Display confirmation
SELECT 'PL/SQL Functions created successfully!' AS STATUS FROM DUAL;
