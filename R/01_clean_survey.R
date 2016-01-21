#' clean_survey()
#'
#' This function takes two dataframes containing raw ETO data as input, and formats them for further analysis. Both dataframes come from the  "[Admin] raw_prepost" report.
#' @param survey dataframe: Dataframe containing survey data (survey tab)
#' @param codebook dataframe: Dataframe containing codebook data (codebook tab)
#' @param scale list: list of named vectors identifying questions to be aggregated into scales
#' @return list
#' @export
#' @examples
#' df <- laycUtils::load_csv("./path/to/survey/data.csv")
#' codebook <- laycUtils::load_csv("./path/to/codebook/data.csv")
#' clean_survey(survey = df, codebook = codebook)

clean_survey <- function(survey, codebook, scale = NULL){

  # CHECK: that function inputs are valid
  check_input_df(survey, expected_columns = survey_columns)
  check_input_df(codebook, expected_columns = survey_columns)

  # Format dataframes
  survey <- laycUtils::format_data(survey)
  codebook <- laycUtils::format_data(codebook)

  # Identify question types
  codebook <- dplyr::group_by_(codebook, ~pseudo)
  codebook <- dplyr::do_(codebook, ~classify_question(., column = "weight"))
  type <- unique(codebook[, c('pseudo', 'type')])
  survey <- dplyr::left_join(survey, type, by = 'pseudo')

  # Tidy survey data
  temp <- dplyr::filter_(survey, ~is.na(type))
  temp <- dplyr::select_(temp, ~id, ~response_id, ~pseudo, ~answer)
  temp <- tidyr::spread_(temp, key = 'pseudo', value = 'answer')
  temp$dob <- lubridate::mdy_hm(temp$dob)

  survey <- dplyr::left_join(survey, temp, by = c('id', 'response_id'))
  survey <- dplyr::rename_(survey, eto_prepost = ~prepost)


  # Identify prepost test based on dates
  # MOVE TO CHECK DATA ??
  survey <- dplyr::group_by_(survey, 'id')
  survey <- dplyr::do_(survey, ~laycUtils::id_prepost(., date = 'date'))
  survey <- dplyr::ungroup(survey)
  survey <- dplyr::select_(survey, ~id, ~fname, ~lname, ~dob, ~response_id, ~date,
                           ~first, ~last, ~prepost, ~eto_prepost, ~pseudo,
                           ~question, ~answer, ~weight, ~type, ~total)
}


