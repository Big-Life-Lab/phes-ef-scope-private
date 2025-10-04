# Check R version compatibility
local({
  r_floor <- "4.2.0"
  r_current <- paste(R.version$major, R.version$minor, sep = ".")

  if (utils::compareVersion(r_current, r_floor) < 0) {
    warning(sprintf(
      "\nThis project requires R >= %s for StatsCan/ICES compatibility.\nYou are using R %s.\nConsider switching R versions using rig or your IDE's interpreter picker.",
      r_floor, r_current
    ), call. = FALSE, immediate. = TRUE)
  }
})

source("renv/activate.R")
