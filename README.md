# PHES EF — Scoping Review Dictionary & Figures

This repository contains a small Quarto website that documents a term dictionary used in a scoping review and renders a set of figures/tables from CSV source data. It is an RStudio-friendly project; pages are authored in Quarto (`.qmd`) and rendered to static HTML in `docs/` for easy publishing (e.g., GitHub Pages or internal hosting).

**🌐 Website:** https://big-life-lab.github.io/phes-ef-scope-private/

**📝 Non-Coders:** See [UPDATING_WEBSITE.md](UPDATING_WEBSITE.md) for how to update the website without using the command line.

## What’s Inside
- **Dictionary:** Renders a browsable glossary from `data_raw/2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv` with anchors, cross-links, and basic metadata.
- **Figures:** Recreates core visuals from CSV sources, including:
  - Table 1 — Study characteristics (via `gt` and saved to `figures/table1_study_characteristics.html`).
  - Upset plot-style matrix and term count bar chart.
  - Bar chart of frameworks used to evaluate surveillance systems (saved to `figures/bar_graph_framework_used.png`).

The site navigation is defined in `_quarto.yml` and includes Home, Dictionary, and Figures pages.

## Repository Layout
- `_quarto.yml`: Quarto project configuration
- `index.qmd`, `dictionary_documentation.qmd`, `figures.qmd`: Main content pages
- `partials/`: Reusable figure chunks (`_table1_study_characteristics.qmd`, `_upset_plot.qmd`, `_bar_graph_framework_used.qmd`)
- `assets/`: CSS and bibliography files
- `data_raw/`: Input CSVs used to build the site and figures
- `figures/`: Generated figure files (HTML/PNG/SVG) written by the rendering code
- `docs/`: Rendered website output (HTML, assets); served as the site root
- `R/`: Helper scripts for data extraction and validation
- `renv/`: R package management
- `phes-ef-scope-private.Rproj`: RStudio project file
- `LICENSE`: Apache 2.0 license

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

Render the Quarto project from the repo root:

```bash
quarto render
```

Open the generated site at `docs/index.html`.

For live preview while editing:

```bash
quarto preview
```

**Notes:**
- The Quarto project outputs to `docs/` as configured in `_quarto.yml`
- Figures are written to the `figures/` directory and copied into the site via the `resources:` setting

## Data Inputs

**Source:** Data originates from an Excel workbook synced from SharePoint/Teams:
```
2025-07-15_ScopingReview_ReportedConcepts.xlsx (committed to git for GitHub Actions)
```

**CSV Files (extracted and committed to git):**
- `data_raw/2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv` - Dictionary terms
- `data_raw/phes_ef_study_data_extraction_clean.csv` - Study characteristics (table and bars)
- `data_raw/phes_ef_all_concept_long_workbook.csv` - Concepts data (matrix/bar combo)

### Updating Data

The Excel workbook is automatically synced from SharePoint via OneDrive. When it changes:

**Option 1: Automatic (Hazel rule configured)**
1. Excel file updates in `data_raw/` via Hazel
2. CSVs are automatically extracted
3. Review changes with `git diff data_raw/*.csv`
4. Commit updated CSVs

**Option 2: Manual extraction**
```r
# Extract sheets from Excel to CSV
source("R/extract_excel_to_csv.R")

# Validate CSV structure
source("R/validate_csv_data.R")
```

**Important:** Both the Excel file and extracted CSV files are committed to git. The GitHub Actions workflow can automatically extract CSVs from the Excel file when the website is updated.

## Regenerating Figures
- Table 1 is produced by `partials/_table1_study_characteristics.qmd` and saved to `figures/table1_study_characteristics.html`
- Bar charts are produced by `partials/_bar_graph_framework_used.qmd` and `partials/_bar_graph_surveillance_system.qmd`
- The upset plot is produced by `partials/_upset_plot.qmd`

These run automatically when rendering `figures.qmd` through Quarto.

## Development Tips
- To add or remove pages, edit `_quarto.yml` under `project.render` and `website.navbar`
- To change the dictionary behavior, edit `dictionary_documentation.qmd`
- CSS customization lives in `assets/styles.css` (referenced from `_quarto.yml`)
- Citations are managed in `assets/PRQ1.bib`

## License
Apache License 2.0 — see `LICENSE` for details.
