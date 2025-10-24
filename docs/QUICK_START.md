# Quick Start Guide

## Library Management System - Oracle Database

### 🎯 What's Included

This is a **complete, production-ready Oracle Database system** for managing library operations.

---

## ⚡ Quick Setup (3 Steps)

### Step 1: Prerequisites
- Oracle Database installed (XE or higher)
- Oracle SQL Developer installed

### Step 2: Connect to Database
```sql
-- Connect as SYSTEM or privileged user
-- Create library user:
CREATE USER library_admin IDENTIFIED BY YourPassword123;
GRANT CONNECT, RESOURCE TO library_admin;
GRANT CREATE VIEW, CREATE SYNONYM, CREATE PROCEDURE TO library_admin;
GRANT CREATE TRIGGER, CREATE SEQUENCE TO library_admin;
GRANT UNLIMITED TABLESPACE TO library_admin;
```

### Step 3: Run Setup Script
```sql
-- Connect as library_admin
-- Execute master setup:
@setup/master_setup.sql
```

**That's it!** Your database is ready to use.

---

## 📁 What's Inside

```
├── sql/
│   ├── ddl/          → Table creation (6 tables)
│   ├── dml/          → Sample data (48+ records)
│   └── crud/         → CRUD examples
├── plsql/
│   ├── procedures/   → 6 stored procedures
│   ├── functions/    → 11 functions
│   ├── triggers/     → 18 triggers
│   └── usage_examples.sql
├── docs/
│   ├── DATABASE_SCHEMA.md    → Complete schema docs
│   ├── ERD.md                → ERD visualization
│   ├── SETUP_INSTRUCTIONS.md → Detailed setup guide
│   └── PROJECT_CHECKLIST.md  → Full checklist
└── setup/
    ├── master_setup.sql      → Automated setup
    └── cleanup.sql           → Database reset
```

---

## 🎮 Try It Out

### Example 1: Borrow a Book

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

### Example 2: View Available Books

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

### Example 3: Check Member Status

```sql
SELECT 
    first_name || ' ' || last_name AS name,
    fn_get_active_loans_count(member_id) AS active_loans,
    fn_get_member_fines(member_id) AS total_fines,
    fn_can_member_borrow(member_id) AS can_borrow
FROM MEMBERS
WHERE member_id = 1;
```

---

## 🎯 Key Features

✅ **6 Normalized Tables** (3NF)
✅ **6 Business Logic Procedures**
✅ **11 Utility Functions**
✅ **18 Automated Triggers**
✅ **Complete CRUD Operations**
✅ **Comprehensive Documentation**
✅ **Sample Data Included**
✅ **Production-Ready Code**

---

## 📚 Database Schema

### Main Tables
- **MEMBERS** - Library member information
- **AUTHORS** - Book author details
- **CATEGORIES** - Book categories/genres
- **BOOKS** - Book catalog with inventory
- **LOANS** - Borrowing transactions
- **RESERVATIONS** - Book reservations

### Relationships
```
MEMBERS ──1:N──→ LOANS ←──N:1── BOOKS
   │                               ├──→ AUTHORS
   │                               └──→ CATEGORIES
   └───────1:N──→ RESERVATIONS ←──N:1──┘
```

---

## 🔧 Available Procedures

| Procedure | Description |
|-----------|-------------|
| `sp_add_member` | Register new member |
| `sp_borrow_book` | Process borrowing |
| `sp_return_book` | Handle return + fine |
| `sp_reserve_book` | Create reservation |
| `sp_update_overdue_loans` | Batch update |
| `sp_expire_old_reservations` | Expire old |

---

## 🔍 Available Functions

| Function | Returns |
|----------|---------|
| `fn_calculate_fine` | Fine amount |
| `fn_is_book_available` | Boolean |
| `fn_get_active_loans_count` | Number |
| `fn_get_member_fines` | Amount |
| `fn_can_member_borrow` | Status text |
| `fn_days_until_due` | Number |
| ...and 5 more functions |

---

## 📖 Documentation

- **[README.md](../README.md)** - Project overview and features
- **[SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)** - Detailed setup guide
- **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Complete schema docs
- **[ERD.md](ERD.md)** - Entity relationship diagram
- **[PROJECT_CHECKLIST.md](PROJECT_CHECKLIST.md)** - Full checklist

---

## 🚀 Usage Examples

All examples are in `plsql/usage_examples.sql`:
- Add new member
- Borrow books
- Return books
- Reserve books
- Generate reports
- Member dashboard
- Book statistics
- And more...

---

## 🛠️ Testing

### Verify Installation

```sql
-- Check all tables exist
SELECT table_name FROM user_tables ORDER BY table_name;

-- Check procedures
SELECT object_name FROM user_objects 
WHERE object_type = 'PROCEDURE';

-- Check functions
SELECT object_name FROM user_objects 
WHERE object_type = 'FUNCTION';

-- Check triggers
SELECT trigger_name FROM user_triggers;

-- Verify data
SELECT 'Members' AS table_name, COUNT(*) AS records FROM MEMBERS
UNION ALL SELECT 'Books', COUNT(*) FROM BOOKS
UNION ALL SELECT 'Authors', COUNT(*) FROM AUTHORS;
```

---

## 💡 Tips

1. **Enable Output**: Always run `SET SERVEROUTPUT ON;` for procedures
2. **Review Examples**: Check `plsql/usage_examples.sql` first
3. **Read Docs**: Full documentation in `docs/` folder
4. **Customize**: Easily extend for your needs

---

## 🔄 Maintenance

### Daily Backup
```sql
-- Export schema
expdp library_admin/password DIRECTORY=backup_dir 
  DUMPFILE=library_backup.dmp
```

### Update Statistics
```sql
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS('LIBRARY_ADMIN');
END;
/
```

### Check Invalid Objects
```sql
SELECT object_name, object_type 
FROM user_objects 
WHERE status = 'INVALID';
```

---

## ❓ Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection error | Check Oracle service is running |
| Insufficient privileges | Re-run grants as SYSTEM user |
| Invalid objects | Run `@setup/master_setup.sql` again |
| Table not found | Ensure connected as library_admin |

---

## 🎓 Learning Resources

- Oracle Database Docs: https://docs.oracle.com/database/
- SQL Developer Guide: https://docs.oracle.com/en/database/oracle/sql-developer/
- Oracle Live SQL: https://livesql.oracle.com/

---

## 📧 Need Help?

1. Check `docs/SETUP_INSTRUCTIONS.md` for detailed steps
2. Review `docs/DATABASE_SCHEMA.md` for schema details
3. See `plsql/usage_examples.sql` for working examples
4. Open an issue on GitHub

---

## ✨ What Makes This Special?

- ✅ **Complete System** - Everything you need included
- ✅ **Best Practices** - Follows Oracle standards
- ✅ **Well Documented** - Comprehensive docs
- ✅ **Production Ready** - Error handling included
- ✅ **Easy to Use** - Simple setup process
- ✅ **Educational** - Great for learning
- ✅ **Extensible** - Easy to customize

---

## 🎉 Get Started Now!

```bash
# 1. Clone the repository
git clone https://github.com/JoyceCoem/Database-system-using-Oracle-DBMS.git

# 2. Connect to Oracle Database
# 3. Run: @setup/master_setup.sql
# 4. Start using the system!
```

---

**Ready to build amazing library management systems? Let's go! 🚀**
