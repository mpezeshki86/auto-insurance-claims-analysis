-- ============================================================
-- RISK SEGMENTATION ANALYSIS
-- Purpose: Identify higher- and lower-risk policy segments
-- by examining combinations of rating characteristics.
-- ============================================================

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
	CASE 
        WHEN bonusmalus = 50 THEN '50'
        WHEN bonusmalus BETWEEN 51 AND 75 THEN '51 to 75'
		WHEN bonusmalus BETWEEN 76 AND 100 THEN '76 to 100'
        WHEN bonusmalus >=101 THEN '101+'
        ELSE 'Unknown'
    END AS bonusmalus_category,
    COUNT(*) AS policy_records,
	SUM(claimnb) AS total_claims,
	SUM(exposure) AS total_exposure,
	ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY age_category, bonusmalus_category
ORDER BY age_category, MIN(bonusmalus);

-- FINDING:
-- BonusMalus remains strongly associated with claim frequency across
-- driver age groups. Policies with BonusMalus 101+ show particularly
-- high observed claim frequencies across all age categories.
--
-- The highest observed frequency occurs among drivers aged 65+ with
-- BonusMalus 101+ (0.4997), followed by drivers aged 18-24 with
-- BonusMalus 101+ (0.4358) and drivers aged 55-64 with BonusMalus
-- 101+ (0.4224).
--
-- However, the 101+ segments contain relatively limited exposure,
-- so these high frequencies should be interpreted cautiously.
--
-- The relationship between driver age and claim frequency also varies
-- within BonusMalus categories, suggesting that age and BonusMalus
-- may provide complementary information for risk segmentation.

SELECT
    area,
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
        area,
        NTILE(4) OVER (ORDER BY density) AS density_quartiles
    FROM policy_frequency
) AS subquery
GROUP BY area, density_quartiles
ORDER BY area, density_quartiles;

-- FINDING:
-- Area and population density are strongly related.
-- Area A observations fall entirely within the lowest density quartile,
-- while Areas E and F fall entirely within the highest density quartile.
-- Intermediate Areas generally occupy neighboring density quartiles.
--
-- Because there is limited overlap in density levels across Areas,
-- it is difficult to isolate the effect of Area from the effect of Density
-- using this descriptive segmentation alone.
--
-- The increasing claim frequency previously observed from Area A to Area F
-- may therefore partly reflect differences in population density.
-- A multivariable model would be needed to evaluate their effects
-- while controlling for other rating characteristics.

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
GROUP BY age_category, vehage_category
ORDER BY age_category, vehage_category;

-- FINDING:
-- Driver age and vehicle age both show meaningful differences in observed
-- claim frequency when analyzed together.
--
-- For most driver age groups, observed claim frequency decreases as
-- vehicle age increases. For example, among drivers aged 25-34,
-- claim frequency decreases from 0.1091 for vehicles aged 0-10 years,
-- to 0.0745 for vehicles aged 11-20 years, and 0.0466 for vehicles aged 21+.
--
-- Drivers aged 18-24 maintain relatively high observed claim frequencies
-- across vehicle-age categories, suggesting that the elevated frequency
-- previously observed for young drivers is not limited to newer vehicles.
--
-- Some 21+ vehicle-age segments contain relatively limited exposure,
-- particularly among drivers aged 18-24, so those estimates should
-- be interpreted cautiously.
--
-- Overall, driver age and vehicle age appear to provide complementary
-- information for risk segmentation.

SELECT
	area,
    CASE 
        WHEN bonusmalus = 50 THEN '50'
        WHEN bonusmalus BETWEEN 51 AND 75 THEN '51 to 75'
		WHEN bonusmalus BETWEEN 76 AND 100 THEN '76 to 100'
        WHEN bonusmalus >=101 THEN '101+'
        ELSE 'Unknown'
    END AS bonusmalus_category,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency
FROM policy_frequency
GROUP BY area, bonusmalus_category
ORDER BY area, MIN(bonusmalus);

-- FINDING:
-- BonusMalus shows a strong relationship with observed claim frequency
-- across all geographic Areas. Within each Area, claim frequency generally
-- increases substantially as BonusMalus increases.
--
-- Geographic differences also remain visible within BonusMalus categories.
-- For example, among policies with BonusMalus = 50, observed claim frequency
-- increases from 0.0693 in Area A to 0.1093 in Area F.
--
-- These results suggest that BonusMalus and geographic Area provide
-- complementary information for risk segmentation rather than one variable
-- fully explaining the effect of the other.
--
-- The 101+ BonusMalus segments contain substantially less exposure than
-- the lower BonusMalus groups, particularly in Area F, so their observed
-- frequencies should be interpreted more cautiously.

SELECT
	area,
    CASE 
        WHEN bonusmalus = 50 THEN '50'
        WHEN bonusmalus BETWEEN 51 AND 75 THEN '51 to 75'
		WHEN bonusmalus BETWEEN 76 AND 100 THEN '76 to 100'
        WHEN bonusmalus >=101 THEN '101+'
        ELSE 'Unknown'
    END AS bonusmalus_category,
    COUNT(*) AS policy_records,
    SUM(claimnb) AS total_claims,
    SUM(exposure) AS total_exposure,
    ROUND((SUM(claimnb) / SUM(exposure))::numeric, 4) AS claim_frequency,
	RANK() OVER (
    ORDER BY SUM(claimnb) / SUM(exposure) DESC
) AS risk_rank
FROM policy_frequency
GROUP BY area, bonusmalus_category
HAVING SUM(exposure) >= 500
ORDER BY risk_rank;

-- FINDING:
-- After restricting the analysis to segments with at least 500
-- policy-years of exposure, Area D with BonusMalus 101+ has the
-- highest observed claim frequency (0.4051), followed by Area E
-- with BonusMalus 101+ (0.3872) and Area C with BonusMalus 101+
-- (0.3644).
--
-- The lowest observed frequencies occur among BonusMalus 50
-- segments, particularly Area A (0.0693) and Area B (0.0704).
--
-- The ranking reinforces the strong risk segmentation observed
-- for BonusMalus while also showing geographic differences within
-- BonusMalus categories.
--
-- Segments with less than 500 policy-years of exposure were excluded
-- from the ranking to reduce the influence of low-exposure segments.