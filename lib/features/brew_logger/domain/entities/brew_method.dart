/// Brew method classification for a brew record or parameter template.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewMethodConfig
enum BrewMethod { pourOver, espresso, custom }

/// Parameter input type for custom brew parameters.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamDefinition
enum ParamType { number, text }
