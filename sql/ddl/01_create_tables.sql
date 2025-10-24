-- =====================================================
-- Library Management System - DDL Scripts
-- Table Creation Script
-- =====================================================

-- Drop existing tables if they exist
DROP TABLE RESERVATIONS CASCADE CONSTRAINTS;
DROP TABLE LOANS CASCADE CONSTRAINTS;
DROP TABLE BOOKS CASCADE CONSTRAINTS;
DROP TABLE AUTHORS CASCADE CONSTRAINTS;
DROP TABLE CATEGORIES CASCADE CONSTRAINTS;
DROP TABLE MEMBERS CASCADE CONSTRAINTS;

-- Drop sequences if they exist
DROP SEQUENCE seq_member_id;
DROP SEQUENCE seq_author_id;
DROP SEQUENCE seq_category_id;
DROP SEQUENCE seq_book_id;
DROP SEQUENCE seq_loan_id;
DROP SEQUENCE seq_reservation_id;

-- =====================================================
-- Create Sequences for Auto-incrementing Primary Keys
-- =====================================================

CREATE SEQUENCE seq_member_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_author_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_category_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_book_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_loan_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_reservation_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- =====================================================
-- MEMBERS Table
-- Stores information about library members
-- =====================================================

CREATE TABLE MEMBERS (
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(200),
    city VARCHAR2(50),
    state VARCHAR2(50),
    zip_code VARCHAR2(10),
    membership_date DATE DEFAULT SYSDATE NOT NULL,
    membership_status VARCHAR2(20) DEFAULT 'ACTIVE' 
        CHECK (membership_status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),
    max_books_allowed NUMBER DEFAULT 5 NOT NULL,
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE
);

-- =====================================================
-- AUTHORS Table
-- Stores information about book authors
-- =====================================================

CREATE TABLE AUTHORS (
    author_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    biography CLOB,
    birth_date DATE,
    nationality VARCHAR2(50),
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE
);

-- =====================================================
-- CATEGORIES Table
-- Stores book categories/genres
-- =====================================================

CREATE TABLE CATEGORIES (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) UNIQUE NOT NULL,
    description VARCHAR2(200),
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE
);

-- =====================================================
-- BOOKS Table
-- Stores information about books in the library
-- =====================================================

CREATE TABLE BOOKS (
    book_id NUMBER PRIMARY KEY,
    isbn VARCHAR2(20) UNIQUE NOT NULL,
    title VARCHAR2(200) NOT NULL,
    author_id NUMBER NOT NULL,
    category_id NUMBER NOT NULL,
    publisher VARCHAR2(100),
    publication_year NUMBER(4),
    pages NUMBER,
    copies_total NUMBER DEFAULT 1 NOT NULL,
    copies_available NUMBER DEFAULT 1 NOT NULL,
    shelf_location VARCHAR2(20),
    book_status VARCHAR2(20) DEFAULT 'AVAILABLE'
        CHECK (book_status IN ('AVAILABLE', 'BORROWED', 'RESERVED', 'MAINTENANCE', 'LOST')),
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_book_author FOREIGN KEY (author_id) 
        REFERENCES AUTHORS(author_id),
    CONSTRAINT fk_book_category FOREIGN KEY (category_id) 
        REFERENCES CATEGORIES(category_id),
    CONSTRAINT chk_copies CHECK (copies_available <= copies_total),
    CONSTRAINT chk_year CHECK (publication_year >= 1000 AND publication_year <= 9999)
);

-- =====================================================
-- LOANS Table
-- Tracks book borrowing transactions
-- =====================================================

CREATE TABLE LOANS (
    loan_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    loan_date DATE DEFAULT SYSDATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    loan_status VARCHAR2(20) DEFAULT 'ACTIVE'
        CHECK (loan_status IN ('ACTIVE', 'RETURNED', 'OVERDUE', 'LOST')),
    fine_amount NUMBER(10,2) DEFAULT 0,
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_loan_book FOREIGN KEY (book_id) 
        REFERENCES BOOKS(book_id),
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id) 
        REFERENCES MEMBERS(member_id),
    CONSTRAINT chk_due_date CHECK (due_date >= loan_date)
);

-- =====================================================
-- RESERVATIONS Table
-- Tracks book reservations by members
-- =====================================================

CREATE TABLE RESERVATIONS (
    reservation_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    reservation_date DATE DEFAULT SYSDATE NOT NULL,
    expiry_date DATE NOT NULL,
    reservation_status VARCHAR2(20) DEFAULT 'PENDING'
        CHECK (reservation_status IN ('PENDING', 'FULFILLED', 'CANCELLED', 'EXPIRED')),
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_reservation_book FOREIGN KEY (book_id) 
        REFERENCES BOOKS(book_id),
    CONSTRAINT fk_reservation_member FOREIGN KEY (member_id) 
        REFERENCES MEMBERS(member_id),
    CONSTRAINT chk_expiry_date CHECK (expiry_date >= reservation_date)
);

-- =====================================================
-- Create Indexes for better performance
-- =====================================================

CREATE INDEX idx_member_email ON MEMBERS(email);
CREATE INDEX idx_member_status ON MEMBERS(membership_status);
CREATE INDEX idx_book_isbn ON BOOKS(isbn);
CREATE INDEX idx_book_title ON BOOKS(title);
CREATE INDEX idx_book_author ON BOOKS(author_id);
CREATE INDEX idx_book_category ON BOOKS(category_id);
CREATE INDEX idx_book_status ON BOOKS(book_status);
CREATE INDEX idx_loan_member ON LOANS(member_id);
CREATE INDEX idx_loan_book ON LOANS(book_id);
CREATE INDEX idx_loan_status ON LOANS(loan_status);
CREATE INDEX idx_loan_dates ON LOANS(loan_date, due_date);
CREATE INDEX idx_reservation_member ON RESERVATIONS(member_id);
CREATE INDEX idx_reservation_book ON RESERVATIONS(book_id);
CREATE INDEX idx_reservation_status ON RESERVATIONS(reservation_status);

COMMIT;
