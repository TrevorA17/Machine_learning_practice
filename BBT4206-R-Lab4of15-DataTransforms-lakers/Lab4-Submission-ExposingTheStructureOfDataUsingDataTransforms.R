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

# Determine which columns are numeric
data_types <- sapply(student_performance_dataset, class)
column_numbers <- 1:ncol(student_performance_dataset)

# Create a data frame to display the results
column_info <- data.frame(ColumnNumber = column_numbers, DataType = data_types)

# Print the column information
View(column_info)

# Scale Data Transform ----
### The Scale Basic Transform on the Student Performance Dataset ----
# BEFORE
summary(student_performance_dataset)

model_of_the_transform <- preProcess(student_performance_dataset, method = c("scale"))
print(model_of_the_transform)
student_perfomance_dataset_scale_transform <- predict(model_of_the_transform,
                                          student_performance_dataset)
# AFTER
summary(student_perfomance_dataset_scale_transform)

# Center Data Transform ----
# BEFORE
summary(student_performance_dataset)

model_of_the_transform <- preProcess(student_performance_dataset, method = c("center"))
print(model_of_the_transform)
student_performance_dataset_center_transform <- predict(model_of_the_transform, # nolint
                                           student_performance_dataset)

# AFTER
summary(student_performance_dataset_center_transform)

# Standardize Data Transform ----
# BEFORE
summary(student_performance_dataset)


model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
student_performance_dataset_standardize_transform <- predict(model_of_the_transform, # nolint
                                                student_performance_dataset)
# AFTER
summary(student_performance_dataset_standardize_transform)

# Normalize Data Transform ----
### The Normalize Transform on the Student Performance Dataset ----
summary(student_performance_dataset)
model_of_the_transform <- preProcess(student_performance_dataset, method = c("range"))
print(model_of_the_transform)
student_performance_dataset_normalize_transform <- predict(model_of_the_transform, # nolint
                                              student_performance_dataset)
summary(student_performance_dataset_normalize_transform)


# Box-Cox Power Transform ----
# BEFORE
summary(student_performance_dataset)


model_of_the_transform <- preProcess(student_performance_dataset, method = c("BoxCox"))
print(model_of_the_transform)
student_performance_dataset_box_cox_transform <- predict(model_of_the_transform, # nolint
                                                         student_performance_dataset)

# AFTER
summary(student_performance_dataset_box_cox_transform)

# Yeo-Johnson Power Transform ----
# BEFORE
summary(student_performance_dataset)
# Calculate the skewness of two columns
sapply(student_performance_dataset[, 91:94],  skewness, type = 2)

# AFTER
summary(student_performance_dataset_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(student_performance_dataset_yeo_johnson_transform[, 91:94],  skewness, type = 2)

# Principal Component Analysis (PCA) Linear Algebra Transform ----
summary(student_performance_dataset)

model_of_the_transform <- preProcess(student_performance_dataset, method =
                                       c("scale", "center", "pca"))

print(model_of_the_transform)
student_performance_dataset_pca_dr <- predict(model_of_the_transform, student_performance_dataset)

summary(student_performance_dataset_pca_dr)


