#!/usr/bin/env Rscript
# Extract sheets from Excel workbook to CSV files
# Triggered by Hazel when Excel file is modified

library(readxl)
library(readr)
library(here)

# Configuration
excel_file <- here::here("data_raw", "2025-07-15_ScopingReview_ReportedConcepts.xlsx")
output_dir <- here::here("data_raw")

# Sheet to CSV filename mapping
sheet_mapping <- list(
  terms_main = "2025_07_15_ScopingReview_ReportedConcepts(terms_main).csv",
  all_concepts_long = "phes_ef_all_concept_long_workbook.csv",
  study_data_extraction_clean = "phes_ef_study_data_extraction_clean.csv"
)

# Check if Excel file exists
if (!file.exists(excel_file)) {
  stop("Excel file not found: ", excel_file)
}

# Get available sheets
available_sheets <- readxl::excel_sheets(excel_file)
cat("Available sheets in Excel file:\n")
cat(paste(" -", available_sheets, collapse = "\n"), "\n\n")

# Extract each mapped sheet
for (sheet_name in names(sheet_mapping)) {
  csv_filename <- sheet_mapping[[sheet_name]]
  csv_path <- file.path(output_dir, csv_filename)

  if (!sheet_name %in% available_sheets) {
    warning("Sheet '", sheet_name, "' not found in Excel file. Skipping.")
    next
  }

  cat("Extracting sheet '", sheet_name, "' to '", csv_filename, "'...\n", sep = "")

  # Read sheet
  data <- readxl::read_excel(
    path = excel_file,
    sheet = sheet_name,
    col_types = "text"  # Read all as text to preserve data exactly
  )

  # Write to CSV
  readr::write_csv(
    x = data,
    file = csv_path,
    na = ""
  )

  cat("  ✓ Wrote ", nrow(data), " rows, ", ncol(data), " columns\n", sep = "")
}

cat("\nExtraction complete!\n")
cat("CSV files updated in: ", output_dir, "\n", sep = "")
