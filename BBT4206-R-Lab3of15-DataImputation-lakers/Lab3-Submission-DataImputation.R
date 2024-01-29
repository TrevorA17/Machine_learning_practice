#Load dataset
library(readr)
student_performance_dataset <-
  readr::read_csv(
    "data/StudentPerformanceDataset.csv", # nolint
    col_types =
      readr::cols(
        class_group =
          readr::col_factor(levels = c("A", "B", "C")),
        gender = readr::col_factor(levels = c("1", "0")),
        YOB = readr::col_date(format = "%Y"),
        regret_choosing_bi =
          readr::col_factor(levels = c("1", "0")),
        drop_bi_now =
          readr::col_factor(levels = c("1", "0")),
        motivator =
          readr::col_factor(levels = c("1", "0")),
        read_content_before_lecture =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        anticipate_test_questions =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        answer_rhetorical_questions =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        find_terms_I_do_not_know =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        copy_new_terms_in_reading_notebook =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        take_quizzes_and_use_results =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        reorganise_course_outline =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        write_down_important_points =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        space_out_revision =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        studying_in_study_group =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        schedule_appointments =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        goal_oriented =
          readr::col_factor(levels =
                              c("1", "0")),
        spaced_repetition =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        testing_and_active_recall =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        interleaving =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        categorizing =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        retrospective_timetable =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        cornell_notes =
          readr::col_factor(levels =
                              c("1", "2", "3", "4")),
        sq3r = readr::col_factor(levels =
                                   c("1", "2", "3", "4")),
        commute = readr::col_factor(levels =
                                      c("1", "2",
                                        "3", "4")),
        study_time = readr::col_factor(levels =
                                         c("1", "2",
                                           "3", "4")),
        repeats_since_Y1 = readr::col_integer(),
        paid_tuition = readr::col_factor(levels =
                                           c("0", "1")),
        free_tuition = readr::col_factor(levels =
                                           c("0", "1")),
        extra_curricular = readr::col_factor(levels =
                                               c("0", "1")),
        sports_extra_curricular =
          readr::col_factor(levels = c("0", "1")),
        exercise_per_week = readr::col_factor(levels =
                                                c("0", "1",
                                                  "2",
                                                  "3")),
        meditate = readr::col_factor(levels =
                                       c("0", "1",
                                         "2", "3")),
        pray = readr::col_factor(levels =
                                   c("0", "1",
                                     "2", "3")),
        internet = readr::col_factor(levels =
                                       c("0", "1")),
        laptop = readr::col_factor(levels = c("0", "1")),
        family_relationships =
          readr::col_factor(levels =
                              c("1", "2", "3", "4", "5")),
        friendships = readr::col_factor(levels =
                                          c("1", "2", "3",
                                            "4", "5")),
        romantic_relationships =
          readr::col_factor(levels =
                              c("0", "1", "2", "3", "4")),
        spiritual_wellnes =
          readr::col_factor(levels = c("1", "2", "3",
                                       "4", "5")),
        financial_wellness =
          readr::col_factor(levels = c("1", "2", "3",
                                       "4", "5")),
        health = readr::col_factor(levels = c("1", "2",
                                              "3", "4",
                                              "5")),
        day_out = readr::col_factor(levels = c("0", "1",
                                               "2", "3")),
        night_out = readr::col_factor(levels = c("0",
                                                 "1", "2",
                                                 "3")),
        alcohol_or_narcotics =
          readr::col_factor(levels = c("0", "1", "2", "3")),
        mentor = readr::col_factor(levels = c("0", "1")),
        mentor_meetings = readr::col_factor(levels =
                                              c("0", "1",
                                                "2", "3")),
        `Attendance Waiver Granted: 1 = Yes, 0 = No` =
          readr::col_factor(levels = c("0", "1")),
        GRADE = readr::col_factor(levels =
                                    c("A", "B", "C", "D",
                                      "E"))),
    locale = readr::locale())


## We selected only the following 10 features to be included in the dataset:
StudentPerformanceDataset_long <- student_performance_dataset %>%
  select(regret_choosing_bi, drop_bi_now, financial_wellness, health, day_out, 
         night_out, alcohol_or_narcotics, romantic_relationships, spiritual_wellnes,friendships)

# We then select 100 random observations to be included in the dataset
rand_ind <- sample(seq_len(nrow(StudentPerformanceDataset_long)), 100)
student_performance_dataset <- StudentPerformanceDataset_long[rand_ind, ]

# Are there missing values in the dataset?
any_na(student_performance_dataset)

# How many?
n_miss(student_performance_dataset)

# What is the percentage of missing data in the entire dataset?
prop_miss(student_performance_dataset)

# How many missing values does each variable have?
student_performance_dataset %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(student_performance_dataset)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(student_performance_dataset)

# Which variables contain the most missing values?
gg_miss_var(student_performance_dataset)

# Where are missing values located (the shaded regions in the plot)?
vis_miss(student_performance_dataset) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables are missing together?
gg_miss_upset(student_performance_dataset)

#New variable MAP
student_performance_dataset <- student_performance_dataset %>%
  mutate(
    day_out = as.numeric(day_out),
    health = as.numeric(health),
    MAP = day_out + (1 / 3) * (health - day_out)
  )

somewhat_correlated_variables <- quickpred(student_performance_dataset, mincor = 0.4)

student_performance_dataset_mice <- mice(student_performance_dataset, m = 5, method = "pmm",
                            seed = 4,
                            predictorMatrix = somewhat_correlated_variables)

#strip plot visualiziation
stripplot(student_performance_dataset_mice,
          MAP ~ health | .imp,
          pch = 20, cex = 1)

stripplot(student_performance_dataset_mice,
          MAP ~ night_out | .imp,
          pch = 20, cex = 1)

#create imputed data
student_performance_dataset_imputed <- mice::complete(student_performance_dataset_mice, 1)

#confirmation
miss_var_summary(student_performance_dataset_imputed)

#visual confirmation
Amelia::missmap(student_performance_dataset_imputed)

# Are there missing values in the dataset?
any_na(student_performance_dataset_imputed)

# How many?

n_miss(student_performance_dataset_imputed)

# What is the percentage of missing data in the entire dataset?
prop_miss(student_performance_dataset_imputed)

# How many missing values does each variable have?
student_performance_dataset_imputed %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(student_performance_dataset_imputed)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(student_performance_dataset_imputed)

# Which variables contain the most missing values?
gg_miss_var(student_performance_dataset_imputed)

# We require the "ggplot2" package to create more appealing visualizations

# Where are missing values located (the shaded regions in the plot)?
vis_miss(student_performance_dataset_imputed) + theme(axis.text.x = element_text(angle = 80))

gg_miss_upset(student_performance_dataset_imputed)
