-- =====================================================
-- Library Management System - PL/SQL Procedures
-- Business Logic Automation
-- =====================================================

-- =====================================================
-- Procedure: Borrow Book
-- Description: Handles the complete book borrowing process
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_borrow_book (
    p_member_id IN NUMBER,
    p_book_id IN NUMBER,
    p_loan_days IN NUMBER DEFAULT 14,
    p_result OUT VARCHAR2
) AS
    v_member_status VARCHAR2(20);
    v_active_loans NUMBER;
    v_max_books NUMBER;
    v_copies_available NUMBER;
    v_book_status VARCHAR2(20);
    v_overdue_fines NUMBER;
    v_loan_id NUMBER;
BEGIN
    -- Check if member exists and is active
    BEGIN
        SELECT membership_status, max_books_allowed
        INTO v_member_status, v_max_books
        FROM MEMBERS
        WHERE member_id = p_member_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: Member not found';
            RETURN;
    END;
    
    -- Check member status
    IF v_member_status != 'ACTIVE' THEN
        p_result := 'ERROR: Member status is ' || v_member_status || '. Only ACTIVE members can borrow books.';
        RETURN;
    END IF;
    
    -- Check for outstanding fines
    SELECT NVL(SUM(fine_amount), 0)
    INTO v_overdue_fines
    FROM LOANS
    WHERE member_id = p_member_id
    AND loan_status IN ('OVERDUE', 'ACTIVE');
    
    IF v_overdue_fines > 0 THEN
        p_result := 'ERROR: Member has outstanding fines of $' || TO_CHAR(v_overdue_fines, '999.99');
        RETURN;
    END IF;
    
    -- Check current active loans
    SELECT COUNT(*)
    INTO v_active_loans
    FROM LOANS
    WHERE member_id = p_member_id
    AND loan_status = 'ACTIVE';
    
    IF v_active_loans >= v_max_books THEN
        p_result := 'ERROR: Member has reached maximum allowed books (' || v_max_books || ')';
        RETURN;
    END IF;
    
    -- Check book availability
    BEGIN
        SELECT copies_available, book_status
        INTO v_copies_available, v_book_status
        FROM BOOKS
        WHERE book_id = p_book_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: Book not found';
            RETURN;
    END;
    
    IF v_copies_available <= 0 THEN
        p_result := 'ERROR: Book is not available for borrowing';
        RETURN;
    END IF;
    
    IF v_book_status NOT IN ('AVAILABLE', 'RESERVED') THEN
        p_result := 'ERROR: Book status is ' || v_book_status;
        RETURN;
    END IF;
    
    -- All validations passed, create loan
    INSERT INTO LOANS (
        loan_id, book_id, member_id, 
        loan_date, due_date, loan_status
    ) VALUES (
        seq_loan_id.NEXTVAL, p_book_id, p_member_id,
        SYSDATE, SYSDATE + p_loan_days, 'ACTIVE'
    ) RETURNING loan_id INTO v_loan_id;
    
    -- Update book availability
    UPDATE BOOKS
    SET copies_available = copies_available - 1,
        book_status = CASE 
            WHEN copies_available - 1 = 0 THEN 'BORROWED'
            ELSE 'AVAILABLE'
        END,
        updated_date = SYSDATE
    WHERE book_id = p_book_id;
    
    COMMIT;
    p_result := 'SUCCESS: Book borrowed successfully. Loan ID: ' || v_loan_id || ', Due date: ' || TO_CHAR(SYSDATE + p_loan_days, 'DD-MON-YYYY');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_borrow_book;
/

-- =====================================================
-- Procedure: Return Book
-- Description: Handles book return and fine calculation
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_return_book (
    p_loan_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
    v_loan_status VARCHAR2(20);
    v_book_id NUMBER;
    v_due_date DATE;
    v_fine_amount NUMBER := 0;
    v_days_overdue NUMBER;
    v_fine_per_day CONSTANT NUMBER := 0.50;
BEGIN
    -- Get loan details
    BEGIN
        SELECT loan_status, book_id, due_date
        INTO v_loan_status, v_book_id, v_due_date
        FROM LOANS
        WHERE loan_id = p_loan_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: Loan not found';
            RETURN;
    END;
    
    -- Check if already returned
    IF v_loan_status = 'RETURNED' THEN
        p_result := 'ERROR: Book has already been returned';
        RETURN;
    END IF;
    
    -- Calculate fine if overdue
    IF SYSDATE > v_due_date THEN
        v_days_overdue := TRUNC(SYSDATE - v_due_date);
        v_fine_amount := v_days_overdue * v_fine_per_day;
    END IF;
    
    -- Update loan record
    UPDATE LOANS
    SET return_date = SYSDATE,
        loan_status = 'RETURNED',
        fine_amount = v_fine_amount,
        updated_date = SYSDATE
    WHERE loan_id = p_loan_id;
    
    -- Update book availability
    UPDATE BOOKS
    SET copies_available = copies_available + 1,
        book_status = CASE 
            WHEN copies_available + 1 > 0 THEN 'AVAILABLE'
            ELSE book_status
        END,
        updated_date = SYSDATE
    WHERE book_id = v_book_id;
    
    COMMIT;
    
    IF v_fine_amount > 0 THEN
        p_result := 'SUCCESS: Book returned. Fine amount: $' || TO_CHAR(v_fine_amount, '999.99') || 
                    ' (Overdue by ' || v_days_overdue || ' days)';
    ELSE
        p_result := 'SUCCESS: Book returned on time. No fine.';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_return_book;
/

-- =====================================================
-- Procedure: Reserve Book
-- Description: Creates a book reservation
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_reserve_book (
    p_member_id IN NUMBER,
    p_book_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
    v_member_status VARCHAR2(20);
    v_existing_reservation NUMBER;
    v_reservation_id NUMBER;
    v_expiry_date DATE;
BEGIN
    -- Check member status
    BEGIN
        SELECT membership_status
        INTO v_member_status
        FROM MEMBERS
        WHERE member_id = p_member_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: Member not found';
            RETURN;
    END;
    
    IF v_member_status != 'ACTIVE' THEN
        p_result := 'ERROR: Only ACTIVE members can reserve books';
        RETURN;
    END IF;
    
    -- Check if member already has a reservation for this book
    SELECT COUNT(*)
    INTO v_existing_reservation
    FROM RESERVATIONS
    WHERE member_id = p_member_id
    AND book_id = p_book_id
    AND reservation_status = 'PENDING';
    
    IF v_existing_reservation > 0 THEN
        p_result := 'ERROR: Member already has a pending reservation for this book';
        RETURN;
    END IF;
    
    -- Create reservation (valid for 7 days)
    v_expiry_date := SYSDATE + 7;
    
    INSERT INTO RESERVATIONS (
        reservation_id, book_id, member_id,
        reservation_date, expiry_date, reservation_status
    ) VALUES (
        seq_reservation_id.NEXTVAL, p_book_id, p_member_id,
        SYSDATE, v_expiry_date, 'PENDING'
    ) RETURNING reservation_id INTO v_reservation_id;
    
    COMMIT;
    p_result := 'SUCCESS: Book reserved. Reservation ID: ' || v_reservation_id || 
                ', Expiry date: ' || TO_CHAR(v_expiry_date, 'DD-MON-YYYY');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_reserve_book;
/

-- =====================================================
-- Procedure: Update Overdue Loans
-- Description: Batch update overdue loans and calculate fines
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_update_overdue_loans (
    p_updated_count OUT NUMBER
) AS
    v_fine_per_day CONSTANT NUMBER := 0.50;
BEGIN
    UPDATE LOANS
    SET loan_status = 'OVERDUE',
        fine_amount = GREATEST(0, TRUNC(SYSDATE - due_date)) * v_fine_per_day,
        updated_date = SYSDATE
    WHERE loan_status = 'ACTIVE'
    AND due_date < SYSDATE
    AND return_date IS NULL;
    
    p_updated_count := SQL%ROWCOUNT;
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_updated_count := -1;
        RAISE;
END sp_update_overdue_loans;
/

-- =====================================================
-- Procedure: Expire Old Reservations
-- Description: Automatically expire reservations past their expiry date
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_expire_old_reservations (
    p_expired_count OUT NUMBER
) AS
BEGIN
    UPDATE RESERVATIONS
    SET reservation_status = 'EXPIRED',
        updated_date = SYSDATE
    WHERE reservation_status = 'PENDING'
    AND expiry_date < SYSDATE;
    
    p_expired_count := SQL%ROWCOUNT;
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_expired_count := -1;
        RAISE;
END sp_expire_old_reservations;
/

-- =====================================================
-- Procedure: Add New Member
-- Description: Registers a new library member with validation
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_add_member (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_address IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zip_code IN VARCHAR2,
    p_result OUT VARCHAR2
) AS
    v_member_id NUMBER;
    v_existing_count NUMBER;
BEGIN
    -- Check if email already exists
    SELECT COUNT(*)
    INTO v_existing_count
    FROM MEMBERS
    WHERE LOWER(email) = LOWER(p_email);
    
    IF v_existing_count > 0 THEN
        p_result := 'ERROR: Email already exists';
        RETURN;
    END IF;
    
    -- Insert new member
    INSERT INTO MEMBERS (
        member_id, first_name, last_name, email, phone,
        address, city, state, zip_code,
        membership_date, membership_status, max_books_allowed
    ) VALUES (
        seq_member_id.NEXTVAL, p_first_name, p_last_name, p_email, p_phone,
        p_address, p_city, p_state, p_zip_code,
        SYSDATE, 'ACTIVE', 5
    ) RETURNING member_id INTO v_member_id;
    
    COMMIT;
    p_result := 'SUCCESS: Member added successfully. Member ID: ' || v_member_id;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_add_member;
/

-- Display confirmation
SELECT 'PL/SQL Procedures created successfully!' AS STATUS FROM DUAL;
