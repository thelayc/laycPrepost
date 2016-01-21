codebook <- read.csv('./data-raw/codebook.csv', stringsAsFactors = FALSE)

devtools::use_data(codebook, overwrite = TRUE)
