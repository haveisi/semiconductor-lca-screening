-- Power BI reporting views

CREATE OR REPLACE VIEW tsmc_lca.gold.vw_lca_scenario_dashboard AS
SELECT
    stage,
    scenario_label,
    gwp_kg_co2e_per_wafer,
    incremental_gwp,
    pct_of_tsmc_benchmark,
    scenario_type,
    4460.0 AS tsmc_screening_benchmark,
    4460.0 - gwp_kg_co2e_per_wafer AS unexplained_gap_kg_co2e
FROM tsmc_lca.gold.scenario_summary;

CREATE OR REPLACE VIEW tsmc_lca.gold.vw_scenario_progression AS
SELECT
    stage,
    CASE stage
        WHEN 'S01' THEN 1
        WHEN 'S02' THEN 2
        WHEN 'S03' THEN 3
        WHEN 'S04' THEN 4
        WHEN 'S05' THEN 5
        WHEN 'S06' THEN 6
        WHEN 'S07' THEN 7
        WHEN 'S08-LB' THEN 8
        WHEN 'S08-AREA' THEN 9
        ELSE 99
    END AS stage_sort,
    scenario_label,
    gwp_kg_co2e_per_wafer,
    incremental_gwp,
    pct_of_tsmc_benchmark,
    unexplained_gap_kg_co2e,
    scenario_type
FROM tsmc_lca.gold.vw_lca_scenario_dashboard;

CREATE OR REPLACE VIEW tsmc_lca.gold.vw_hotspots AS
SELECT hotspot, modeled_gwp_kg_co2e, importance, interpretation
FROM tsmc_lca.gold.hotspot_summary;

CREATE OR REPLACE VIEW tsmc_lca.gold.vw_model_qa AS
SELECT qa_test, status, notes
FROM tsmc_lca.gold.model_qa_summary;
