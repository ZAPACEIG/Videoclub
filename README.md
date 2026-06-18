# Videoclub

Videoclub is a Microsoft Dynamics 365 Business Central AL extension scaffold for managing a video rental business.

## Scope

The approved scope covers:

- Movie catalog data on top of Business Central Items.
- Genres, actors and movie cast relationships.
- Rental documents with headers and lines.
- Availability, rental registration and return workflows.
- TMDB setup, import logging and future enrichment services.

## Project metadata

- App name: `Videoclub`
- Publisher: `ZAPACEIG`
- Object range: `50100..50149` (provisional, pending human validation)
- Prefix: `VC`
- Main feature: `videoclub`
- Complexity: `HIGH`
- Runtime/BC target: `runtime 15.0`, `platform/application 26.0.0.0` (reasonable initialization default, pending human validation)

## Structure

```text
src/Videoclub/Catalog      Movie catalog, genres, actors and cast scaffolding
src/Videoclub/Rental       Rental document and management scaffolding
src/Videoclub/TMDB         TMDB setup/log/integration scaffolding
src/Videoclub/Permissions  Permission-set scaffolding
src/Videoclub/Setup        Reserved setup/bootstrap area
test/Videoclub/Tests       Initial test placeholders
```

## Initialization notes

This repository was initialized without downloading symbols, compiling, publishing or connecting to any Business Central tenant/container. The AL objects are intentionally minimal bootstrap skeletons and are not a complete business implementation.

## Manual validation checklist

1. Open the folder in Visual Studio Code.
2. Install/enable the Microsoft AL Language extension.
3. Review `app.json`, especially runtime, platform, application and object range.
4. Configure `.vscode/launch.json` for the real sandbox or local environment before use.
5. Download symbols manually only after environment, credentials and target version are approved.
6. Compile and run tests only after symbols are available.
