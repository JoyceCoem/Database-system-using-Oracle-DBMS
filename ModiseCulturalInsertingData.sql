-- ================================================================
-- Title       : Modise Cultural Facility - Sample Data Insertion
-- Description : Inserts sample data into provinces, municipalities,
--               facilities, rooms, activities, and usage tables
--               using previously defined sequences.
-- Author      : Joyce Coem
-- Date        : 25 May 2025
-- ================================================================

-- ===============================
-- Insert data into provinces
-- ===============================
INSERT INTO provinces (provinceCode, provinceName)
VALUES (seq_province.NEXTVAL, 'Gauteng');

INSERT INTO provinces (provinceCode, provinceName)
VALUES (seq_province.NEXTVAL, 'Western Cape');

-- ===============================
-- Insert data into municipalities
-- Note: provinceCode 1 = Gauteng, 2 = Western Cape
-- ===============================
INSERT INTO municipalities (munCode, munName, avgPopulation, provinceCode)
VALUES (seq_municipality.NEXTVAL, 'City of Johannesburg', 5000000, 1);

INSERT INTO municipalities (munCode, munName, avgPopulation, provinceCode)
VALUES (seq_municipality.NEXTVAL, 'City of Cape Town', 400000, 2);

-- ===============================
-- Insert data into facilities
-- Note: munCode 1 = Johannesburg, 2 = Cape Town
-- ===============================
INSERT INTO facilities (facilityID, facilityName, facilityCapacity, facilityAddress, munCode)
VALUES (seq_facility.NEXTVAL, 'Johannesburg Theatre', 1200, '163 Civic Blvd, Braamfontein', 200);

INSERT INTO facilities (facilityID, facilityName, facilityCapacity, facilityAddress, munCode)
VALUES (seq_facility.NEXTVAL, 'Artscape Theatre', 5500, 'St Georges Mall, Cape Town', 201);

-- ===============================
-- Insert data into rooms
-- Note: facilityID 1 = Johannesburg Theatre, 2 = Artscape Theatre
-- ===============================
INSERT INTO rooms (roomNo, roomDescription, facilityID)
VALUES (seq_room.NEXTVAL, 'Main Theatre', 300);

INSERT INTO rooms (roomNo, roomDescription, facilityID)
VALUES (seq_room.NEXTVAL, 'Rehearsal Room', 300);

INSERT INTO rooms (roomNo, roomDescription, facilityID)
VALUES (seq_room.NEXTVAL, 'Main Stage', 301);

INSERT INTO rooms (roomNo, roomDescription, facilityID)
VALUES (seq_room.NEXTVAL, 'Studio Room', 301);

-- ===============================
-- Insert data into activities
-- ===============================
INSERT INTO activities (actRef, activityName)
VALUES (seq_activity.NEXTVAL, 'Music :Jazz Concert');

INSERT INTO activities (actRef, activityName)
VALUES (seq_activity.NEXTVAL, 'Ballet');

-- ===============================
-- Insert data into uses (activity schedule)
-- Note: facilityID 1 = Johannesburg Theatre, 2 = Artscape Theatre
--       actRef 1 = Jazz Concert, 2 = Ballet
-- ===============================
INSERT INTO uses (facilityID, actRef, useDate)
VALUES (300, 400, TO_DATE('2025-07-01', 'YYYY-MM-DD'));

INSERT INTO uses (facilityID, actRef, useDate)
VALUES (301, 401, TO_DATE('2025-08-12', 'YYYY-MM-DD'));
