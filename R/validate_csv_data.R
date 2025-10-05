#!/usr/bin/env Rscript
# Validate CSV files extracted from Excel workbook
# Checks structure, required columns, and basic data quality

library(readr)
library(here)

# Configuration
csv_files <- list(
  terms_main = list(
    path = here::here("data_raw", "2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv"),
    required_cols = c("term_name", "term_label", "working_def"),
    min_rows = 1
  ),
  all_concepts_long = list(
    path = here::here("data_raw", "phes_ef_all_concept_long_workbook.csv"),
    required_cols = c("study_id", "year", "reported_concept", "scr_term"),
    min_rows = 1
  ),
  study_data_extraction_clean = list(
    path = here::here("data_raw", "phes_ef_study_data_extraction_clean.csv"),
    required_cols = c("study_id", "extracted_source_title", "corresponding_author_country"),
    min_rows = 1
  )
)

# Validation results
all_valid <- TRUE

cat("Validating CSV files...\n\n")

for (name in names(csv_files)) {
  config <- csv_files[[name]]
  cat("Checking:", basename(config$path), "\n")

  # Check file exists
  if (!file.exists(config$path)) {
    cat("  ✗ ERROR: File not found\n\n")
    all_valid <- FALSE
    next
  }

  # Read CSV
  tryCatch({
    data <- readr::read_csv(
      config$path,
      show_col_types = FALSE,
      col_types = readr::cols(.default = "c")  # Read all as character
    )

    # Check row count
    n_rows <- nrow(data)
    if (n_rows < config$min_rows) {
      cat("  ✗ ERROR: Too few rows (", n_rows, " < ", config$min_rows, ")\n", sep = "")
      all_valid <- FALSE
    } else {
      cat("  ✓ Row count: ", n_rows, "\n", sep = "")
    }

    # Check column count
    cat("  ✓ Column count: ", ncol(data), "\n", sep = "")

    # Check required columns
    missing_cols <- setdiff(config$required_cols, names(data))
    if (length(missing_cols) > 0) {
      cat("  ✗ ERROR: Missing required columns: ", paste(missing_cols, collapse = ", "), "\n", sep = "")
      all_valid <- FALSE
    } else {
      cat("  ✓ All required columns present\n")
    }

    # Check for completely empty file
    if (ncol(data) == 0 || nrow(data) == 0) {
      cat("  ✗ ERROR: File is empty\n")
      all_valid <- FALSE
    }

    cat("\n")

  }, error = function(e) {
    cat("  ✗ ERROR reading CSV: ", e$message, "\n\n", sep = "")
    all_valid <- FALSE
  })
}

# Summary
if (all_valid) {
  cat("✓ All CSV files validated successfully!\n")
  quit(status = 0)
} else {
  cat("✗ Validation failed. Please check errors above.\n")
  quit(status = 1)
}
