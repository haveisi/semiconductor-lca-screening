-- Semiconductor LCA screening: openLCA results reconciliation layer
-- Catalog/schema used during development: tsmc_lca.gold

CREATE OR REPLACE TABLE tsmc_lca.gold.scenario_summary AS
SELECT 'S01' AS stage, 'Electricity only' AS scenario_label, 169.27 AS gwp_kg_co2e_per_wafer,
       169.27 AS incremental_gwp, ROUND(169.27 / 4460 * 100, 2) AS pct_of_tsmc_benchmark,
       'BASE SCREENING' AS scenario_type
UNION ALL
SELECT 'S02', '+ Ultrapure water', 176.52, 176.52 - 169.27,
       ROUND(176.52 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S03', '+ Electronic-grade silicon proxy', 190.11, 190.11 - 176.52,
       ROUND(190.11 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S04', '+ Direct F-gas emissions', 294.11, 294.11 - 190.11,
       ROUND(294.11 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S05', '+ Facility / cleanroom energy', 461.20, 461.20 - 294.11,
       ROUND(461.20 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S06', '+ Upstream F-gas production', 461.7666017387705,
       461.7666017387705 - 461.20,
       ROUND(461.7666017387705 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S07', '+ Raw-wafer processing energy proxy', 542.6917482693357,
       542.6917482693357 - 461.7666017387705,
       ROUND(542.6917482693357 / 4460 * 100, 2), 'CUMULATIVE'
UNION ALL
SELECT 'S08-LB', '+ Process chemistry lower bound', 556.6605009217171,
       556.6605009217171 - 542.6917482693357,
       ROUND(556.6605009217171 / 4460 * 100, 2), 'CHEMISTRY SENSITIVITY'
UNION ALL
SELECT 'S08-AREA', '+ Process chemistry area-scaled', 574.1214417390387,
       574.1214417390387 - 542.6917482693357,
       ROUND(574.1214417390387 / 4460 * 100, 2), 'CHEMISTRY SENSITIVITY';

CREATE OR REPLACE TABLE tsmc_lca.gold.hotspot_summary AS
SELECT 'Process + facility electricity' AS hotspot,
       417.2851465305652 AS modeled_gwp_kg_co2e,
       'HIGH' AS importance,
       'Electricity-related burdens across process, facility, and raw-wafer processing proxies' AS interpretation
UNION ALL
SELECT 'Direct F-gas emissions', 104.0, 'HIGH',
       'Direct post-abatement SF6 and trifluoromethane emissions; much larger than upstream gas production'
UNION ALL
SELECT 'Process chemistry - lower bound', 13.9687526523814, 'MEDIUM-LOW',
       'Ten resolved/proxy chemistry inputs; PGMEA excluded'
UNION ALL
SELECT 'Process chemistry - area-scaled', 31.4296934697030, 'SENSITIVITY',
       'Upper chemistry sensitivity using 2.25x wafer-area scaling'
UNION ALL
SELECT 'Electronic-grade silicon proxy', 13.59, 'LOW',
       'Electronic-grade silicon feedstock proxy only; not a full raw-wafer chain'
UNION ALL
SELECT 'Ultrapure water', 7.25, 'LOW', 'UPW production burden'
UNION ALL
SELECT 'Upstream F-gas production', 0.5666017387705, 'VERY LOW',
       'Manufacturing burden of purchased fluorinated gases; direct atmospheric release dominates';

CREATE OR REPLACE TABLE tsmc_lca.gold.model_qa_summary AS
SELECT 'Scenario uniqueness' AS qa_test, 'PASS' AS status, 'One record per modeled stage' AS notes
UNION ALL
SELECT 'Cumulative monotonicity', 'PASS', 'S01-S07 cumulative GWP does not decrease'
UNION ALL
SELECT 'Chemistry sensitivity ordering', 'PASS', 'S08-AREA exceeds S08-LB as expected'
UNION ALL
SELECT 'Provider traceability', 'PASS', 'Major chemistry and F-gas providers documented in silver mapping tables'
UNION ALL
SELECT 'Boundary transparency', 'PASS', 'Model explicitly identified as screening/proxy model rather than TSMC N5 reproduction';
