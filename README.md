# PHES EF — Scoping Review Dictionary & Figures

This repository contains a small Quarto website that documents a term dictionary used in a scoping review and renders a set of figures/tables from CSV source data. It is an RStudio-friendly project; pages are authored in Quarto (`.qmd`) and rendered to static HTML in `docs/` for easy publishing (e.g., GitHub Pages or internal hosting).

## What’s Inside
- **Dictionary:** Renders a browsable glossary from `data_raw/2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv` with anchors, cross-links, and basic metadata.
- **Figures:** Recreates core visuals from CSV sources, including:
  - Table 1 — Study characteristics (via `gt` and saved to `figures/table1_study_characteristics.html`).
  - Upset plot-style matrix and term count bar chart.
  - Bar chart of frameworks used to evaluate surveillance systems (saved to `figures/bar_graph_framework_used.png`).

The site navigation is defined in `qmd/_quarto.yml` and includes Home, Dictionary, and Figures pages.

## Repository Layout
- `qmd/`: Quarto project and content
  - `_quarto.yml`: Project config (outputs into `../docs`, copies `../figures/**`).
  - `index.qmd`: Home page linking to Dictionary and Figures.
  - `dictionary_documentation.qmd`: Builds the term dictionary from the CSV in `data_raw/`.
  - `figures.qmd`: Assembles figures via child partials under `qmd/partials/`.
  - `partials/`: Reusable figure chunks (`_table1_study_characteristics.qmd`, `_upset_plot.qmd`, `_bar_graph_framework_used.qmd`).
- `data_raw/`: Input CSVs used to build the site and figures.
- `figures/`: Generated figure files (HTML/PNG/SVG) written by the rendering code.
- `docs/`: Rendered website output (HTML, assets); served as the site root.
- `phes-ef-scope-private.Rproj`: RStudio project file.
- `LICENSE`: Apache 2.0 license.

## Prerequisites

### R Version
- **Minimum:** R 4.2.0 (compatibility floor for StatsCan/ICES environments)
- **Tested with:** R 4.4.3
- **Switching R versions:**
  - **With rig (recommended if you have admin access):** `rig default 4.2` or use your IDE's interpreter picker
  - **Positron:** Use the interpreter picker (Console pane, upper-right corner) to select R 4.2+
  - **RStudio:** Use Tools → Global Options → General → R version (requires separate R installations)
  - **Without rig:** Download and install R from [CRAN](https://cran.r-project.org/), then configure your IDE to use that installation

### Other Requirements
- Quarto CLI (https://quarto.org/docs/get-started/)
- R packages are managed by **renv** (see setup below)

## Environment Setup

This project uses **renv** for reproducible package management. When you first open the project:

1. **Restore packages:**
   ```r
   renv::restore()
   ```
   This installs all packages at the exact versions specified in `renv.lock`.

2. **Optional - use pak for faster installs:**
   ```r
   install.packages("pak")
   pak::pak("tidyverse")  # Much faster than install.packages()
   ```

3. **After adding new packages:**
   ```r
   renv::snapshot()  # Update renv.lock with new dependencies
   ```

The `.Rprofile` will warn you if your R version is below the 4.2.0 compatibility floor.

## Build the Site
1) Open a terminal in the repo and render the Quarto project:

```bash
cd qmd
quarto render
```

2) Open the generated site at `docs/index.html`.

For live preview while editing:

```bash
cd qmd
quarto preview
```

Notes
- The Quarto project outputs to `../docs` as configured in `qmd/_quarto.yml`.
- Figures are written to the `figures/` directory and copied into the site via the `resources:` setting.

## Data Inputs
- Dictionary terms come from `data_raw/2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv`.
  - The file path can be overridden via the `params.dict_path` parameter in `qmd/dictionary_documentation.qmd`.
- Figures read from:
  - `data_raw/phes_ef_study_data_extraction_clean.csv` (table and bars)
  - `data_raw/phes_ef_all_concept_long_workbook.csv` (matrix/bar combo)

If you replace any data files, keep the same column names expected by the code or update the reading and mapping logic in the corresponding partials.

## Regenerating Figures
- Table 1 is produced by `qmd/partials/_table1_study_characteristics.qmd` and saved to `figures/table1_study_characteristics.html`.
- The “Frameworks used” bar chart is produced by `qmd/partials/_bar_graph_framework_used.qmd` and saved to `figures/bar_graph_framework_used.png`.
- The Upset-like matrix + term-count bars are produced by `qmd/partials/_upset_plot.qmd`.

These run automatically when rendering `qmd/figures.qmd` through Quarto.

## Known Gaps
- In `qmd/figures.qmd`, the “Type of surveillance system” section has a header (`#surv-system`) but no child partial is included. There is a pre-generated image at `figures/bar_graph_surv_system_type.png` that is not currently referenced by the page. Consider either:
  - Adding a partial at `qmd/partials/_surv_system_type.qmd` that generates or embeds the figure, or
  - Embedding the existing PNG directly in `figures.qmd` under that section.

## Development Tips
- To add or remove pages, edit `qmd/_quarto.yml` under `project.render` and `website.navbar`.
- To change the dictionary behavior (anchors, “see also” links), edit `qmd/dictionary_documentation.qmd`.
- CSS customization lives in `qmd/assets/styles.css` (referenced from `_quarto.yml`).

## License
Apache License 2.0 — see `LICENSE` for details.
