-- =====================================================
-- Library Management System - Database Triggers
-- Automation and Validation
-- =====================================================

-- =====================================================
-- Trigger: Auto-generate Member ID
-- Description: Automatically assigns member_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_member_id
BEFORE INSERT ON MEMBERS
FOR EACH ROW
BEGIN
    IF :NEW.member_id IS NULL THEN
        :NEW.member_id := seq_member_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Update Member Updated Date
-- Description: Automatically updates updated_date on member changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_member_update
BEFORE UPDATE ON MEMBERS
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Auto-generate Author ID
-- Description: Automatically assigns author_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_author_id
BEFORE INSERT ON AUTHORS
FOR EACH ROW
BEGIN
    IF :NEW.author_id IS NULL THEN
        :NEW.author_id := seq_author_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Update Author Updated Date
-- Description: Automatically updates updated_date on author changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_author_update
BEFORE UPDATE ON AUTHORS
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Auto-generate Category ID
-- Description: Automatically assigns category_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_category_id
BEFORE INSERT ON CATEGORIES
FOR EACH ROW
BEGIN
    IF :NEW.category_id IS NULL THEN
        :NEW.category_id := seq_category_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Update Category Updated Date
-- Description: Automatically updates updated_date on category changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_category_update
BEFORE UPDATE ON CATEGORIES
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Auto-generate Book ID
-- Description: Automatically assigns book_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_book_id
BEFORE INSERT ON BOOKS
FOR EACH ROW
BEGIN
    IF :NEW.book_id IS NULL THEN
        :NEW.book_id := seq_book_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
    
    -- Set initial copies_available equal to copies_total if not specified
    IF :NEW.copies_available IS NULL THEN
        :NEW.copies_available := :NEW.copies_total;
    END IF;
END;
/

-- =====================================================
-- Trigger: Update Book Updated Date
-- Description: Automatically updates updated_date on book changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_book_update
BEFORE UPDATE ON BOOKS
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Validate Book Copies
-- Description: Ensures copies_available doesn't exceed copies_total
-- =====================================================

CREATE OR REPLACE TRIGGER trg_validate_book_copies
BEFORE INSERT OR UPDATE ON BOOKS
FOR EACH ROW
BEGIN
    IF :NEW.copies_available > :NEW.copies_total THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Copies available (' || :NEW.copies_available || 
            ') cannot exceed total copies (' || :NEW.copies_total || ')');
    END IF;
    
    IF :NEW.copies_available < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Copies available cannot be negative');
    END IF;
END;
/

-- =====================================================
-- Trigger: Auto-generate Loan ID
-- Description: Automatically assigns loan_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_loan_id
BEFORE INSERT ON LOANS
FOR EACH ROW
BEGIN
    IF :NEW.loan_id IS NULL THEN
        :NEW.loan_id := seq_loan_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
    
    -- Set default due date if not provided (14 days)
    IF :NEW.due_date IS NULL THEN
        :NEW.due_date := :NEW.loan_date + 14;
    END IF;
END;
/

-- =====================================================
-- Trigger: Update Loan Updated Date
-- Description: Automatically updates updated_date on loan changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_loan_update
BEFORE UPDATE ON LOANS
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Update Book Availability After Loan Insert
-- Description: Decreases available copies when book is borrowed
-- =====================================================

CREATE OR REPLACE TRIGGER trg_after_loan_insert
AFTER INSERT ON LOANS
FOR EACH ROW
WHEN (NEW.loan_status = 'ACTIVE')
DECLARE
    v_copies_available NUMBER;
BEGIN
    -- Get current available copies
    SELECT copies_available
    INTO v_copies_available
    FROM BOOKS
    WHERE book_id = :NEW.book_id
    FOR UPDATE;
    
    -- Update book availability
    IF v_copies_available > 0 THEN
        UPDATE BOOKS
        SET copies_available = copies_available - 1,
            book_status = CASE 
                WHEN copies_available - 1 = 0 THEN 'BORROWED'
                ELSE book_status
            END
        WHERE book_id = :NEW.book_id;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 
            'Book is not available for borrowing');
    END IF;
END;
/

-- =====================================================
-- Trigger: Update Book Availability After Loan Return
-- Description: Increases available copies when book is returned
-- =====================================================

CREATE OR REPLACE TRIGGER trg_after_loan_return
AFTER UPDATE OF loan_status, return_date ON LOANS
FOR EACH ROW
WHEN (OLD.loan_status IN ('ACTIVE', 'OVERDUE') AND NEW.loan_status = 'RETURNED')
BEGIN
    UPDATE BOOKS
    SET copies_available = copies_available + 1,
        book_status = CASE 
            WHEN copies_available + 1 > 0 THEN 'AVAILABLE'
            ELSE book_status
        END
    WHERE book_id = :NEW.book_id;
END;
/

-- =====================================================
-- Trigger: Calculate Fine on Return
-- Description: Automatically calculates fine when book is returned late
-- =====================================================

CREATE OR REPLACE TRIGGER trg_calculate_fine_on_return
BEFORE UPDATE OF return_date ON LOANS
FOR EACH ROW
WHEN (NEW.return_date IS NOT NULL AND OLD.return_date IS NULL)
DECLARE
    v_days_overdue NUMBER;
    v_fine_per_day CONSTANT NUMBER := 0.50;
BEGIN
    -- Calculate days overdue
    v_days_overdue := TRUNC(:NEW.return_date - :NEW.due_date);
    
    -- If overdue, calculate and set fine
    IF v_days_overdue > 0 THEN
        :NEW.fine_amount := v_days_overdue * v_fine_per_day;
        :NEW.loan_status := 'RETURNED';
    ELSE
        :NEW.fine_amount := 0;
        :NEW.loan_status := 'RETURNED';
    END IF;
END;
/

-- =====================================================
-- Trigger: Auto-generate Reservation ID
-- Description: Automatically assigns reservation_id using sequence
-- =====================================================

CREATE OR REPLACE TRIGGER trg_reservation_id
BEFORE INSERT ON RESERVATIONS
FOR EACH ROW
BEGIN
    IF :NEW.reservation_id IS NULL THEN
        :NEW.reservation_id := seq_reservation_id.NEXTVAL;
    END IF;
    :NEW.created_date := SYSDATE;
    :NEW.updated_date := SYSDATE;
    
    -- Set default expiry date if not provided (7 days)
    IF :NEW.expiry_date IS NULL THEN
        :NEW.expiry_date := :NEW.reservation_date + 7;
    END IF;
END;
/

-- =====================================================
-- Trigger: Update Reservation Updated Date
-- Description: Automatically updates updated_date on reservation changes
-- =====================================================

CREATE OR REPLACE TRIGGER trg_reservation_update
BEFORE UPDATE ON RESERVATIONS
FOR EACH ROW
BEGIN
    :NEW.updated_date := SYSDATE;
END;
/

-- =====================================================
-- Trigger: Validate Member Active Status for New Loans
-- Description: Ensures only ACTIVE members can borrow books
-- =====================================================

CREATE OR REPLACE TRIGGER trg_validate_loan_member
BEFORE INSERT ON LOANS
FOR EACH ROW
DECLARE
    v_member_status VARCHAR2(20);
    v_max_books NUMBER;
    v_active_loans NUMBER;
BEGIN
    -- Check member status
    SELECT membership_status, max_books_allowed
    INTO v_member_status, v_max_books
    FROM MEMBERS
    WHERE member_id = :NEW.member_id;
    
    IF v_member_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20004, 
            'Only ACTIVE members can borrow books. Current status: ' || v_member_status);
    END IF;
    
    -- Check if member has reached max books limit
    SELECT COUNT(*)
    INTO v_active_loans
    FROM LOANS
    WHERE member_id = :NEW.member_id
    AND loan_status = 'ACTIVE';
    
    IF v_active_loans >= v_max_books THEN
        RAISE_APPLICATION_ERROR(-20005, 
            'Member has reached maximum allowed books limit (' || v_max_books || ')');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 
            'Member not found');
END;
/

-- =====================================================
-- Trigger: Prevent Deletion of Books with Active Loans
-- Description: Prevents deletion of books that are currently loaned out
-- =====================================================

CREATE OR REPLACE TRIGGER trg_prevent_book_deletion
BEFORE DELETE ON BOOKS
FOR EACH ROW
DECLARE
    v_active_loans NUMBER;
BEGIN
    -- Check for active loans
    SELECT COUNT(*)
    INTO v_active_loans
    FROM LOANS
    WHERE book_id = :OLD.book_id
    AND loan_status IN ('ACTIVE', 'OVERDUE');
    
    IF v_active_loans > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 
            'Cannot delete book with active loans. Please return all copies first.');
    END IF;
END;
/

-- =====================================================
-- Trigger: Log Member Status Changes
-- Description: Audits changes to member status (optional audit table)
-- =====================================================

CREATE OR REPLACE TRIGGER trg_audit_member_status
AFTER UPDATE OF membership_status ON MEMBERS
FOR EACH ROW
WHEN (OLD.membership_status != NEW.membership_status)
BEGIN
    -- Log the status change
    -- Note: This assumes an audit log table exists
    -- For demonstration, we're using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE(
        'Member ' || :NEW.member_id || 
        ' status changed from ' || :OLD.membership_status || 
        ' to ' || :NEW.membership_status || 
        ' at ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
    );
END;
/

-- =====================================================
-- Trigger: Email Format Validation
-- Description: Validates email format before insert/update
-- =====================================================

CREATE OR REPLACE TRIGGER trg_validate_email
BEFORE INSERT OR UPDATE OF email ON MEMBERS
FOR EACH ROW
DECLARE
    v_at_count NUMBER;
    v_dot_count NUMBER;
BEGIN
    -- Basic email validation
    v_at_count := LENGTH(:NEW.email) - LENGTH(REPLACE(:NEW.email, '@', ''));
    v_dot_count := LENGTH(:NEW.email) - LENGTH(REPLACE(:NEW.email, '.', ''));
    
    IF v_at_count != 1 OR v_dot_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 
            'Invalid email format: ' || :NEW.email);
    END IF;
    
    -- Convert email to lowercase for consistency
    :NEW.email := LOWER(:NEW.email);
END;
/

-- Display confirmation
SELECT 'Database Triggers created successfully!' AS STATUS FROM DUAL;
