-- ============================================
-- Title : Retrieve Provinces with Average Municipality Population ≥ 4,000,000
-- Author: Joyce Coem
-- Date  : 25 May 2025
-- ============================================

SELECT DISTINCT 
    p.provinceName
FROM 
    provinces p
WHERE 
    p.provinceCode IN (
        SELECT 
            m.provinceCode
        FROM 
            municipalities m
        GROUP BY 
            m.provinceCode
        HAVING 
            AVG(m.avgPopulation) >= 4000000
    );
