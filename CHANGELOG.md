# Changelog

All notable changes to the **Refinery89 Modular Mediation SDK for Unity** monorepo are
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.5-beta.2] - 2026-08-19

### Added
- Modular monorepo distribution: 16 independently-installable Unity packages under `Packages/`.
- Base module: `com.refinery89.sdk.mediation-base`.
- Addon modules: `com.refinery89.sdk.mediation-addon-google`,
  `com.refinery89.sdk.mediation-addon-r89-base` (modular),
  `com.refinery89.sdk.mediation-addon-r89` (non-modular, all-in-one).
- Twelve mediation adapter modules under `com.refinery89.sdk.adapters.*`
  (gmaAppLovin, gmaDtExchange, gmaInMobi, gmaIronSource, gmaLiftoff, gmaMeta, gmaMintegral,
  gmaMoloco, gmaPangle, gmaPubMatic, gmaTappx, gmaUnity).
- Per-adapter EDM4U dependency mappings for Android (Maven) and iOS (CocoaPods).
- Scoped third-party Maven repositories: Pangle -> gmaPangle, PubMatic -> gmaPubMatic,
  Mintegral -> gmaMintegral. The non-modular `mediation-addon-r89` includes all three.
- OpenUPM submission metadata for every package under `.openupm/` plus a submission checklist.

### Changed
- Replaced the monolithic single-package layout with the modular monorepo. The all-in-one
  "Main SDK Route" (`com.refinery89.sdk.mediation`) remains available separately on OpenUPM.

### Notes
- All packages are published at `1.2.5-beta.2` using synchronized versioning (a single
  Git tag `v1.2.5-beta.2` builds every package).
