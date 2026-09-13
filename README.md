# Auto Insurance Claim Frequency Analysis

## Project Overview

This project analyzes auto insurance claim frequency using SQL, Python, and actuarial modeling techniques. The analysis uses the freMTPL2 French Motor Third-Party Liability insurance dataset, containing more than 678,000 policy records.

The project follows an end-to-end analytical workflow, beginning with data validation and portfolio exploration in PostgreSQL, followed by exploratory data analysis in Python and the development of a Poisson generalized linear model (GLM) for claim frequency.

The model incorporates policy exposure, evaluates overdispersion, applies Pearson scaling for more appropriate statistical inference, and is validated using a held-out test set and predicted-risk deciles.

The final stage translates the statistical results into actuarial and business insights related to risk segmentation and insurance pricing analysis.


## Skills & Technologies

- **SQL / PostgreSQL:** Data validation, portfolio summaries, risk segmentation, aggregation, and exposure-based claim-frequency analysis
- **Python:** pandas, NumPy, Matplotlib, statsmodels, and scikit-learn
- **Actuarial Modeling:** Claim frequency, exposure, Poisson GLM, rating relativities, overdispersion, and Pearson scaling
- **Model Validation:** Train-test split, out-of-sample calibration, actual vs. predicted frequency, and risk-decile analysis
- **Business Analysis:** Risk segmentation, pricing considerations, model interpretation, and communication of actuarial findings
- **Tools:** PostgreSQL, pgAdmin, Jupyter Notebook, Git, and GitHub

## Project Workflow

The project is organized into the following stages:

1. **Data Validation — SQL**
   - Checked missing values, invalid exposures, claim-count ranges, and key variable distributions.
   - Confirmed data quality before beginning the actuarial analysis.

2. **Portfolio Summary and Risk Segmentation — SQL**
   - Calculated exposure-based claim frequency across key risk characteristics.
   - Examined driver age, vehicle age, BonusMalus, geographic area, and population density.
   - Evaluated two-variable risk segments to identify important portfolio patterns.

3. **Exploratory Data Analysis — Python**
   - Recreated key risk segments using pandas.
   - Visualized claim-frequency patterns and investigated relationships between rating characteristics.

4. **Claim Frequency Modeling — Python**
   - Developed a Poisson GLM using policy exposure.
   - Converted model coefficients into interpretable claim-frequency relativities.
   - Diagnosed overdispersion and applied Pearson scaling to obtain more appropriate statistical inference.

5. **Model Validation**
   - Evaluated the fitted model on a 20% held-out test set.
   - Compared actual and predicted claim frequency across driver-age groups and predicted-risk deciles.

6. **Business and Actuarial Insights**
   - Translated model results into practical risk-segmentation and pricing considerations.
   - Documented model limitations and opportunities for future analysis.

## Key Findings

- **BonusMalus was the strongest modeled risk indicator.** Relative to BonusMalus 50, modeled claim-frequency relativities increased to approximately 1.61 for 51–75, 2.25 for 76–100, and 5.17 for 101+.

- **Driver age provided meaningful risk segmentation.** Drivers aged 18–24 had the highest observed claim frequency at approximately 0.189. After controlling for other modeled characteristics, drivers aged 25–34 and 35–44 had lower modeled claim frequency relative to the 18–24 reference group.

- **Vehicle age showed a consistent relationship with claim frequency.** Relative to vehicles aged 0–10 years, vehicles aged 11–20 and 21+ had modeled claim-frequency relativities of approximately 0.76 and 0.55, respectively.

- **Geographic differences remained after multivariable adjustment.** Area F had an estimated claim-frequency relativity of approximately 1.25 relative to Area A, although geographic variables such as Area and Density are strongly related and should be interpreted cautiously.

- **The initial Poisson model exhibited substantial overdispersion.** The Pearson dispersion statistic was approximately 2.70, so Pearson scaling was applied to provide more appropriate estimates of statistical uncertainty.

- **The model demonstrated reasonable out-of-sample calibration.** On the held-out test set, the model predicted approximately 7,195 claims compared with 7,241 actual claims, an aggregate underprediction of approximately 0.63%.

- **The model demonstrated meaningful risk differentiation.** Actual claim frequency increased from approximately 0.052 in the lowest predicted-risk decile to 0.204 in the highest, meaning the highest-risk decile experienced approximately four times the observed claim frequency of the lowest-risk decile.

## Repository Structure

```text
auto-insurance-claims-analysis/
│
├── README.md
│
├── SQL/
│   ├── 00_create_tables.sql
│   ├── 01_data_validation.sql
│   ├── 02_portfolio_summary.sql
│   └── 03_risk_segmentation.sql
│
└── notebook/
    ├── 01_exploratory_analysis.ipynb
    ├── 02_claim_frequency_model.ipynb
    └── 03_business_insights.ipynb
```

### File Descriptions

- **00_create_tables.sql** — Creates the PostgreSQL table used for the insurance dataset.
- **01_data_validation.sql** — Performs data-quality and validation checks before analysis.
- **02_portfolio_summary.sql** — Calculates overall portfolio statistics and exposure-based claim frequency.
- **03_risk_segmentation.sql** — Examines claim frequency across individual and combined risk characteristics.
- **01_exploratory_analysis.ipynb** — Performs Python-based exploratory analysis and visualization.
- **02_claim_frequency_model.ipynb** — Develops, diagnoses, and validates the claim-frequency GLM.
- **03_business_insights.ipynb** — Summarizes the actuarial and business implications of the analysis.

## Dataset

This project uses the freMTPL2 French Motor Third-Party Liability motor insurance dataset. The version of the frequency dataset used in this project contains 678,013 policy records and includes claim counts, policy exposure, driver characteristics, vehicle characteristics, BonusMalus, and geographic information. Dataset versions available from different sources may contain slightly different record counts; all analyses and results in this project are based on the 678,013-record version used here.

Key variables used in the analysis include:

- **ClaimNb** — Number of claims
- **Exposure** — Policy exposure measured in policy-years
- **DrivAge** — Driver age
- **VehAge** — Vehicle age
- **VehPower** — Vehicle power
- **VehBrand** — Vehicle brand category
- **VehGas** — Vehicle fuel type
- **BonusMalus** — Bonus-malus rating characteristic
- **Area** — Geographic area category
- **Density** — Population density
- **Region** — Geographic region

## Modeling Methodology

Claim frequency is defined as:

**Claim Frequency = Total Claims / Total Exposure**

A Poisson generalized linear model with a log link was used to model claim counts while incorporating policy exposure. The model included driver age, BonusMalus, vehicle age, vehicle power, fuel type, vehicle brand, and geographic area.

The initial Poisson model showed overdispersion, with a Pearson dispersion statistic of approximately 2.70. Pearson scaling was therefore applied to adjust the estimated standard errors and statistical inference for the additional variability.

For out-of-sample validation, the data were randomly divided into an 80% training set and a 20% test set. Model performance was evaluated using aggregate actual versus predicted claims, claim frequency across driver-age groups, and actual versus predicted frequency across predicted-risk deciles.

## Limitations and Future Work

This project was developed as an interpretable actuarial portfolio analysis rather than a production pricing model. Several limitations and opportunities for further development remain:

- The model analyzes **claim frequency only**. A complete loss-cost analysis would also require modeling claim severity.
- Pearson scaling accounts for overdispersion when estimating statistical uncertainty but does not change the underlying Poisson mean structure.
- The current model does not include interaction terms, and additional relationships between rating characteristics may remain unexplained.
- Geographic variables such as Area and Density are strongly related, so their effects should not be interpreted independently without additional analysis.
- Additional model specifications, including alternative approaches for overdispersed count data, could be evaluated.
- Future work could combine frequency and severity models to estimate expected loss cost and provide a more complete actuarial pricing framework.

The project demonstrates an end-to-end actuarial analytics workflow, from SQL-based data validation and portfolio analysis through statistical modeling, model validation, and communication of business insights.
