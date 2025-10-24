# Entity Relationship Diagram (ERD)

## Library Management System - Visual Database Design

This document provides a visual representation of the database structure and relationships.

---

## Complete ERD - ASCII Art Representation

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                    LIBRARY MANAGEMENT SYSTEM - ERD                            ║
╚═══════════════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────┐
│         MEMBERS                 │
├─────────────────────────────────┤
│ PK  member_id         NUMBER    │
│     first_name        VARCHAR2  │
│     last_name         VARCHAR2  │
│ UK  email            VARCHAR2   │
│     phone            VARCHAR2   │
│     address          VARCHAR2   │
│     city             VARCHAR2   │
│     state            VARCHAR2   │
│     zip_code         VARCHAR2   │
│     membership_date  DATE       │
│     membership_status VARCHAR2  │
│     max_books_allowed NUMBER    │
│     created_date     DATE       │
│     updated_date     DATE       │
└─────────────┬───────────────────┘
              │
              │ 1
              │
              │ Borrows/Returns
              │
              │ N
              ▼
┌─────────────────────────────────┐         ┌─────────────────────────────────┐
│         LOANS                   │         │         BOOKS                   │
├─────────────────────────────────┤         ├─────────────────────────────────┤
│ PK  loan_id          NUMBER     │    N    │ PK  book_id         NUMBER      │
│ FK  book_id          NUMBER     ├─────────┤ UK  isbn           VARCHAR2     │
│ FK  member_id        NUMBER     │    1    │     title          VARCHAR2     │
│     loan_date        DATE       │         │ FK  author_id      NUMBER       │
│     due_date         DATE       │         │ FK  category_id    NUMBER       │
│     return_date      DATE       │         │     publisher      VARCHAR2     │
│     loan_status      VARCHAR2   │         │     publication_year NUMBER    │
│     fine_amount      NUMBER     │         │     pages          NUMBER       │
│     created_date     DATE       │         │     copies_total   NUMBER       │
│     updated_date     DATE       │         │     copies_available NUMBER    │
└─────────────────────────────────┘         │     shelf_location VARCHAR2     │
              ▲                              │     book_status    VARCHAR2     │
              │                              │     created_date   DATE         │
              │ N                            │     updated_date   DATE         │
              │                              └─────┬───────────┬───────────────┘
              │                                    │ N         │ N
              │                                    │           │
              │ References                         │           │
              │                                    │           │
              │ 1                                  │ 1         │ 1
              │                              ┌─────▼─────┐ ┌───▼─────────────┐
┌─────────────┴───────────────────┐         │  AUTHORS  │ │   CATEGORIES    │
│       RESERVATIONS              │         ├───────────┤ ├─────────────────┤
├─────────────────────────────────┤         │PK author_id│ │PK category_id   │
│ PK  reservation_id   NUMBER     │    N    │ first_name│ │UK category_name │
│ FK  book_id          NUMBER     ├─────────│ last_name │ │  description    │
│ FK  member_id        NUMBER     │    1    │ biography │ │  created_date   │
│     reservation_date DATE       │         │ birth_date│ │  updated_date   │
│     expiry_date      DATE       │         │ nationality│ └─────────────────┘
│     reservation_status VARCHAR2 │         │ created_dt│
│     created_date     DATE       │         │ updated_dt│
│     updated_date     DATE       │         └───────────┘
└─────────────────────────────────┘


Legend:
────────
PK  = Primary Key
FK  = Foreign Key
UK  = Unique Key
1   = One (cardinality)
N   = Many (cardinality)
```

---

## Relationship Details

### 1. MEMBERS to LOANS (One-to-Many)

```
MEMBERS (1) ──── borrows ───→ (N) LOANS

- One member can have many loans
- Each loan belongs to exactly one member
- Cascade: When member is deleted, prevent if active loans exist
```

### 2. BOOKS to LOANS (One-to-Many)

```
BOOKS (1) ──── is loaned in ───→ (N) LOANS

- One book can be loaned multiple times (different instances/dates)
- Each loan is for exactly one book
- Cascade: When book is deleted, prevent if active loans exist
```

### 3. AUTHORS to BOOKS (One-to-Many)

```
AUTHORS (1) ──── writes ───→ (N) BOOKS

- One author can write many books
- Each book has exactly one primary author
- Cascade: When author is deleted, prevent if books exist
```

### 4. CATEGORIES to BOOKS (One-to-Many)

```
CATEGORIES (1) ──── categorizes ───→ (N) BOOKS

- One category can contain many books
- Each book belongs to exactly one category
- Cascade: When category is deleted, prevent if books exist
```

### 5. MEMBERS to RESERVATIONS (One-to-Many)

```
MEMBERS (1) ──── reserves ───→ (N) RESERVATIONS

- One member can have many reservations
- Each reservation belongs to exactly one member
- Cascade: When member is deleted, prevent if active reservations exist
```

### 6. BOOKS to RESERVATIONS (One-to-Many)

```
BOOKS (1) ──── reserved by ───→ (N) RESERVATIONS

- One book can have many reservations
- Each reservation is for exactly one book
- Cascade: When book is deleted, prevent if active reservations exist
```

---

## Detailed Table Relationships

### MEMBERS Table Relationships

**Outgoing Relationships:**
- → LOANS (member_id)
- → RESERVATIONS (member_id)

**Business Rules:**
- Members must be ACTIVE to borrow books
- Members cannot be deleted if they have active loans or reservations
- Members with outstanding fines cannot borrow new books

---

### BOOKS Table Relationships

**Incoming Relationships:**
- AUTHORS → (author_id)
- CATEGORIES → (category_id)

**Outgoing Relationships:**
- → LOANS (book_id)
- → RESERVATIONS (book_id)

**Business Rules:**
- Books must have an author and category
- Books cannot be deleted if they have active loans
- Available copies cannot exceed total copies
- Book status changes automatically based on availability

---

### LOANS Table Relationships

**Incoming Relationships:**
- MEMBERS → (member_id)
- BOOKS → (book_id)

**Business Rules:**
- Due date must be after loan date
- Fine calculated automatically for overdue returns
- Book availability decreases when loan created
- Book availability increases when loan returned

---

### RESERVATIONS Table Relationships

**Incoming Relationships:**
- MEMBERS → (member_id)
- BOOKS → (book_id)

**Business Rules:**
- Expiry date must be after reservation date
- Expired reservations automatically marked as EXPIRED
- Members cannot have duplicate reservations for same book

---

### AUTHORS Table Relationships

**Outgoing Relationships:**
- → BOOKS (author_id)

**Business Rules:**
- Authors cannot be deleted if they have books
- Author names should be unique combinations

---

### CATEGORIES Table Relationships

**Outgoing Relationships:**
- → BOOKS (category_id)

**Business Rules:**
- Category names must be unique
- Categories cannot be deleted if they have books

---

## Cardinality Summary

| Relationship | From | To | Type | Description |
|--------------|------|-----|------|-------------|
| Member-Loan | MEMBERS | LOANS | 1:N | One member, many loans |
| Book-Loan | BOOKS | LOANS | 1:N | One book, many loans |
| Author-Book | AUTHORS | BOOKS | 1:N | One author, many books |
| Category-Book | CATEGORIES | BOOKS | 1:N | One category, many books |
| Member-Reservation | MEMBERS | RESERVATIONS | 1:N | One member, many reservations |
| Book-Reservation | BOOKS | RESERVATIONS | 1:N | One book, many reservations |

---

## Database Normalization

### First Normal Form (1NF)
✅ All attributes contain atomic values
✅ No repeating groups
✅ Each row is unique (primary keys defined)

### Second Normal Form (2NF)
✅ In 1NF
✅ No partial dependencies
✅ All non-key attributes depend on entire primary key

### Third Normal Form (3NF)
✅ In 2NF
✅ No transitive dependencies
✅ All non-key attributes depend only on primary key

---

## Referential Integrity

### Foreign Key Constraints

```sql
-- BOOKS table
FK: author_id    → AUTHORS(author_id)
FK: category_id  → CATEGORIES(category_id)

-- LOANS table
FK: book_id      → BOOKS(book_id)
FK: member_id    → MEMBERS(member_id)

-- RESERVATIONS table
FK: book_id      → BOOKS(book_id)
FK: member_id    → MEMBERS(member_id)
```

### Constraint Actions
- **ON DELETE**: RESTRICT (prevent deletion if child records exist)
- **ON UPDATE**: Not specified (updates handled by application logic)

---

## Data Flow Examples

### Borrowing a Book

```
1. MEMBER (Active status check)
   ↓
2. Validate member can borrow
   ↓
3. BOOK (Availability check)
   ↓
4. Create LOAN record
   ↓
5. Update BOOK.copies_available (-1)
   ↓
6. Update BOOK.book_status (if needed)
```

### Returning a Book

```
1. LOAN (Find active loan)
   ↓
2. Calculate fine (if overdue)
   ↓
3. Update LOAN (return_date, fine_amount, status)
   ↓
4. Update BOOK.copies_available (+1)
   ↓
5. Update BOOK.book_status (AVAILABLE)
```

---

## Index Strategy

### Primary Key Indexes (Automatic)
- MEMBERS(member_id)
- AUTHORS(author_id)
- CATEGORIES(category_id)
- BOOKS(book_id)
- LOANS(loan_id)
- RESERVATIONS(reservation_id)

### Foreign Key Indexes
- BOOKS(author_id)
- BOOKS(category_id)
- LOANS(book_id)
- LOANS(member_id)
- RESERVATIONS(book_id)
- RESERVATIONS(member_id)

### Additional Indexes
- MEMBERS(email) - For login/search
- MEMBERS(membership_status) - For filtering
- BOOKS(isbn) - For lookup
- BOOKS(title) - For search
- LOANS(loan_status) - For active loan queries
- LOANS(loan_date, due_date) - For date range queries

---

## Visual Representation for SQL Developer

To view the ERD in Oracle SQL Developer:

1. Connect to the database
2. Right-click on the schema (library_admin)
3. Select **Generate** → **Entity Relationship Diagram**
4. Drag and drop the tables onto the canvas
5. SQL Developer will automatically show relationships

Alternative tools:
- Oracle Data Modeler (free from Oracle)
- ERDPlus (online tool)
- dbdiagram.io (online tool)
- draw.io (with database shapes)

---

## Notes on Design Decisions

### Why separate AUTHORS from BOOKS?
- Eliminates redundancy (author info stored once)
- Allows author-specific queries
- Supports future features (author popularity, multiple books)
- Maintains data integrity

### Why track copies_total and copies_available separately?
- Inventory management
- Historical tracking
- Lost/damaged book handling
- Better availability reporting

### Why separate RESERVATIONS from LOANS?
- Different business processes
- Reservations don't affect availability
- Better tracking and reporting
- Clearer audit trail

### Why use SEQUENCES instead of IDENTITY?
- Better Oracle version compatibility
- More control over ID generation
- Can be used in triggers and procedures
- Allows pre-generation of IDs

---

## ERD Best Practices Demonstrated

✅ Clear entity naming (plural nouns)
✅ Consistent attribute naming
✅ Appropriate data types
✅ Primary keys on all tables
✅ Foreign keys for relationships
✅ Indexes on foreign keys
✅ Check constraints for data validation
✅ Audit columns (created_date, updated_date)
✅ Normalized to 3NF
✅ No redundant data
✅ Business rules enforced at database level
