temp <- read.csv('./data-raw/survey.csv', stringsAsFactors = FALSE)
survey_columns <- colnames(temp)

temp <- read.csv('./data-raw/codebook.csv', stringsAsFactors = FALSE)
codebook_columns <- colnames(temp)

devtools::use_data(survey_columns,
                   codebook_columns, overwrite = TRUE, internal = TRUE)
