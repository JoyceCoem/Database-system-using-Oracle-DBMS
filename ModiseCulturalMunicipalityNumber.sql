-- ============================================
-- Title : Query to Count Municipalities Without Music Facilities
-- Author: Joyce Coem
-- Date  : 25 MAy 2025
-- ============================================

SELECT 
    COUNT(m.munCode) AS NumberOfMunicipalitiesWithoutMusicFacilities   
FROM 
    municipalities m
    -- Join facilities to municipalities
    LEFT JOIN facilities f ON m.munCode = f.munCode
    -- Join uses to check which facilities are used
    LEFT JOIN uses u ON f.facilityID = u.facilityID
    -- Join activities to find "Music" related events
    LEFT JOIN activities a ON u.actRef = a.actRef
        AND a.activityName LIKE '%Music%' -- Only consider activities with 'Music' in the name
WHERE 
    a.actRef IS NULL; -- Filter for municipalities with no matching 'Music' activity
