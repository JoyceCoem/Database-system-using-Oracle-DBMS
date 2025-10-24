-- =====================================================
-- Library Management System - CRUD Operations
-- READ (SELECT) Operations
-- =====================================================

-- =====================================================
-- Read all members
-- =====================================================
SELECT * FROM MEMBERS
ORDER BY member_id;

-- =====================================================
-- Read active members only
-- =====================================================
SELECT member_id, first_name, last_name, email, phone, 
       membership_date, membership_status
FROM MEMBERS
WHERE membership_status = 'ACTIVE'
ORDER BY last_name, first_name;

-- =====================================================
-- Read all books with author and category information
-- =====================================================
SELECT 
    b.book_id,
    b.isbn,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    c.category_name,
    b.publisher,
    b.publication_year,
    b.copies_available,
    b.copies_total,
    b.book_status
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
ORDER BY b.title;

-- =====================================================
-- Read available books only
-- =====================================================
SELECT 
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    c.category_name,
    b.copies_available,
    b.shelf_location
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
WHERE b.copies_available > 0
ORDER BY b.title;

-- =====================================================
-- Read all active loans with member and book details
-- =====================================================
SELECT 
    l.loan_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    b.title AS book_title,
    l.loan_date,
    l.due_date,
    CASE 
        WHEN l.due_date < SYSDATE THEN 'OVERDUE'
        ELSE l.loan_status
    END AS current_status,
    TRUNC(SYSDATE - l.due_date) AS days_overdue,
    l.fine_amount
FROM LOANS l
JOIN MEMBERS m ON l.member_id = m.member_id
JOIN BOOKS b ON l.book_id = b.book_id
WHERE l.loan_status IN ('ACTIVE', 'OVERDUE')
ORDER BY l.due_date;

-- =====================================================
-- Read overdue loans
-- =====================================================
SELECT 
    l.loan_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    m.phone,
    b.title AS book_title,
    l.loan_date,
    l.due_date,
    TRUNC(SYSDATE - l.due_date) AS days_overdue,
    l.fine_amount
FROM LOANS l
JOIN MEMBERS m ON l.member_id = m.member_id
JOIN BOOKS b ON l.book_id = b.book_id
WHERE l.loan_status = 'OVERDUE' OR (l.loan_status = 'ACTIVE' AND l.due_date < SYSDATE)
ORDER BY l.due_date;

-- =====================================================
-- Read pending reservations
-- =====================================================
SELECT 
    r.reservation_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    b.title AS book_title,
    r.reservation_date,
    r.expiry_date,
    r.reservation_status
FROM RESERVATIONS r
JOIN MEMBERS m ON r.member_id = m.member_id
JOIN BOOKS b ON r.book_id = b.book_id
WHERE r.reservation_status = 'PENDING'
ORDER BY r.reservation_date;

-- =====================================================
-- Read member borrowing history
-- =====================================================
SELECT 
    l.loan_id,
    b.title AS book_title,
    a.first_name || ' ' || a.last_name AS author_name,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.loan_status,
    l.fine_amount
FROM LOANS l
JOIN BOOKS b ON l.book_id = b.book_id
JOIN AUTHORS a ON b.author_id = a.author_id
WHERE l.member_id = 1
ORDER BY l.loan_date DESC;

-- =====================================================
-- Read books by specific author
-- =====================================================
SELECT 
    b.title,
    b.isbn,
    b.publication_year,
    c.category_name,
    b.copies_available,
    b.copies_total
FROM BOOKS b
JOIN CATEGORIES c ON b.category_id = c.category_id
WHERE b.author_id = (SELECT author_id FROM AUTHORS WHERE last_name = 'Rowling')
ORDER BY b.publication_year;

-- =====================================================
-- Read books by category
-- =====================================================
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.publication_year,
    b.copies_available
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
WHERE c.category_name = 'Fantasy'
ORDER BY b.title;

-- =====================================================
-- Read member statistics
-- =====================================================
SELECT 
    m.member_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.membership_status,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(CASE WHEN l.loan_status = 'ACTIVE' THEN 1 ELSE 0 END) AS active_loans,
    SUM(CASE WHEN l.loan_status = 'OVERDUE' THEN 1 ELSE 0 END) AS overdue_loans,
    SUM(l.fine_amount) AS total_fines
FROM MEMBERS m
LEFT JOIN LOANS l ON m.member_id = l.member_id
GROUP BY m.member_id, m.first_name, m.last_name, m.membership_status
ORDER BY total_loans DESC;

-- =====================================================
-- Read book popularity (most borrowed books)
-- =====================================================
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    c.category_name,
    COUNT(l.loan_id) AS times_borrowed,
    b.copies_total
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
LEFT JOIN LOANS l ON b.book_id = l.book_id
GROUP BY b.title, a.first_name, a.last_name, c.category_name, b.copies_total
ORDER BY times_borrowed DESC, b.title;

-- Display confirmation
SELECT 'READ operations completed successfully!' AS STATUS FROM DUAL;
