-- ================================================================
-- Title       : Modise Cultural Facility - Sequence Creation Script
-- Description : Defines auto-incrementing sequences for primary keys
--               in provinces, municipalities, facilities, activities, and rooms.
-- Author      : Joyce Coem
-- Date        : 25 May 2025
-- ================================================================


-- ===============================
-- Step 1: Drop existing sequences (if they exist)
-- ===============================
DROP SEQUENCE seq_province;
DROP SEQUENCE seq_municipality;
DROP SEQUENCE seq_facility;
DROP SEQUENCE seq_activity;
DROP SEQUENCE seq_room;

-- ===================================================
-- Sequence: seq_province
-- Purpose : To auto-generate provinceCode starting from 1
-- ===================================================
CREATE SEQUENCE seq_province
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- ===================================================
-- Sequence: seq_municipality
-- Purpose : To auto-generate munCode starting from 200
-- ===================================================
CREATE SEQUENCE seq_municipality
    START WITH 200
    INCREMENT BY 1
    NOCACHE;

-- ===================================================
-- Sequence: seq_facility
-- Purpose : To auto-generate facilityID starting from 300
-- ===================================================
CREATE SEQUENCE seq_facility
    START WITH 300
    INCREMENT BY 1
    NOCACHE;

-- ===================================================
-- Sequence: seq_activity
-- Purpose : To auto-generate actRef starting from 400
-- ===================================================
CREATE SEQUENCE seq_activity
    START WITH 400
    INCREMENT BY 1
    NOCACHE;

-- ===================================================
-- Sequence: seq_room
-- Purpose : To auto-generate roomNo starting from 500
-- ===================================================
CREATE SEQUENCE seq_room
    START WITH 500
    INCREMENT BY 1
    NOCACHE;
