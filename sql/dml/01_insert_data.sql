-- =====================================================
-- Library Management System - DML Scripts
-- Data Insertion Script
-- =====================================================

-- =====================================================
-- Insert Members
-- =====================================================

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', SYSDATE - 365, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Emily', 'Johnson', 'emily.johnson@email.com', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90001', SYSDATE - 180, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Michael', 'Williams', 'michael.williams@email.com', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', SYSDATE - 90, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Sarah', 'Brown', 'sarah.brown@email.com', '555-0104', '321 Elm St', 'Houston', 'TX', '77001', SYSDATE - 45, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'David', 'Davis', 'david.davis@email.com', '555-0105', '654 Maple Dr', 'Phoenix', 'AZ', '85001', SYSDATE - 200, 'SUSPENDED', 3);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Jennifer', 'Wilson', 'jennifer.wilson@email.com', '555-0106', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', SYSDATE - 30, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Robert', 'Martinez', 'robert.martinez@email.com', '555-0107', '147 Birch Way', 'San Antonio', 'TX', '78201', SYSDATE - 120, 'ACTIVE', 5);

INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, city, state, zip_code, membership_date, membership_status, max_books_allowed)
VALUES (seq_member_id.NEXTVAL, 'Lisa', 'Anderson', 'lisa.anderson@email.com', '555-0108', '258 Spruce St', 'San Diego', 'CA', '92101', SYSDATE - 60, 'ACTIVE', 5);

-- =====================================================
-- Insert Authors
-- =====================================================

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'George', 'Orwell', 'English novelist and essayist, journalist and critic', TO_DATE('1903-06-25', 'YYYY-MM-DD'), 'British');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Jane', 'Austen', 'English novelist known for her six major novels', TO_DATE('1775-12-16', 'YYYY-MM-DD'), 'British');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Ernest', 'Hemingway', 'American novelist and short-story writer', TO_DATE('1899-07-21', 'YYYY-MM-DD'), 'American');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Agatha', 'Christie', 'English writer known for detective novels', TO_DATE('1890-09-15', 'YYYY-MM-DD'), 'British');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'J.K.', 'Rowling', 'British author, best known for the Harry Potter series', TO_DATE('1965-07-31', 'YYYY-MM-DD'), 'British');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Stephen', 'King', 'American author of horror, supernatural fiction', TO_DATE('1947-09-21', 'YYYY-MM-DD'), 'American');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Harper', 'Lee', 'American novelist known for To Kill a Mockingbird', TO_DATE('1926-04-28', 'YYYY-MM-DD'), 'American');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'F. Scott', 'Fitzgerald', 'American novelist of the Jazz Age', TO_DATE('1896-09-24', 'YYYY-MM-DD'), 'American');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Mark', 'Twain', 'American writer, humorist and lecturer', TO_DATE('1835-11-30', 'YYYY-MM-DD'), 'American');

INSERT INTO AUTHORS (author_id, first_name, last_name, biography, birth_date, nationality)
VALUES (seq_author_id.NEXTVAL, 'Virginia', 'Woolf', 'English writer, considered one of the foremost modernists', TO_DATE('1882-01-25', 'YYYY-MM-DD'), 'British');

-- =====================================================
-- Insert Categories
-- =====================================================

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Fiction', 'Imaginative literature including novels and short stories');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Mystery', 'Detective stories and crime fiction');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Science Fiction', 'Speculative fiction dealing with futuristic concepts');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Horror', 'Literature intended to frighten, scare or disgust');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Romance', 'Love stories and relationships');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Biography', 'Life stories of real people');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'History', 'Historical accounts and narratives');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Self-Help', 'Personal development and improvement books');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Fantasy', 'Magical and supernatural fiction');

INSERT INTO CATEGORIES (category_id, category_name, description)
VALUES (seq_category_id.NEXTVAL, 'Classic', 'Timeless literature of recognized quality');

-- =====================================================
-- Insert Books
-- =====================================================

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-452-28423-4', '1984', 1, 1, 'Penguin Books', 1949, 328, 3, 2, 'A1-01', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-141-43951-8', 'Pride and Prejudice', 2, 5, 'Penguin Classics', 1813, 432, 2, 2, 'A2-03', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-684-80122-3', 'The Old Man and the Sea', 3, 1, 'Scribner', 1952, 127, 2, 1, 'B1-05', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-062-07348-8', 'Murder on the Orient Express', 4, 2, 'William Morrow', 1934, 256, 3, 3, 'C1-02', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-439-70818-8', 'Harry Potter and the Sorcerers Stone', 5, 9, 'Scholastic', 1997, 309, 5, 4, 'D1-01', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-385-12167-5', 'The Shining', 6, 4, 'Doubleday', 1977, 447, 2, 2, 'E1-04', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-061-12008-4', 'To Kill a Mockingbird', 7, 10, 'Harper Perennial', 1960, 324, 4, 3, 'A3-02', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-743-27356-5', 'The Great Gatsby', 8, 10, 'Scribner', 1925, 180, 3, 3, 'A3-05', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-486-28061-9', 'Adventures of Huckleberry Finn', 9, 10, 'Dover Publications', 1884, 366, 2, 2, 'A4-01', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-156-90735-8', 'Mrs. Dalloway', 10, 1, 'Harcourt', 1925, 194, 2, 2, 'B2-03', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-451-52493-5', 'Animal Farm', 1, 3, 'Signet Classics', 1945, 141, 3, 3, 'A1-02', 'AVAILABLE');

INSERT INTO BOOKS (book_id, isbn, title, author_id, category_id, publisher, publication_year, pages, copies_total, copies_available, shelf_location, book_status)
VALUES (seq_book_id.NEXTVAL, '978-0-439-13959-5', 'Harry Potter and the Chamber of Secrets', 5, 9, 'Scholastic', 1998, 341, 4, 4, 'D1-02', 'AVAILABLE');

-- =====================================================
-- Insert Loans
-- =====================================================

INSERT INTO LOANS (loan_id, book_id, member_id, loan_date, due_date, return_date, loan_status, fine_amount)
VALUES (seq_loan_id.NEXTVAL, 1, 1, SYSDATE - 20, SYSDATE - 6, SYSDATE - 4, 'RETURNED', 0);

INSERT INTO LOANS (loan_id, book_id, member_id, loan_date, due_date, return_date, loan_status, fine_amount)
VALUES (seq_loan_id.NEXTVAL, 3, 2, SYSDATE - 10, SYSDATE + 4, NULL, 'ACTIVE', 0);

INSERT INTO LOANS (loan_id, book_id, member_id, loan_date, due_date, return_date, loan_status, fine_amount)
VALUES (seq_loan_id.NEXTVAL, 5, 3, SYSDATE - 8, SYSDATE + 6, NULL, 'ACTIVE', 0);

INSERT INTO LOANS (loan_id, book_id, member_id, loan_date, due_date, return_date, loan_status, fine_amount)
VALUES (seq_loan_id.NEXTVAL, 7, 4, SYSDATE - 25, SYSDATE - 11, NULL, 'OVERDUE', 5.50);

INSERT INTO LOANS (loan_id, book_id, member_id, loan_date, due_date, return_date, loan_status, fine_amount)
VALUES (seq_loan_id.NEXTVAL, 2, 6, SYSDATE - 15, SYSDATE - 1, SYSDATE - 1, 'RETURNED', 0);

-- =====================================================
-- Insert Reservations
-- =====================================================

INSERT INTO RESERVATIONS (reservation_id, book_id, member_id, reservation_date, expiry_date, reservation_status)
VALUES (seq_reservation_id.NEXTVAL, 1, 8, SYSDATE - 2, SYSDATE + 5, 'PENDING');

INSERT INTO RESERVATIONS (reservation_id, book_id, member_id, reservation_date, expiry_date, reservation_status)
VALUES (seq_reservation_id.NEXTVAL, 5, 7, SYSDATE - 5, SYSDATE + 2, 'PENDING');

INSERT INTO RESERVATIONS (reservation_id, book_id, member_id, reservation_date, expiry_date, reservation_status)
VALUES (seq_reservation_id.NEXTVAL, 4, 1, SYSDATE - 10, SYSDATE - 3, 'EXPIRED');

COMMIT;

-- Display confirmation message
SELECT 'Data insertion completed successfully!' AS STATUS FROM DUAL;
