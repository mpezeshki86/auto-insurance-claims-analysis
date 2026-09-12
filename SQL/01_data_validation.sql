-- DATA VALIDATION
-- Purpose: Check dataset completeness and identify missing or invalid values

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE exposure IS NULL) AS null_exposure,
    COUNT(*) FILTER (WHERE claimnb IS NULL) AS null_claimnb,
    COUNT(*) FILTER (WHERE exposure <= 0) AS invalid_exposure
FROM policy_frequency;
-- FINDING:
-- 678,013 rows were loaded successfully.
-- No NULL values were found in Exposure or ClaimNb.
-- No zero or negative Exposure values were identified.


-- Check driver age, claim number, and vehicle age ranges

SELECT
    MIN(claimnb) AS min_claimnb_per_policy,
    MAX(claimnb) AS max_claimnb_per_policy,
    MIN(drivage) AS drivage_min,
    MAX(drivage) AS drivage_max,
    MIN(vehage) AS vehage_min,
    MAX(vehage) AS vehage_max
FROM policy_frequency;


-- Check distribution of claims per policy record
-- Investigating the observed maximum of 16 claims

SELECT
    claimnb,
    COUNT(*) AS num_of_policies_per_claimnb
FROM policy_frequency
GROUP BY claimnb
ORDER BY claimnb;


-- Investigate unusually high driver and vehicle ages

SELECT
    COUNT(*) FILTER (WHERE drivage >= 90) AS drivers_age_90_plus,
    COUNT(*) FILTER (WHERE vehage >= 50) AS vehicles_age_50_plus
FROM policy_frequency;

-- Finding:
-- Extreme driver and vehicle ages exist, but they are rare.
-- There is currently no evidence that these observations are erroneous.


-- Check BonusMalus, vehicle power, and population density ranges for potential extreme or invalid values
SELECT
    MIN(bonusmalus) AS bonusmalus_min,
    MAX(bonusmalus) AS bonusmalus_max,
    MIN(vehpower) AS vehpower_min,
    MAX(vehpower) AS vehpower_max,
    MIN(density) AS density_min,
    MAX(density) AS density_max
FROM policy_frequency;

SELECT
    COUNT(*) FILTER (WHERE bonusmalus >= 200) AS bonusmalus_over_200,
    COUNT(*) FILTER (WHERE density >= 20000) AS densities_over_20000
FROM policy_frequency;

-- Extreme-value investigation:
-- Only 4 records have BonusMalus >= 200; retain but flag as extreme.
-- 11,308 records have Density >= 20,000, indicating a meaningful
-- high-density segment rather than isolated outliers.


-- Validate vehicle fuel-type categories and check for unexpected values
SELECT
    vehgas AS fuel_type,
    COUNT(*) AS num_of_policies
FROM policy_frequency
GROUP BY vehgas
ORDER BY vehgas;

-- Validate geographic area categories and check for unexpected values
SELECT
    area AS area_type,
    COUNT(*) AS num_of_policies
FROM policy_frequency
GROUP BY area
ORDER BY area;

-- Validate vehicle brand categories and check for unexpected values
SELECT
    vehbrand AS brand_group,
    COUNT(*) AS num_of_policies
FROM policy_frequency
GROUP BY vehbrand
ORDER BY vehbrand;

-- Validate region categories and check for unexpected or missing values
SELECT
    region AS region_name,
    COUNT(*) AS num_of_policies
FROM policy_frequency
GROUP BY region
ORDER BY region;

-- FINDINGS:
-- VehGas contains two valid categories: Diesel and Regular.
-- Area contains six categories (A-F) with no unexpected values.
-- VehBrand contains 11 encoded brand groups with no missing or malformed categories.
-- Region contains 21 regional categories with no unexpected or missing values.


-- Check uniqueness of policy IDs
SELECT COUNT(*) AS number_of_duplicated_ids
FROM (
    SELECT idpol
    FROM policy_frequency
    GROUP BY idpol
    HAVING COUNT(*) > 1
) AS duplicated_ids;

-- FINDING:
-- No duplicate IDpol values were identified; policy IDs are unique.
