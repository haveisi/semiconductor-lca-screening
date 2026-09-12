-- Semiconductor LCA screening: inventory and provider mapping layer
-- Catalog/schema used during development: tsmc_lca.silver

CREATE TABLE IF NOT EXISTS tsmc_lca.silver.fgas_provider_mapping (
    gas_name STRING,
    required_input_kg_per_wafer DOUBLE,
    desired_provider STRING,
    provider_name STRING,
    provider_database STRING,
    provider_status STRING,
    evidence_class STRING,
    notes STRING
);

CREATE TABLE IF NOT EXISTS tsmc_lca.silver.raw_wafer_scenarios (
    scenario_id STRING,
    raw_wafer_electricity_kwh_per_wafer DOUBLE,
    source_id STRING,
    evidence_class STRING,
    baseline_eligible BOOLEAN,
    notes STRING
);

CREATE TABLE IF NOT EXISTS tsmc_lca.silver.process_chemistry_proxy (
    chemical_id STRING,
    chemical_name STRING,
    provider_hint STRING,
    quantity_kg_per_200mm_wafer DOUBLE,
    scaling_status STRING,
    evidence_class STRING,
    baseline_eligible BOOLEAN,
    notes STRING
);

CREATE OR REPLACE TABLE tsmc_lca.silver.process_chemistry_300mm_scenarios AS
SELECT
    chemical_id,
    chemical_name,
    provider_hint,
    'LOWER_BOUND' AS scenario_name,
    1.0 AS scaling_factor,
    quantity_kg_per_200mm_wafer AS quantity_kg_per_300mm_wafer,
    evidence_class,
    false AS baseline_eligible,
    '200 mm quantity carried directly to 300 mm as lower-bound sensitivity; not a physical scaling claim.' AS notes
FROM tsmc_lca.silver.process_chemistry_proxy
UNION ALL
SELECT
    chemical_id,
    chemical_name,
    provider_hint,
    'AREA_SCALED' AS scenario_name,
    2.25 AS scaling_factor,
    quantity_kg_per_200mm_wafer * 2.25 AS quantity_kg_per_300mm_wafer,
    evidence_class,
    false AS baseline_eligible,
    'Scaled from 200 mm to 300 mm by wafer area ratio: (300/200)^2 = 2.25. Screening sensitivity only.' AS notes
FROM tsmc_lca.silver.process_chemistry_proxy;

CREATE TABLE IF NOT EXISTS tsmc_lca.silver.process_chemistry_provider_mapping (
    chemical_id STRING,
    chemical_name STRING,
    provider_hint STRING,
    provider_name STRING,
    provider_database STRING,
    provider_status STRING,
    notes STRING
);
