# Library Management System - Database Schema Documentation

## Overview

The Library Management System is designed to manage library operations including member registration, book cataloging, borrowing/returning processes, and reservations. This document provides comprehensive information about the database structure, relationships, and design decisions.

## Entity Relationship Diagram (ERD)

### Entities and Relationships

```
┌─────────────┐         ┌──────────────┐         ┌──────────────┐
│   MEMBERS   │         │    LOANS     │         │    BOOKS     │
│─────────────│         │──────────────│         │──────────────│
│ *member_id  │╲       ╱│ *loan_id     │╲       ╱│ *book_id     │
│  first_name │ ╲     ╱ │  book_id [FK]│ ╲     ╱ │  isbn        │
│  last_name  │  ╲   ╱  │  member_id[FK│  ╲   ╱  │  title       │
│  email      │   ╲ ╱   │  loan_date   │   ╲ ╱   │  author_id[FK│
│  phone      │    X    │  due_date    │    X    │  category_id │
│  address    │   ╱ ╲   │  return_date │   ╱ ╲   │  publisher   │
│  ...        │  ╱   ╲  │  loan_status │  ╱   ╲  │  ...         │
└─────────────┘ ╱     ╲ │  fine_amount │ ╱     ╲ └──────────────┘
                        └──────────────┘           │          │
┌─────────────┐                                    │          │
│RESERVATIONS │                                    │          │
│─────────────│                                    │          │
│*reservat_id │                                    │          │
│ book_id [FK]│                                    │          │
│ member_id[FK│                                    │          │
│ reservat_dt │                                    │          │
│ expiry_date │                                    │          │
│ ...         │                                    │          │
└─────────────┘                                    │          │
                                                   │          │
                                         ┌─────────┴──┐  ┌────┴──────┐
                                         │  AUTHORS   │  │CATEGORIES │
                                         │────────────│  │───────────│
                                         │ *author_id │  │*category_id
                                         │  first_name│  │ category_nm
                                         │  last_name │  │ description
                                         │  biography │  └───────────┘
                                         │  ...       │
                                         └────────────┘
```

## Table Descriptions

### 1. MEMBERS Table

Stores information about library members.

**Columns:**
- `member_id` (NUMBER, PK): Unique identifier for each member
- `first_name` (VARCHAR2(50)): Member's first name
- `last_name` (VARCHAR2(50)): Member's last name
- `email` (VARCHAR2(100), UNIQUE): Member's email address
- `phone` (VARCHAR2(20)): Contact phone number
- `address` (VARCHAR2(200)): Street address
- `city` (VARCHAR2(50)): City
- `state` (VARCHAR2(50)): State
- `zip_code` (VARCHAR2(10)): ZIP/Postal code
- `membership_date` (DATE): Date of membership registration
- `membership_status` (VARCHAR2(20)): Current status (ACTIVE, INACTIVE, SUSPENDED)
- `max_books_allowed` (NUMBER): Maximum number of books member can borrow
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `member_id`
- Unique: `email`
- Check: `membership_status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')`

**Indexes:**
- `idx_member_email` on `email`
- `idx_member_status` on `membership_status`

---

### 2. AUTHORS Table

Stores information about book authors.

**Columns:**
- `author_id` (NUMBER, PK): Unique identifier for each author
- `first_name` (VARCHAR2(50)): Author's first name
- `last_name` (VARCHAR2(50)): Author's last name
- `biography` (CLOB): Author's biography
- `birth_date` (DATE): Author's date of birth
- `nationality` (VARCHAR2(50)): Author's nationality
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `author_id`

---

### 3. CATEGORIES Table

Stores book categories/genres.

**Columns:**
- `category_id` (NUMBER, PK): Unique identifier for each category
- `category_name` (VARCHAR2(50), UNIQUE): Name of the category
- `description` (VARCHAR2(200)): Category description
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `category_id`
- Unique: `category_name`

---

### 4. BOOKS Table

Stores information about books in the library catalog.

**Columns:**
- `book_id` (NUMBER, PK): Unique identifier for each book
- `isbn` (VARCHAR2(20), UNIQUE): International Standard Book Number
- `title` (VARCHAR2(200)): Book title
- `author_id` (NUMBER, FK): Reference to AUTHORS table
- `category_id` (NUMBER, FK): Reference to CATEGORIES table
- `publisher` (VARCHAR2(100)): Publisher name
- `publication_year` (NUMBER(4)): Year of publication
- `pages` (NUMBER): Number of pages
- `copies_total` (NUMBER): Total copies available in library
- `copies_available` (NUMBER): Currently available copies
- `shelf_location` (VARCHAR2(20)): Physical location in library
- `book_status` (VARCHAR2(20)): Current status
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `book_id`
- Unique: `isbn`
- Foreign Key: `author_id` → AUTHORS(`author_id`)
- Foreign Key: `category_id` → CATEGORIES(`category_id`)
- Check: `book_status IN ('AVAILABLE', 'BORROWED', 'RESERVED', 'MAINTENANCE', 'LOST')`
- Check: `copies_available <= copies_total`
- Check: `publication_year >= 1000 AND publication_year <= 9999`

**Indexes:**
- `idx_book_isbn` on `isbn`
- `idx_book_title` on `title`
- `idx_book_author` on `author_id`
- `idx_book_category` on `category_id`
- `idx_book_status` on `book_status`

---

### 5. LOANS Table

Tracks book borrowing transactions.

**Columns:**
- `loan_id` (NUMBER, PK): Unique identifier for each loan
- `book_id` (NUMBER, FK): Reference to BOOKS table
- `member_id` (NUMBER, FK): Reference to MEMBERS table
- `loan_date` (DATE): Date when book was borrowed
- `due_date` (DATE): Date when book should be returned
- `return_date` (DATE): Actual return date (NULL if not returned)
- `loan_status` (VARCHAR2(20)): Current loan status
- `fine_amount` (NUMBER(10,2)): Fine amount for overdue returns
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `loan_id`
- Foreign Key: `book_id` → BOOKS(`book_id`)
- Foreign Key: `member_id` → MEMBERS(`member_id`)
- Check: `loan_status IN ('ACTIVE', 'RETURNED', 'OVERDUE', 'LOST')`
- Check: `due_date >= loan_date`

**Indexes:**
- `idx_loan_member` on `member_id`
- `idx_loan_book` on `book_id`
- `idx_loan_status` on `loan_status`
- `idx_loan_dates` on `loan_date, due_date`

---

### 6. RESERVATIONS Table

Tracks book reservations by members.

**Columns:**
- `reservation_id` (NUMBER, PK): Unique identifier for each reservation
- `book_id` (NUMBER, FK): Reference to BOOKS table
- `member_id` (NUMBER, FK): Reference to MEMBERS table
- `reservation_date` (DATE): Date when reservation was made
- `expiry_date` (DATE): Date when reservation expires
- `reservation_status` (VARCHAR2(20)): Current reservation status
- `created_date` (DATE): Record creation timestamp
- `updated_date` (DATE): Last update timestamp

**Constraints:**
- Primary Key: `reservation_id`
- Foreign Key: `book_id` → BOOKS(`book_id`)
- Foreign Key: `member_id` → MEMBERS(`member_id`)
- Check: `reservation_status IN ('PENDING', 'FULFILLED', 'CANCELLED', 'EXPIRED')`
- Check: `expiry_date >= reservation_date`

**Indexes:**
- `idx_reservation_member` on `member_id`
- `idx_reservation_book` on `book_id`
- `idx_reservation_status` on `reservation_status`

---

## Relationships

### One-to-Many Relationships

1. **AUTHORS → BOOKS**: One author can write multiple books
   - Parent: AUTHORS (author_id)
   - Child: BOOKS (author_id)

2. **CATEGORIES → BOOKS**: One category can contain multiple books
   - Parent: CATEGORIES (category_id)
   - Child: BOOKS (category_id)

3. **MEMBERS → LOANS**: One member can have multiple loans
   - Parent: MEMBERS (member_id)
   - Child: LOANS (member_id)

4. **BOOKS → LOANS**: One book can be loaned multiple times
   - Parent: BOOKS (book_id)
   - Child: LOANS (book_id)

5. **MEMBERS → RESERVATIONS**: One member can have multiple reservations
   - Parent: MEMBERS (member_id)
   - Child: RESERVATIONS (member_id)

6. **BOOKS → RESERVATIONS**: One book can have multiple reservations
   - Parent: BOOKS (book_id)
   - Child: RESERVATIONS (book_id)

---

## Sequences

The system uses Oracle sequences for auto-generating primary keys:

- `seq_member_id`: Generates member IDs
- `seq_author_id`: Generates author IDs
- `seq_category_id`: Generates category IDs
- `seq_book_id`: Generates book IDs
- `seq_loan_id`: Generates loan IDs
- `seq_reservation_id`: Generates reservation IDs

All sequences start at 1, increment by 1, and have no cache for data integrity.

---

## Business Rules

### Member Rules
1. Email addresses must be unique across all members
2. Only ACTIVE members can borrow books or make reservations
3. SUSPENDED members cannot perform any borrowing operations
4. Members have a maximum book limit (default: 5 books)
5. Members with outstanding fines cannot borrow new books

### Book Rules
1. ISBN must be unique
2. Available copies cannot exceed total copies
3. Books with zero available copies are marked as BORROWED
4. Books can have multiple statuses: AVAILABLE, BORROWED, RESERVED, MAINTENANCE, LOST

### Loan Rules
1. Due date must be after or equal to loan date
2. Default loan period is 14 days
3. Fine is calculated at $0.50 per day for overdue books
4. Books are automatically marked as OVERDUE when due date passes
5. When a book is returned, availability is automatically updated

### Reservation Rules
1. Reservations expire after 7 days by default
2. Members cannot have duplicate reservations for the same book
3. Expired reservations are automatically marked as EXPIRED
4. Only ACTIVE members can make reservations

---

## Data Integrity

### Referential Integrity
- All foreign key relationships enforce ON DELETE RESTRICT to prevent orphaned records
- CASCADE constraints are used on table drops during schema recreation

### Check Constraints
- Validate enumerated values (statuses)
- Ensure logical date ordering
- Validate numeric ranges (publication years, copy counts)

### Triggers
- Auto-generate primary keys using sequences
- Auto-update timestamps (created_date, updated_date)
- Validate business rules (member status, book availability)
- Calculate fines automatically
- Prevent deletion of books with active loans
- Update book availability when loans change

---

## Normalization

The database is designed in **Third Normal Form (3NF)**:

1. **First Normal Form (1NF)**: All tables have atomic values and unique rows
2. **Second Normal Form (2NF)**: No partial dependencies on composite keys
3. **Third Normal Form (3NF)**: No transitive dependencies

This design eliminates data redundancy while maintaining query performance through appropriate indexing.

---

## Design Decisions

### Why Separate AUTHORS Table?
- Authors can write multiple books
- Prevents data duplication
- Allows for author-specific queries and reporting
- Maintains author biographical information independently

### Why Use Sequences Instead of Identity Columns?
- Better compatibility across Oracle versions
- More control over ID generation
- Can be used in triggers and procedures easily
- Allows for pre-generation of IDs if needed

### Why Track Both Total and Available Copies?
- Supports multiple physical copies of the same book
- Tracks inventory accurately
- Enables better circulation management
- Provides historical data even when copies are lost

### Why Separate RESERVATIONS from LOANS?
- Different business logic and workflows
- Reservations don't affect book availability
- Better tracking and reporting
- Clearer audit trail

---

## Performance Considerations

### Indexes
Strategic indexes are created on:
- Foreign key columns for join performance
- Status columns for filtering
- Date columns for range queries
- Email for lookup operations

### Statistics
Regular statistics gathering should be scheduled for:
- Query optimizer efficiency
- Execution plan optimization
- Better query performance

### Partitioning Recommendations
For large-scale implementations, consider partitioning:
- LOANS table by loan_date (range partitioning)
- RESERVATIONS table by reservation_date (range partitioning)

---

## Scalability

The design supports scalability through:
1. Normalized structure reduces data redundancy
2. Indexed foreign keys for efficient joins
3. Status columns for efficient filtering
4. Date-based partitioning potential
5. Archive strategy for old records

---

## Security Considerations

1. **Column-Level Security**: Email addresses should be encrypted or masked
2. **Row-Level Security**: Implement VPD for multi-tenant environments
3. **Audit Trail**: All tables include created_date and updated_date
4. **Fine-Grained Access**: Use Oracle roles and privileges
5. **Data Masking**: Consider masking PII in non-production environments

---

## Future Enhancements

Potential schema extensions:
1. Add STAFF table for library employees
2. Add PUBLISHERS table for publisher details
3. Add BOOK_REVIEWS table for member reviews
4. Add PAYMENTS table for fine payment tracking
5. Add AUDIT_LOG table for comprehensive auditing
6. Add NOTIFICATIONS table for automated alerts
7. Add BOOK_IMAGES table for cover images
