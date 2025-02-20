library(tidyverse)
library(janitor)
library(googlesheets4)
library(explore)
library(ggplot2)

gs4_auth(email = "em323ily@gmail.com")

design_url <- "https://docs.google.com/spreadsheets/d/1sOJM3BFcLuIlmo5b-sx1IA4nYFDEFBPheuBjFLAceQg/edit?gid=1164524725#gid=1164524725"

design_voting_raw <- read_sheet(ss = design_url, 
           sheet = "feb_12_25")


# Ranked Choice Voting function

ranked_choice_voting <- function(DATA, choice_1, choice_2, id_col = "id"){
  print(str_glue("Function called with {choice_1} and {choice_2} at {Sys.time()}"))
  current_data <- DATA |> 
    select(!!sym(id_col), !!sym(choice_1), !!sym(choice_2))
  
  summarized_votes <- current_data |> 
    tabyl(choice_1, show_na = FALSE) |> 
    arrange(desc(percent)) 
  
  over_equal_50 <- summarized_votes |> 
    filter(percent >= .5)
  
  # Anything over 50%?
  if (nrow(over_equal_50) > 0) {
    print(str_glue("Over or equal to 50%"))
    print(summarized_votes, n = Inf)
  } else{
    # Take the voting data, summarize, sort by lowest percentage, rank the groups, and grab the lowest group
    min_rank <- summarized_votes |> 
      mutate(rank = dense_rank(desc(n))) |> 
      filter(rank == max(rank))
    # Filter out the min rank group that we're dropping
    voting_minus_min <- summarized_votes |> 
      mutate(rank = dense_rank(desc(n))) |> 
      filter(rank != max(rank)) |> 
      select(-c("percent", "rank"))
    
    # Join the min rank data back into the raw data to identify which rows we need to get the choice_2 from & update
    updated_raw_data <- current_data |> 
      left_join(min_rank, by = setNames(choice_1, choice_2)) |> 
      mutate(!!sym(choice_2) := case_when(rank > 0 ~ NA,
                                 TRUE ~ !!sym(choice_2))) |> 
      select(-c("n", "percent", "rank")) |> 
      left_join(min_rank, by = choice_1) |> 
      mutate(!!sym(choice_1) := case_when(rank > 0 ~ !!sym(choice_2),
                                 TRUE ~ !!sym(choice_1)),
             !!sym(choice_2) := case_when(rank > 0 ~ NA,
                                 TRUE ~ !!sym(choice_2))) |> 
      select(-c("n", "percent", "rank"))
    
    updated_summarized_votes <- updated_raw_data |> 
      tabyl(choice_1, show_na = FALSE) |> 
      arrange(desc(percent))
    
    print(updated_summarized_votes, n = Inf)
    
    return(ranked_choice_round(updated_raw_data, choice_1, choice_2, id_col))
  }
}

# Results 
color_winner <- ranked_choice_voting(design_voting_raw, "color_1", "color_2")
logo_winner <- ranked_choice_voting(design_voting_raw, "logo_1", "logo_2")
hat_winner <- ranked_choice_voting(design_voting_raw, "hat_1", "hat_2")



