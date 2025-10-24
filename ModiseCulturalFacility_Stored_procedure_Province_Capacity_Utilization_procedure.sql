-- ============================================
-- Procedure Name: Province_Capacity_Utilization_procedure
-- Description  : Calculates and displays the capacity utilization percentage 
--                of facilities in each province based on total activities.
-- Author       : Joyce Coem
-- Date         : 25 May 2025
-- ============================================

CREATE OR REPLACE PROCEDURE Province_Capacity_Utilization_procedure 
AS
    -- Declare variables to hold values for each province
    v_provinceName VARCHAR2(100);
    v_TotalFacilities NUMBER;
    v_TotalCapacity NUMBER;
    v_TotalActivities NUMBER;
    v_UtilizationPercentage NUMBER;

    -- Cursor to retrieve provinces and aggregated facility data
    CURSOR province_cursor IS
        SELECT 
            p.provinceName,
            COUNT(DISTINCT f.facilityID) AS TotalFacilities,
            SUM(f.facilityCapacity) AS TotalCapacity,
            COUNT(DISTINCT u.actRef) AS TotalActivities
        FROM 
            provinces p
            LEFT JOIN municipalities m ON p.provinceCode = m.provinceCode
            LEFT JOIN facilities f ON m.munCode = f.munCode
            LEFT JOIN uses u ON f.facilityID = u.facilityID
        GROUP BY 
            p.provinceName;

BEGIN
    -- Loop through each province from the cursor
    FOR province_record IN province_cursor LOOP
        v_provinceName := province_record.provinceName;
        v_TotalFacilities := province_record.TotalFacilities;
        v_TotalCapacity := NVL(province_record.TotalCapacity, 0);
        v_TotalActivities := province_record.TotalActivities;

        -- Calculate utilization percentage, avoid division by zero
        IF v_TotalCapacity > 0 THEN
            v_UtilizationPercentage := (v_TotalActivities / v_TotalCapacity) * 100;
        ELSE
            v_UtilizationPercentage := 0;
        END IF;

        -- Output the results formatted nicely
        DBMS_OUTPUT.PUT_LINE('Province: ' || v_provinceName || 
                             ' | Facilities: ' || v_TotalFacilities || 
                             ' | Capacity: ' || v_TotalCapacity || 
                             ' | Activities: ' || v_TotalActivities || 
                             ' | Utilization: ' || TO_CHAR(ROUND(v_UtilizationPercentage, 2), 'FM99990.00') || '%');
    END LOOP;
END Province_Capacity_Utilization_procedure;
/
