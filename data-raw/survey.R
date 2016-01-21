survey <- read.csv('./data-raw/survey.csv', stringsAsFactors = FALSE)

devtools::use_data(survey, overwrite = TRUE)
