#' #' classify_question.R()
#'
#' Identifies whether questions are binary or likert types.
#' @param df dataframe: dataframe
#' @param column: the name of the column to be used for classification (column containing the weights)
#' @return dataframe
#' @export
#' @examples
#' classify_question(codebook, column = "weights)

classify_question <- function(df, column = "weights"){
  if(sum(is.na(df[[column]])) == 0){
  # identify question type
  df$type <- is_likert(df[[column]])
  }
  # return results
  return(df)
}


is_likert <- function(weights) {
  non_zeros <- sum(weights > 0)
  out <- ifelse(non_zeros > 1, 'likert', 'binary')
  return(out)
}

#' check_input_df()
#'
#' Internal: helper function to wrap series of checks for dataframe inputs
#' @param df dataframe: dataframe
#' @param expected_columns character: If relevant, vector containing the names of the expected columns
#' @return logical

check_input_df <- function(df, expected_columns = NULL) {
  assertthat::assert_that(is.data.frame(df))
  if (!is.null(expected_columns)) {
  assertthat::validate_that(length(colnames(df)) == length(survey_columns))
  assertthat::validate_that(identical(sort(colnames(df)), sort(survey_columns)))
  }
}
