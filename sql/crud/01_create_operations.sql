-- =====================================================
-- Library Management System - CRUD Operations
-- CREATE (INSERT) Operations
-- =====================================================

-- =====================================================
-- Create a new member
-- =====================================================
INSERT INTO MEMBERS (
    member_id, first_name, last_name, email, phone, 
    address, city, state, zip_code, membership_status
)
VALUES (
    seq_member_id.NEXTVAL,
    'Alice',
    'Thompson',
    'alice.thompson@email.com',
    '555-0201',
    '111 Park Ave',
    'Boston',
    'MA',
    '02101',
    'ACTIVE'
);

-- =====================================================
-- Create a new author
-- =====================================================
INSERT INTO AUTHORS (
    author_id, first_name, last_name, 
    biography, nationality
)
VALUES (
    seq_author_id.NEXTVAL,
    'Isaac',
    'Asimov',
    'American writer and professor of biochemistry, known for science fiction works',
    'American'
);

-- =====================================================
-- Create a new category
-- =====================================================
INSERT INTO CATEGORIES (
    category_id, category_name, description
)
VALUES (
    seq_category_id.NEXTVAL,
    'Technology',
    'Books about computers, software, and technology'
);

-- =====================================================
-- Create a new book
-- =====================================================
INSERT INTO BOOKS (
    book_id, isbn, title, author_id, category_id,
    publisher, publication_year, pages,
    copies_total, copies_available, shelf_location
)
VALUES (
    seq_book_id.NEXTVAL,
    '978-0-553-29337-0',
    'Foundation',
    (SELECT author_id FROM AUTHORS WHERE last_name = 'Asimov'),
    (SELECT category_id FROM CATEGORIES WHERE category_name = 'Science Fiction'),
    'Bantam Books',
    1951,
    255,
    2,
    2,
    'F1-01'
);

-- =====================================================
-- Create a new loan
-- =====================================================
INSERT INTO LOANS (
    loan_id, book_id, member_id, 
    loan_date, due_date, loan_status
)
VALUES (
    seq_loan_id.NEXTVAL,
    (SELECT book_id FROM BOOKS WHERE isbn = '978-0-553-29337-0'),
    (SELECT member_id FROM MEMBERS WHERE email = 'alice.thompson@email.com'),
    SYSDATE,
    SYSDATE + 14,
    'ACTIVE'
);

-- =====================================================
-- Create a new reservation
-- =====================================================
INSERT INTO RESERVATIONS (
    reservation_id, book_id, member_id,
    reservation_date, expiry_date, reservation_status
)
VALUES (
    seq_reservation_id.NEXTVAL,
    (SELECT book_id FROM BOOKS WHERE title = '1984'),
    (SELECT member_id FROM MEMBERS WHERE email = 'alice.thompson@email.com'),
    SYSDATE,
    SYSDATE + 7,
    'PENDING'
);

COMMIT;

-- Display confirmation
SELECT 'CREATE operations completed successfully!' AS STATUS FROM DUAL;
