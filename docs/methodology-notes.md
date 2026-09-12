# Methodology notes

This repository documents a screening LCA workflow for a 300 mm N5-like semiconductor wafer. It is not a verified product carbon footprint and does not reproduce proprietary TSMC N5 manufacturing data.

## Functional basis
- Screening basis: 1 x 300 mm wafer proxy
- openLCA target amount used in the foreground model: 0.125 kg N5-like wafer
- Impact method: IPCC 2021 GWP 100

## Scenario logic
S01-S07 are cumulative modeling layers. S08-LB and S08-AREA are alternative chemistry sensitivity cases, not sequential additions.

## Key modeling controls
- Technosphere product providers were kept separate from elementary emissions.
- Direct F-gas emissions were modeled separately from upstream gas production.
- Provider mappings were documented in Databricks before being added to openLCA.
- PGMEA was excluded from the primary chemistry scenarios because no defensible exact production provider was found in the BAFU database used for the exercise.
- TMAH was represented with a trimethylamine proxy and labeled as such.
- Chemistry quantities from a 200 mm public proxy were tested as a lower-bound carryover and a 2.25x wafer-area sensitivity for a 300 mm case.

## Interpretation
The purpose of the project is hotspot identification, sensitivity testing, and boundary-gap diagnosis. The external 4,460 kg CO2e/wafer figure is used only as a screening benchmark; the model was not calibrated to force agreement.
