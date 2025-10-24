-- ================================================================
-- Title       : Modise Cultural Facility - Database Table Creation
-- Description : Drops existing tables (if any), then creates normalized 
--               tables for provinces, municipalities, facilities, rooms, 
--               activities, and usage tracking.
-- Author      : Joyce Coem
-- Date        : 24 May 2025
-- ================================================================

-- ===============================
-- Drop existing tables (if they exist)
-- ===============================
DROP TABLE uses CASCADE CONSTRAINTS;
DROP TABLE activities CASCADE CONSTRAINTS;
DROP TABLE rooms CASCADE CONSTRAINTS;
DROP TABLE facilities CASCADE CONSTRAINTS;
DROP TABLE municipalities CASCADE CONSTRAINTS;
DROP TABLE provinces CASCADE CONSTRAINTS;

-- ===============================
-- Table: provinces
-- Stores province codes and names
-- ===============================
CREATE TABLE provinces (
    provinceCode INT PRIMARY KEY,
    provinceName VARCHAR2(20)
);

-- ===============================
-- Table: municipalities
-- Stores municipalities and links to provinces
-- ===============================
CREATE TABLE municipalities (
    munCode INT PRIMARY KEY,
    munName VARCHAR2(20),
    avgPopulation NUMBER(10,2),
    provinceCode INT,
    CONSTRAINT fk_provinceNum FOREIGN KEY (provinceCode)
        REFERENCES provinces (provinceCode)
);

-- ===============================
-- Table: facilities
-- Stores facility details and links to municipalities
-- ===============================
CREATE TABLE facilities (
    facilityID INT PRIMARY KEY,
    facilityName VARCHAR2(20),
    facilityCapacity INT,
    facilityAddress VARCHAR2(30),
    munCode INT,
    CONSTRAINT fk_munFacility FOREIGN KEY (munCode)
        REFERENCES municipalities (munCode)
);

-- ===============================
-- Table: rooms
-- Stores room details and links to facilities
-- ===============================
CREATE TABLE rooms (
    roomNo INT PRIMARY KEY,
    roomDescription VARCHAR2(50),
    facilityID INT,
    CONSTRAINT fk_facilityRoom FOREIGN KEY (facilityID)
        REFERENCES facilities (facilityID)
);

-- ===============================
-- Table: activities
-- Stores types of activities
-- ===============================
CREATE TABLE activities (
    actRef INT PRIMARY KEY,
    activityName VARCHAR2(20)
);

-- ===============================
-- Table: uses
-- Tracks which activity is used in which facility on what date
-- Composite primary key: facilityID + actRef
-- ===============================
CREATE TABLE uses (
    facilityID INT,
    actRef INT,
    useDate DATE,
    CONSTRAINT pk_facilityActivity PRIMARY KEY (facilityID, actRef),
    CONSTRAINT fk_facilityUse FOREIGN KEY (facilityID)
        REFERENCES facilities (facilityID),
    CONSTRAINT fk_activityUse FOREIGN KEY (actRef)
        REFERENCES activities (actRef)
);
