-- PORTFOLIO SUMMARY
-- Purpose: Summarize the overall size and claims experience of the portfolio

SELECT
    COUNT(*) AS total_policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    SUM(claimnb) / SUM(exposure) AS overall_claim_frequency
FROM policy_frequency;

-- FINDING:
-- The portfolio contains 678,013 policy records representing
-- approximately 358,499 policy-years of exposure and 36,102 claims.
-- Overall claim frequency is approximately 0.1007 claims per policy-year,
-- equivalent to 10.07 claims per 100 policy-years.


-- Analyze policy exposure
SELECT
	MIN(exposure) as min_exposure,
	Max(exposure) as max_exposure,
	AVG(exposure) as avg_exposure
FROM policy_frequency;

-- FINDING:
-- Average exposure is approximately 0.529 policy-years per record.
-- Exposure ranges from approximately 0.003 to 2.01 policy-years.
-- The maximum exposure exceeds two years and warrants further investigation.


SELECT
    COUNT(*) AS exposures_more_than_1
FROM policy_frequency
WHERE exposure > 1;

-- FINDING:
-- 1,224 policy records have exposure greater than one year.
-- These observations are rare and are retained for analysis.

SELECT
    COUNT(*) FILTER (WHERE claimnb = 0) AS no_claim_policies,
    COUNT(*) FILTER (WHERE claimnb >= 1) AS one_or_more_claim_policies,
	ROUND((COUNT(*) FILTER (WHERE claimnb >= 1)*100.0)/COUNT(*),2) AS percentage
FROM policy_frequency;

-- FINDING:
-- 34,060 policy records had at least one claim, while 643,953 had no claims.
-- Approximately 5.02% of policy records experienced at least one claim.
-- This differs from claim frequency, which accounts for policy exposure.


SELECT
    CASE 
        WHEN drivage BETWEEN 18 AND 24 THEN '18 to 24'
        WHEN drivage BETWEEN 25 AND 34 THEN '25 to 34'
        WHEN drivage BETWEEN 35 AND 44 THEN '35 to 44'
        WHEN drivage BETWEEN 45 AND 54 THEN '45 to 54'
        WHEN drivage BETWEEN 55 AND 64 THEN '55 to 64'
        WHEN drivage >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS age_category,
    COUNT(*) AS policy_records
FROM policy_frequency
GROUP BY age_category
ORDER BY age_category;

-- FINDING:
-- The portfolio is concentrated among middle-aged drivers.
-- Ages 35-44 represent the largest group, followed by ages 45-54.
-- Drivers aged 18-24 represent the smallest age group.
-- All records were successfully assigned to an age category.

SELECT
    CASE 
        WHEN drivage BETWEEN 18 AND 24 THEN '18 to 24'
        WHEN drivage BETWEEN 25 AND 34 THEN '25 to 34'
        WHEN drivage BETWEEN 35 AND 44 THEN '35 to 44'
        WHEN drivage BETWEEN 45 AND 54 THEN '45 to 54'
        WHEN drivage BETWEEN 55 AND 64 THEN '55 to 64'
        WHEN drivage >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS age_category,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY age_category
ORDER BY age_category;

-- FINDING:
-- Drivers aged 18-24 have the highest observed claim frequency at 0.1893
-- (18.93 claims per 100 policy-years), substantially above the portfolio average.
-- Drivers aged 55-64 have the lowest observed claim frequency at 0.0912.
-- Claim frequency varies meaningfully across driver age groups,
-- suggesting driver age is an important risk segmentation variable.

SELECT
    CASE 
        WHEN vehage BETWEEN 0 AND 10 THEN '0 to 10'
        WHEN vehage BETWEEN 11 AND 20 THEN '11 to 20'
        WHEN vehage >=21 THEN '21+'
        ELSE 'Unknown'
    END AS vehage_category,
    COUNT(*) AS policy_records
FROM policy_frequency
GROUP BY vehage_category
ORDER BY vehage_category;

-- FINDING:
-- Most policy records involve vehicles aged 0-10 years, followed by vehicles aged 11-20 years.
-- Very old vehicle groups contained relatively few records, so vehicles aged 21+ were combined into one category
-- to improve the stability and interpretability of claim-frequency comparisons.

SELECT
    CASE 
        WHEN vehage BETWEEN 0 AND 10 THEN '0 to 10'
        WHEN vehage BETWEEN 11 AND 20 THEN '11 to 20'
        WHEN vehage >=21 THEN '21+'
        ELSE 'Unknown'
    END AS vehage_category,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY vehage_category
ORDER BY vehage_category;

-- FINDING:
-- Vehicles aged 0-10 years have the highest observed claim frequency at 0.1099
-- (10.99 claims per 100 policy-years).
-- Claim frequency decreases to 0.0808 for vehicles aged 11-20 years
-- and 0.0536 for vehicles aged 21+ years.
-- This suggests vehicle age may be an important risk segmentation variable.
-- These are unadjusted observed frequencies and should not be interpreted as causal effects.

SELECT
    CASE 
        WHEN bonusmalus = 50 THEN '50'
        WHEN bonusmalus BETWEEN 51 AND 75 THEN '51 to 75'
		WHEN bonusmalus BETWEEN 76 AND 100 THEN '76 to 100'
		WHEN bonusmalus BETWEEN 101 AND 150 THEN '101 to 150'
        WHEN bonusmalus >=151 THEN '151+'
        ELSE 'Unknown'
    END AS bonusmalus_category,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY bonusmalus_category
ORDER BY 
	MIN(bonusmalus);

-- FINDING:
-- Observed claim frequency increases substantially as BonusMalus increases.
-- Policies with BonusMalus = 50 have the lowest observed frequency at 0.0802,
-- while the 151+ group has the highest frequency at 0.5677.
-- This strong monotonic pattern suggests BonusMalus is an important
-- risk-segmentation variable for claim frequency.
-- The 151+ group contains only 209 records, so its observed frequency
-- should be interpreted cautiously due to the relatively small sample size.

SELECT
    vehgas AS fuel_type,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY vehgas
ORDER BY vehgas;

-- FINDING:
-- Regular-fuel vehicles have a slightly higher observed claim frequency
-- (0.1036) than Diesel vehicles (0.0976).
-- The difference is modest compared with the stronger patterns observed
-- for driver age and BonusMalus.
-- Fuel type may contribute to risk segmentation, but the unadjusted
-- difference alone does not establish a causal relationship.

SELECT
	vehpower AS vehicle_power,
	COUNT(*) AS policy_records,
	SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY vehpower
ORDER BY vehpower;

-- FINDING:
-- Claim frequency varies across vehicle power levels but does not show
-- a clear monotonic relationship with VehPower.
-- VehPower 10 has the highest observed frequency at 0.1164,
-- while VehPower 8 has the lowest at 0.0847.
-- Higher vehicle power does not consistently correspond to higher claim frequency.
-- VehPower may still contribute to risk segmentation when considered
-- alongside other policyholder and vehicle characteristics.

SELECT
	area,
	COUNT(*) AS policy_records,
	SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY area
ORDER BY area;


-- FINDING:
-- Observed claim frequency increases consistently from Area A to Area F.
-- Area A has the lowest claim frequency at 0.0817, while Area F
-- has the highest at 0.1391.
-- Area F's observed claim frequency is approximately 70% higher than Area A's.
-- This suggests geographic area is an important risk-segmentation variable.
-- These are unadjusted frequencies and should not be interpreted as causal effects.

 

SELECT
    density_quartiles,
    MIN(density) AS min_density,
    MAX(density) AS max_density,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM (
    SELECT
        density,
        claimnb,
        exposure,
        NTILE(4) OVER (ORDER BY density) AS density_quartiles
    FROM policy_frequency
) AS subquery
GROUP BY density_quartiles
ORDER BY density_quartiles;

-- FINDING:
-- Observed claim frequency increases steadily across population-density quartiles.
-- The lowest-density quartile has a claim frequency of 0.0841,
-- while the highest-density quartile has a frequency of 0.1252.
-- This suggests higher population density is associated with higher observed claim frequency.
-- These are unadjusted frequencies and should not be interpreted as causal effects.
-- Density quartiles contain approximately equal numbers of policy records.
-- Quartile density ranges overlap at some boundary values because NTILE()
-- may split records with identical density values across adjacent quartiles.


SELECT
	region,
	COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY region
ORDER BY region;

-- FINDING:
-- Claim frequency varies meaningfully across geographic regions.
-- R94 has the highest observed claim frequency at 0.1399,
-- followed by R21 at 0.1327 and R11 at 0.1317.
-- R41 has the lowest observed claim frequency at 0.0753.
-- Some of the highest-frequency regions, including R94 and R21,
-- have relatively limited exposure, so their results should be
-- interpreted more cautiously.
-- R11 also shows a high claim frequency and is supported by
-- substantially greater exposure.
-- Region appears to be a potentially important geographic
-- risk-segmentation variable.

-- ============================================================



-- STEP 3 SUMMARY
-- ============================================================
-- Overall portfolio claim frequency is approximately 0.1007.
--
-- Strong risk-segmentation patterns were observed for:
-- 1. BonusMalus: claim frequency increases substantially as BonusMalus rises.
-- 2. Driver age: drivers aged 18-24 have substantially higher claim frequency.
-- 3. Geographic area: claim frequency increases from Area A through Area F.
-- 4. Population density: higher-density quartiles have higher claim frequency.
-- 5. Region: meaningful geographic variation in claim frequency is present.
--
-- Vehicle age also shows meaningful differences in observed claim frequency.
-- Fuel type shows a relatively modest difference.
-- Vehicle power does not exhibit a clear monotonic relationship with claim frequency.
--
-- These results are descriptive and unadjusted. Differences between groups
-- represent associations in the observed portfolio and should not be
-- interpreted as causal effects.