# Library Management System - Oracle Database

A comprehensive database system built using Oracle DBMS for managing library operations including member management, book cataloging, lending operations, and reservations.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Getting Started](#getting-started)
- [Technologies Used](#technologies-used)
- [Best Practices](#best-practices)
- [Usage Examples](#usage-examples)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This Library Management System is a complete database solution designed to handle all aspects of library operations. Built with Oracle Database Management System, it demonstrates professional database design principles, normalization, referential integrity, and business logic implementation through PL/SQL.

The system provides:
- **Complete CRUD operations** for all entities
- **Business logic automation** through stored procedures
- **Data validation** using triggers
- **Calculation functions** for fines and statistics
- **Comprehensive documentation** and setup guides

---

## ✨ Features

### Core Functionality

- **Member Management**
  - Member registration and profile management
  - Membership status tracking (Active, Inactive, Suspended)
  - Member borrowing history and statistics
  - Fine tracking and payment management

- **Book Catalog Management**
  - Book inventory with ISBN tracking
  - Author and category management
  - Copy tracking (total vs. available)
  - Shelf location management

- **Lending Operations**
  - Book borrowing and return processing
  - Automatic due date calculation
  - Overdue detection and fine calculation
  - Loan status tracking

- **Reservation System**
  - Book reservation for members
  - Automatic expiration handling
  - Queue management

### Technical Features

- **Automated Business Logic**
  - Auto-generated primary keys using sequences
  - Automatic timestamp management
  - Fine calculation based on overdue days
  - Book availability updates

- **Data Validation**
  - Email format validation
  - Status enum validation
  - Business rule enforcement
  - Referential integrity

- **Security**
  - Role-based access control ready
  - Audit trail support
  - Data integrity constraints

---

## 📁 Project Structure

```
Database-system-using-Oracle-DBMS/
│
├── sql/
│   ├── ddl/
│   │   └── 01_create_tables.sql          # Table definitions and indexes
│   ├── dml/
│   │   └── 01_insert_data.sql            # Sample data insertion
│   └── crud/
│       ├── 01_create_operations.sql      # INSERT examples
│       ├── 02_read_operations.sql        # SELECT queries
│       ├── 03_update_operations.sql      # UPDATE examples
│       └── 04_delete_operations.sql      # DELETE examples
│
├── plsql/
│   ├── procedures/
│   │   └── 01_library_procedures.sql     # Stored procedures
│   ├── functions/
│   │   └── 01_library_functions.sql      # Functions
│   ├── triggers/
│   │   └── 01_library_triggers.sql       # Database triggers
│   └── usage_examples.sql                # Usage demonstrations
│
├── docs/
│   ├── DATABASE_SCHEMA.md                # Complete schema documentation
│   └── SETUP_INSTRUCTIONS.md             # Installation and setup guide
│
├── setup/
│   └── (additional setup scripts if needed)
│
└── README.md                             # This file
```

---

## 🗄️ Database Schema

The system consists of 6 main tables:

### Core Tables

1. **MEMBERS** - Library member information
2. **AUTHORS** - Book author details
3. **CATEGORIES** - Book categories/genres
4. **BOOKS** - Book catalog with inventory
5. **LOANS** - Borrowing transactions
6. **RESERVATIONS** - Book reservations

### Entity Relationships

```
MEMBERS (1) ─────< (N) LOANS (N) >───── (1) BOOKS
   │                                         │
   │                                         ├─── (N) > (1) AUTHORS
   │                                         └─── (N) > (1) CATEGORIES
   │
   └──────────< (N) RESERVATIONS (N) >──────┘
```

For detailed schema information, see [DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)

---

## 🚀 Getting Started

### Prerequisites

- Oracle Database 11g or higher
- Oracle SQL Developer (recommended) or SQL*Plus
- 2GB+ RAM
- 5GB+ disk space

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/JoyceCoem/Database-system-using-Oracle-DBMS.git
   cd Database-system-using-Oracle-DBMS
   ```

2. **Set up Oracle Database**
   - Install Oracle Database XE (free) or use existing installation
   - Create a database user for the library system

3. **Execute SQL scripts in order**
   ```sql
   -- 1. Create tables and sequences
   @sql/ddl/01_create_tables.sql
   
   -- 2. Insert sample data
   @sql/dml/01_insert_data.sql
   
   -- 3. Create procedures
   @plsql/procedures/01_library_procedures.sql
   
   -- 4. Create functions
   @plsql/functions/01_library_functions.sql
   
   -- 5. Create triggers
   @plsql/triggers/01_library_triggers.sql
   ```

4. **Verify installation**
   ```sql
   -- Check all tables
   SELECT table_name FROM user_tables;
   
   -- Check all procedures and functions
   SELECT object_name, object_type FROM user_objects 
   WHERE object_type IN ('PROCEDURE', 'FUNCTION');
   ```

For detailed setup instructions, see [SETUP_INSTRUCTIONS.md](docs/SETUP_INSTRUCTIONS.md)

---

## 🛠️ Technologies Used

- **Oracle Database** - Primary RDBMS
- **PL/SQL** - Procedural programming language
- **Oracle SQL Developer** - Development and administration tool
- **SQL** - Data definition and manipulation

### Key Oracle Features Demonstrated

- ✅ Sequences for auto-incrementing IDs
- ✅ Stored Procedures for business logic
- ✅ Functions for calculations
- ✅ Triggers for automation
- ✅ Constraints for data integrity
- ✅ Indexes for performance
- ✅ Check constraints for validation
- ✅ Foreign keys for referential integrity

---

## 💡 Best Practices Implemented

### Database Design
- ✅ Third Normal Form (3NF) normalization
- ✅ Appropriate data types and sizes
- ✅ Meaningful naming conventions
- ✅ Comprehensive constraints

### Performance
- ✅ Strategic indexing on foreign keys
- ✅ Indexes on frequently queried columns
- ✅ Efficient query design
- ✅ Proper use of sequences

### Security
- ✅ Role-based access control ready
- ✅ Audit timestamps on all tables
- ✅ Input validation in procedures
- ✅ Error handling in PL/SQL

### Maintainability
- ✅ Comprehensive inline comments
- ✅ Consistent coding style
- ✅ Modular procedure design
- ✅ Detailed documentation

---

## 📖 Usage Examples

### Borrow a Book

```sql
SET SERVEROUTPUT ON;

DECLARE
    v_result VARCHAR2(500);
BEGIN
    sp_borrow_book(
        p_member_id => 1,
        p_book_id => 5,
        p_loan_days => 14,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
```

### Return a Book

```sql
DECLARE
    v_result VARCHAR2(500);
BEGIN
    sp_return_book(
        p_loan_id => 2,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
```

### Check Member Status

```sql
SELECT 
    member_id,
    first_name || ' ' || last_name AS name,
    fn_get_active_loans_count(member_id) AS active_loans,
    fn_get_member_fines(member_id) AS total_fines,
    fn_can_member_borrow(member_id) AS can_borrow
FROM MEMBERS
WHERE member_id = 1;
```

### Find Available Books

```sql
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    c.category_name,
    b.copies_available,
    b.shelf_location
FROM BOOKS b
JOIN AUTHORS a ON b.author_id = a.author_id
JOIN CATEGORIES c ON b.category_id = c.category_id
WHERE b.copies_available > 0
ORDER BY b.title;
```

For more examples, see [usage_examples.sql](plsql/usage_examples.sql)

---

## 📚 Documentation

Complete documentation is available in the `docs/` directory:

- **[DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)** - Comprehensive database schema documentation
  - Entity Relationship Diagram (ERD)
  - Table descriptions
  - Relationships
  - Business rules
  - Normalization details

- **[SETUP_INSTRUCTIONS.md](docs/SETUP_INSTRUCTIONS.md)** - Step-by-step setup guide
  - Prerequisites
  - Installation steps
  - Configuration
  - Troubleshooting
  - Best practices

---

## 🔧 Available Procedures

| Procedure Name | Description |
|----------------|-------------|
| `sp_add_member` | Register a new library member |
| `sp_borrow_book` | Process book borrowing with validations |
| `sp_return_book` | Handle book return and fine calculation |
| `sp_reserve_book` | Create a book reservation |
| `sp_update_overdue_loans` | Batch update overdue loans and fines |
| `sp_expire_old_reservations` | Automatically expire old reservations |

---

## 🔍 Available Functions

| Function Name | Description |
|---------------|-------------|
| `fn_calculate_fine` | Calculate fine for overdue books |
| `fn_is_book_available` | Check if book is available |
| `fn_get_active_loans_count` | Get member's active loan count |
| `fn_get_member_fines` | Get total member fines |
| `fn_can_member_borrow` | Check if member can borrow |
| `fn_get_book_loan_count` | Get book's loan history count |
| `fn_days_until_due` | Calculate days until loan is due |
| `fn_format_member_name` | Format member's full name |
| `fn_get_book_with_author` | Get book title with author |
| `fn_validate_email` | Validate email format |
| `fn_membership_duration` | Calculate membership duration |

---

## 🎨 Key Features of the Implementation

### Automated Workflows
- Auto-generation of IDs using sequences
- Automatic timestamp updates on data changes
- Auto-calculation of fines on overdue returns
- Automatic book availability updates

### Data Validation
- Email format validation
- Status enumeration enforcement
- Business rule validation (e.g., active member checks)
- Copy availability validation

### Business Logic
- Member borrowing limit enforcement
- Fine calculation based on overdue days
- Reservation expiration handling
- Book status management

### Reporting Capabilities
- Member statistics and history
- Book popularity reports
- Overdue loans tracking
- Fine collection reports

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Authors

- **Joyce Coem** - Initial work

---

## 🙏 Acknowledgments

- Oracle Database documentation and community
- SQL best practices from Oracle ACE community
- Database design principles from industry standards

---

## 📧 Contact

For questions, issues, or suggestions:
- Open an issue in the GitHub repository
- Review the documentation in the `docs/` folder
- Check the usage examples for implementation guidance

---

## 🔄 Version History

- **1.0.0** (Current)
  - Initial release
  - Complete schema implementation
  - Full CRUD operations
  - Procedures, functions, and triggers
  - Comprehensive documentation

---

## 🎯 Future Enhancements

Potential improvements for future versions:
- [ ] Web-based user interface
- [ ] REST API layer
- [ ] Email notifications for due dates
- [ ] Fine payment processing integration
- [ ] Book recommendation system
- [ ] Advanced search and filtering
- [ ] Digital resource management
- [ ] Mobile application support

---

## 🏆 Why This Project?

This project demonstrates:
- Professional database design and implementation
- Oracle-specific features and best practices
- Real-world business logic implementation
- Comprehensive documentation standards
- Production-ready code quality
- Educational value for learning Oracle Database

Perfect for:
- Database development learning
- Oracle certification preparation
- Portfolio demonstration
- Real library system implementation
- Academic projects
- Technical interview preparation

---

**⭐ If you find this project helpful, please consider giving it a star!**