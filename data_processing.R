# This is an example of manipulating a Census data table for use in R.
# In these scripts, data from the Census Profile is filtered to just the Vancouver Census metropolitan area (CMA) and linked to filtered data from the Proximity Measures.

# The tidyverse package is needed to read and manipulate the data.
library("tidyverse")
setwd("")

# Read the original data into your R environment.

# StatCan Census Profile: https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/page_dl-tc.cfm?Lang=E
# Download Census Profile Canada, provinces, territories, census divisions (CDs), census subdivisions (CSDs) and dissemination areas (DAs) - British Columbia only as a CSV: https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=070
census <- read_csv("bivariate-maps-ggplot2-sf/data/98-401-X2016044_BRITISH_COLUMBIA_eng_CSV/98-401-X2016044_BRITISH_COLUMBIA_English_CSV_data.csv")

# In this case, the following Census variable is of interest.
census_var <- c("Median after-tax income of households in 2015 ($)")

# Cast the column "GEO_CODE (POR)" to numeric for filtering and linking.
census$`GEO_CODE (POR)` <- as.numeric(census$`GEO_CODE (POR)`)

# Filter the data to just "Median after-tax income of households in 2015 ($)" for DAs in Vancouver's CMA.
census_income_vancouver <- filter(census, `DIM: Profile of Dissemination Areas (2247)` == census_var) %>% 
  filter(`GEO_CODE (POR)` > 59150000 & `GEO_CODE (POR)` < 59160000)

# StatCan Proximity Measures: https://www150.statcan.gc.ca/n1/pub/17-26-0002/172600022020001-eng.htm
# Download full Proximity Measures database CSV: https://www150.statcan.gc.ca/pub/17-26-0002/2020001/csv/pmd-eng.zip
# All Proximity Measures databases (pmd) are at the Dissemination Block (DB) level.
pmd <- read_csv("bivariate-maps-ggplot2-sf/data/pmd-eng/PMD-en/pmd-en.csv")

# Filter the Proximity Measures data to just DAs in Vancouver's CMA.
pmd_vancouver <- filter(pmd, `CMANAME` == "Vancouver") 

# Left join the proximity measures to the census_income data frame.
data <- left_join(census_income_vancouver, pmd_vancouver, by = c("GEO_CODE (POR)" = "DAUID"))

# Save the output as a csv for use in the workshop.
write_csv(data, "bivariate-maps-ggplot2-sf/data/data.csv")