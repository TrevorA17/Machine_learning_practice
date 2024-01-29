Business Intelligence Lab Submission Markdown
================
<Specify your group name here>
<Specify the date when you submitted the lab>

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [Load dataset](#load-dataset)
  - [Scale Data Transform](#scale-data-transform)
- [Standardize Data Transform](#standardize-data-transform)
  - [Normalize Data Transform](#normalize-data-transform)
  - [Box-Cox Power Transform](#box-cox-power-transform)
- [AFTER](#after)

# Student Details

|                                                                                                                                                                                                                                   |                                                              |     |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|-----|
| **Student ID Numbers and Names of Group Members** \| \| \| 1. 134780 - C - Trevor Okinda \| \| \| \| 2. 132840 - C - Sheila Wangui \| \| \| \| 3. 131749 - C - Teresia Nungari \| \| \| 4. 135203 - C - Tom Arnold \| \| \| \| \| |                                                              |     |
| **GitHub Classroom Group Name**                                                                                                                                                                                                   | Lakers                                                       |     |
| **Course Code**                                                                                                                                                                                                                   | BBT4206                                                      |     |
| **Course Name**                                                                                                                                                                                                                   | Business Intelligence II                                     |     |
| **Program**                                                                                                                                                                                                                       | Bachelor of Business Information Technology                  |     |
| **Semester Duration**                                                                                                                                                                                                             | 21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023 |     |

# Setup Chunk

We start by installing all the required packages

``` r
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## factoextra ----
if (require("factoextra")) {
  require("factoextra")
} else {
  install.packages("factoextra", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## FactoMineR ----
if (require("FactoMineR")) {
  require("FactoMineR")
} else {
  install.packages("FactoMineR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

------------------------------------------------------------------------

**Note:** the following “*KnitR*” options have been set as the defaults
in this markdown:  
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy.opts = list(width.cutoff = 80), tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

``` r
knitr::opts_chunk$set(
    eval = TRUE,
    echo = TRUE,
    warning = FALSE,
    collapse = FALSE,
    tidy = TRUE
)
```

------------------------------------------------------------------------

**Note:** the following “*R Markdown*” options have been set as the
defaults in this markdown:

> output:  
>   
> github_document:  
> toc: yes  
> toc_depth: 4  
> fig_width: 6  
> fig_height: 4  
> df_print: default  
>   
> editor_options:  
> chunk_output_type: console

# Load dataset

Load the student performance dataset

``` r
library(readr)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
student_performance_dataset <- readr::read_csv("../data/StudentPerformanceDataset.csv",
    col_types = readr::cols(class_group = readr::col_factor(levels = c("A", "B",
        "C")), gender = readr::col_factor(levels = c("1", "0")), YOB = readr::col_date(format = "%Y"),
        regret_choosing_bi = readr::col_factor(levels = c("1", "0")), drop_bi_now = readr::col_factor(levels = c("1",
            "0")), motivator = readr::col_factor(levels = c("1", "0")), read_content_before_lecture = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), anticipate_test_questions = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), answer_rhetorical_questions = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), find_terms_I_do_not_know = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), copy_new_terms_in_reading_notebook = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), take_quizzes_and_use_results = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), reorganise_course_outline = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), write_down_important_points = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), space_out_revision = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), studying_in_study_group = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), schedule_appointments = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), goal_oriented = readr::col_factor(levels = c("1",
            "0")), spaced_repetition = readr::col_factor(levels = c("1", "2", "3",
            "4")), testing_and_active_recall = readr::col_factor(levels = c("1",
            "2", "3", "4")), interleaving = readr::col_factor(levels = c("1", "2",
            "3", "4")), categorizing = readr::col_factor(levels = c("1", "2", "3",
            "4")), retrospective_timetable = readr::col_factor(levels = c("1", "2",
            "3", "4")), cornell_notes = readr::col_factor(levels = c("1", "2", "3",
            "4")), sq3r = readr::col_factor(levels = c("1", "2", "3", "4")), commute = readr::col_factor(levels = c("1",
            "2", "3", "4")), study_time = readr::col_factor(levels = c("1", "2",
            "3", "4")), repeats_since_Y1 = readr::col_integer(), paid_tuition = readr::col_factor(levels = c("0",
            "1")), free_tuition = readr::col_factor(levels = c("0", "1")), extra_curricular = readr::col_factor(levels = c("0",
            "1")), sports_extra_curricular = readr::col_factor(levels = c("0", "1")),
        exercise_per_week = readr::col_factor(levels = c("0", "1", "2", "3")), meditate = readr::col_factor(levels = c("0",
            "1", "2", "3")), pray = readr::col_factor(levels = c("0", "1", "2", "3")),
        internet = readr::col_factor(levels = c("0", "1")), laptop = readr::col_factor(levels = c("0",
            "1")), family_relationships = readr::col_factor(levels = c("1", "2",
            "3", "4", "5")), friendships = readr::col_factor(levels = c("1", "2",
            "3", "4", "5")), romantic_relationships = readr::col_factor(levels = c("0",
            "1", "2", "3", "4")), spiritual_wellnes = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), financial_wellness = readr::col_factor(levels = c("1",
            "2", "3", "4", "5")), health = readr::col_factor(levels = c("1", "2",
            "3", "4", "5")), day_out = readr::col_factor(levels = c("0", "1", "2",
            "3")), night_out = readr::col_factor(levels = c("0", "1", "2", "3")),
        alcohol_or_narcotics = readr::col_factor(levels = c("0", "1", "2", "3")),
        mentor = readr::col_factor(levels = c("0", "1")), mentor_meetings = readr::col_factor(levels = c("0",
            "1", "2", "3")), `Attendance Waiver Granted: 1 = Yes, 0 = No` = readr::col_factor(levels = c("0",
            "1")), GRADE = readr::col_factor(levels = c("A", "B", "C", "D", "E"))),
    locale = readr::locale())
```

## Scale Data Transform

``` r
# BEFORE
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.05                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :3.00                     Min.   :3.00                        
    ##  1st Qu.:4.00                     1st Qu.:4.00                        
    ##  Median :5.00                     Median :5.00                        
    ##  Mean   :4.49                     Mean   :4.68                        
    ##  3rd Qu.:5.00                     3rd Qu.:5.00                        
    ##  Max.   :5.00                     Max.   :5.00                        
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :3.00                                                                                   
    ##  1st Qu.:4.00                                                                                   
    ##  Median :4.00                                                                                   
    ##  Mean   :4.35                                                                                   
    ##  3rd Qu.:5.00                                                                                   
    ##  Max.   :5.00                                                                                   
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :3.00                                                                                     
    ##  1st Qu.:4.75                                                                                     
    ##  Median :5.00                                                                                     
    ##  Mean   :4.74                                                                                     
    ##  3rd Qu.:5.00                                                                                     
    ##  Max.   :5.00                                                                                     
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :2.00                                       
    ##  1st Qu.:4.00                                       
    ##  Median :5.00                                       
    ##  Mean   :4.65                                       
    ##  3rd Qu.:5.00                                       
    ##  Max.   :5.00                                       
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :1.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :4.00                                     
    ##  Mean   :4.11                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :2.00                                                      
    ##  1st Qu.:4.00                                                      
    ##  Median :4.00                                                      
    ##  Mean   :4.38                                                      
    ##  3rd Qu.:5.00                                                      
    ##  Max.   :5.00                                                      
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :1.00                                           
    ##  1st Qu.:4.00                                           
    ##  Median :5.00                                           
    ##  Mean   :4.61                                           
    ##  3rd Qu.:5.00                                           
    ##  Max.   :5.00                                           
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :3.00                      
    ##  1st Qu.:4.00                      
    ##  Median :5.00                      
    ##  Mean   :4.58                      
    ##  3rd Qu.:5.00                      
    ##  Max.   :5.00                      
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :3.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :5.00                                     
    ##  Mean   :4.55                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :3.0                                
    ##  1st Qu.:4.0                                
    ##  Median :5.0                                
    ##  Mean   :4.7                                
    ##  3rd Qu.:5.0                                
    ##  Max.   :5.0                                
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :1.00                                                                         
    ##  1st Qu.:4.00                                                                         
    ##  Median :4.00                                                                         
    ##  Mean   :4.25                                                                         
    ##  3rd Qu.:5.00                                                                         
    ##  Max.   :5.00                                                                         
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :2.00                                                     
    ##  1st Qu.:3.00                                                     
    ##  Median :4.00                                                     
    ##  Mean   :3.94                                                     
    ##  3rd Qu.:5.00                                                     
    ##  Max.   :5.00                                                     
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :2.00                             
    ##  1st Qu.:4.00                             
    ##  Median :5.00                             
    ##  Mean   :4.59                             
    ##  3rd Qu.:5.00                             
    ##  Max.   :5.00                             
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :3.00                                                       
    ##  1st Qu.:4.00                                                       
    ##  Median :5.00                                                       
    ##  Mean   :4.61                                                       
    ##  3rd Qu.:5.00                                                       
    ##  Max.   :5.00                                                       
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :3.00                                                                                                       
    ##  1st Qu.:4.00                                                                                                       
    ##  Median :5.00                                                                                                       
    ##  Mean   :4.55                                                                                                       
    ##  3rd Qu.:5.00                                                                                                       
    ##  Max.   :5.00                                                                                                       
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :1.00                        
    ##  1st Qu.:4.00                        
    ##  Median :4.00                        
    ##  Mean   :4.19                        
    ##  3rd Qu.:5.00                        
    ##  Max.   :5.00                        
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :1.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.08                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :1.00                         Min.   :2.0           
    ##  1st Qu.:4.00                         1st Qu.:4.0           
    ##  Median :4.00                         Median :5.0           
    ##  Mean   :4.17                         Mean   :4.6           
    ##  3rd Qu.:5.00                         3rd Qu.:5.0           
    ##  Max.   :5.00                         Max.   :5.0           
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :2.0                                       
    ##  1st Qu.:4.0                                       
    ##  Median :5.0                                       
    ##  Mean   :4.6                                       
    ##  3rd Qu.:5.0                                       
    ##  Max.   :5.0                                       
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :2.00                                                                                                                                                                                                                                                                                 
    ##  1st Qu.:4.00                                                                                                                                                                                                                                                                                 
    ##  Median :5.00                                                                                                                                                                                                                                                                                 
    ##  Mean   :4.54                                                                                                                                                                                                                                                                                 
    ##  3rd Qu.:5.00                                                                                                                                                                                                                                                                                 
    ##  Max.   :5.00                                                                                                                                                                                                                                                                                 
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :2.00                                                                                                                                                                    
    ##  1st Qu.:4.00                                                                                                                                                                    
    ##  Median :5.00                                                                                                                                                                    
    ##  Mean   :4.49                                                                                                                                                                    
    ##  3rd Qu.:5.00                                                                                                                                                                    
    ##  Max.   :5.00                                                                                                                                                                    
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :2.00                            
    ##  1st Qu.:4.00                            
    ##  Median :5.00                            
    ##  Mean   :4.33                            
    ##  3rd Qu.:5.00                            
    ##  Max.   :5.00                            
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :2.909                    Min.   :2.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.531                    Mean   :4.095                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :3.182                                    
    ##  1st Qu.:4.068                                    
    ##  Median :4.545                                    
    ##  Mean   :4.432                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.015                  Mean   : 62.39                  
    ##  3rd Qu.:1.250                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 3.00                    
    ##  1st Qu.:11.53                           1st Qu.: 7.00                    
    ##  Median :15.33                           Median : 9.00                    
    ##  Mean   :16.36                           Mean   : 9.53                    
    ##  3rd Qu.:19.63                           3rd Qu.:12.00                    
    ##  Max.   :31.25                           Max.   :15.00                    
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 3.00                         Min.   : 0.000                         
    ##  1st Qu.:10.91                         1st Qu.: 5.000                         
    ##  Median :13.50                         Median : 6.330                         
    ##  Mean   :13.94                         Mean   : 6.367                         
    ##  3rd Qu.:17.50                         3rd Qu.: 8.000                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :3.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.898                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :2.150                                                 
    ##  1st Qu.:3.150                                                 
    ##  Median :4.850                                                 
    ##  Mean   :4.166                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :2.85                                                   
    ##  1st Qu.:4.85                                                   
    ##  Median :4.85                                                   
    ##  Mean   :4.63                                                   
    ##  3rd Qu.:4.85                                                   
    ##  Max.   :5.00                                                   
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :1.850                                    
    ##  1st Qu.:4.100                                    
    ##  Median :4.850                                    
    ##  Mean   :4.425                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :32.89          Min.   :  0.00         
    ##  1st Qu.:59.21          1st Qu.: 51.00         
    ##  Median :69.73          Median : 63.50         
    ##  Mean   :69.39          Mean   : 62.13         
    ##  3rd Qu.:82.89          3rd Qu.: 81.75         
    ##  Max.   :97.36          Max.   :100.00         
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 5.00   
    ##  1st Qu.:20.44                1st Qu.:26.00   
    ##  Median :24.58                Median :34.00   
    ##  Mean   :24.53                Mean   :33.94   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72                                
    ## 

``` r
model_of_the_transform <- preProcess(student_performance_dataset, method = c("scale"))
print(model_of_the_transform)
```

    ## Created from 51 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - ignored (51)
    ##   - scaled (49)

``` r
student_perfomance_dataset_scale_transform <- predict(model_of_the_transform, student_performance_dataset)
# AFTER
summary(student_perfomance_dataset_scale_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :0.0000   0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:0.0000   1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median :0.9479   NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   :0.9716               
    ##                       NA's: 1   NA's: 1    3rd Qu.:1.4218               
    ##                                            Max.   :4.7394               
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :5.046                    Min.   : 6.124                      
    ##  1st Qu.:6.728                    1st Qu.: 8.165                      
    ##  Median :8.410                    Median :10.206                      
    ##  Mean   :7.553                    Mean   : 9.553                      
    ##  3rd Qu.:8.410                    3rd Qu.:10.206                      
    ##  Max.   :8.410                    Max.   :10.206                      
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :4.565                                                                                  
    ##  1st Qu.:6.087                                                                                  
    ##  Median :6.087                                                                                  
    ##  Mean   :6.620                                                                                  
    ##  3rd Qu.:7.609                                                                                  
    ##  Max.   :7.609                                                                                  
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   : 6.477                                                                                   
    ##  1st Qu.:10.255                                                                                   
    ##  Median :10.795                                                                                   
    ##  Mean   :10.233                                                                                   
    ##  3rd Qu.:10.795                                                                                   
    ##  Max.   :10.795                                                                                   
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :3.477                                      
    ##  1st Qu.:6.955                                      
    ##  Median :8.693                                      
    ##  Mean   :8.085                                      
    ##  3rd Qu.:8.693                                      
    ##  Max.   :8.693                                      
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :1.143                                    
    ##  1st Qu.:4.572                                    
    ##  Median :4.572                                    
    ##  Mean   :4.697                                    
    ##  3rd Qu.:5.715                                    
    ##  Max.   :5.715                                    
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :2.886                                                     
    ##  1st Qu.:5.771                                                     
    ##  Median :5.771                                                     
    ##  Mean   :6.319                                                     
    ##  3rd Qu.:7.214                                                     
    ##  Max.   :7.214                                                     
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :1.539                                          
    ##  1st Qu.:6.157                                          
    ##  Median :7.696                                          
    ##  Mean   :7.095                                          
    ##  3rd Qu.:7.696                                          
    ##  Max.   :7.696                                          
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :5.417                     
    ##  1st Qu.:7.223                     
    ##  Median :9.029                     
    ##  Mean   :8.271                     
    ##  3rd Qu.:9.029                     
    ##  Max.   :9.029                     
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :4.795                                    
    ##  1st Qu.:6.394                                    
    ##  Median :7.992                                    
    ##  Mean   :7.273                                    
    ##  3rd Qu.:7.992                                    
    ##  Max.   :7.992                                    
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :5.745                              
    ##  1st Qu.:7.659                              
    ##  Median :9.574                              
    ##  Mean   :9.000                              
    ##  3rd Qu.:9.574                              
    ##  Max.   :9.574                              
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :1.277                                                                        
    ##  1st Qu.:5.106                                                                        
    ##  Median :5.106                                                                        
    ##  Mean   :5.425                                                                        
    ##  3rd Qu.:6.383                                                                        
    ##  Max.   :6.383                                                                        
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :2.319                                                    
    ##  1st Qu.:3.478                                                    
    ##  Median :4.638                                                    
    ##  Mean   :4.568                                                    
    ##  3rd Qu.:5.797                                                    
    ##  Max.   :5.797                                                    
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :3.22                             
    ##  1st Qu.:6.44                             
    ##  Median :8.05                             
    ##  Mean   :7.39                             
    ##  3rd Qu.:8.05                             
    ##  Max.   :8.05                             
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :4.990                                                      
    ##  1st Qu.:6.653                                                      
    ##  Median :8.316                                                      
    ##  Mean   :7.667                                                      
    ##  3rd Qu.:8.316                                                      
    ##  Max.   :8.316                                                      
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :4.924                                                                                                      
    ##  1st Qu.:6.565                                                                                                      
    ##  Median :8.207                                                                                                      
    ##  Mean   :7.468                                                                                                      
    ##  3rd Qu.:8.207                                                                                                      
    ##  Max.   :8.207                                                                                                      
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :1.131                       
    ##  1st Qu.:4.524                       
    ##  Median :4.524                       
    ##  Mean   :4.739                       
    ##  3rd Qu.:5.655                       
    ##  Max.   :5.655                       
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :1.008                             
    ##  1st Qu.:4.034                             
    ##  Median :4.034                             
    ##  Mean   :4.114                             
    ##  3rd Qu.:5.042                             
    ##  Max.   :5.042                             
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :1.037                        Min.   :2.760         
    ##  1st Qu.:4.147                        1st Qu.:5.519         
    ##  Median :4.147                        Median :6.899         
    ##  Mean   :4.323                        Mean   :6.347         
    ##  3rd Qu.:5.184                        3rd Qu.:6.899         
    ##  Max.   :5.184                        Max.   :6.899         
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :3.146                                     
    ##  1st Qu.:6.293                                     
    ##  Median :7.866                                     
    ##  Mean   :7.237                                     
    ##  3rd Qu.:7.866                                     
    ##  Max.   :7.866                                     
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :3.040                                                                                                                                                                                                                                                                                
    ##  1st Qu.:6.081                                                                                                                                                                                                                                                                                
    ##  Median :7.601                                                                                                                                                                                                                                                                                
    ##  Mean   :6.902                                                                                                                                                                                                                                                                                
    ##  3rd Qu.:7.601                                                                                                                                                                                                                                                                                
    ##  Max.   :7.601                                                                                                                                                                                                                                                                                
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :2.903                                                                                                                                                                   
    ##  1st Qu.:5.806                                                                                                                                                                   
    ##  Median :7.257                                                                                                                                                                   
    ##  Mean   :6.517                                                                                                                                                                   
    ##  3rd Qu.:7.257                                                                                                                                                                   
    ##  Max.   :7.257                                                                                                                                                                   
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :2.343                           
    ##  1st Qu.:4.687                           
    ##  Median :5.859                           
    ##  Mean   :5.074                           
    ##  3rd Qu.:5.859                           
    ##  Max.   :5.859                           
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   : 7.267                   Min.   :2.833                            
    ##  1st Qu.:10.674                   1st Qu.:4.957                            
    ##  Median :11.355                   Median :5.666                            
    ##  Mean   :11.319                   Mean   :5.800                            
    ##  3rd Qu.:12.264                   3rd Qu.:6.374                            
    ##  Max.   :12.491                   Max.   :7.082                            
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :6.297                                    
    ##  1st Qu.:8.051                                    
    ##  Median :8.995                                    
    ##  Mean   :8.770                                    
    ##  3rd Qu.:9.715                                    
    ##  Max.   :9.895                                    
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :0.000                    Min.   :0.000                    
    ##  1st Qu.:3.521                    1st Qu.:2.151                    
    ##  Median :4.044                    Median :2.797                    
    ##  Mean   :3.811                    Mean   :2.360                    
    ##  3rd Qu.:4.282                    3rd Qu.:2.976                    
    ##  Max.   :4.758                    Max.   :3.585                    
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.0000                 Min.   :0.000                   
    ##  1st Qu.:0.0000                 1st Qu.:2.779                   
    ##  Median :0.0000                 Median :3.295                   
    ##  Mean   :0.5683                 Mean   :3.096                   
    ##  3rd Qu.:0.6998                 3rd Qu.:3.553                   
    ##  Max.   :2.7993                 Max.   :4.962                   
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :0.7302                          Min.   :0.9661                   
    ##  1st Qu.:1.7724                          1st Qu.:2.2543                   
    ##  Median :2.3565                          Median :2.8984                   
    ##  Mean   :2.5144                          Mean   :3.0692                   
    ##  3rd Qu.:3.0175                          3rd Qu.:3.8646                   
    ##  Max.   :4.8038                          Max.   :4.8307                   
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :0.6769                        Min.   :0.000                          
    ##  1st Qu.:2.4628                        1st Qu.:2.381                          
    ##  Median :3.0461                        Median :3.014                          
    ##  Mean   :3.1444                        Mean   :3.032                          
    ##  3rd Qu.:3.9486                        3rd Qu.:3.809                          
    ##  Max.   :4.9640                        Max.   :6.033                          
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :1.592                                  
    ##  1st Qu.:2.657                                  
    ##  Median :3.353                                  
    ##  Mean   :3.408                                  
    ##  3rd Qu.:3.951                                  
    ##  Max.   :5.775                                  
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   : 7.634                               
    ##  1st Qu.:12.723                               
    ##  Median :12.723                               
    ##  Mean   :12.464                               
    ##  3rd Qu.:12.723                               
    ##  Max.   :12.723                               
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :2.078                                                 
    ##  1st Qu.:3.044                                                 
    ##  Median :4.687                                                 
    ##  Mean   :4.026                                                 
    ##  3rd Qu.:4.832                                                 
    ##  Max.   :4.832                                                 
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :4.450                                                  
    ##  1st Qu.:7.572                                                  
    ##  Median :7.572                                                  
    ##  Mean   :7.229                                                  
    ##  3rd Qu.:7.572                                                  
    ##  Max.   :7.806                                                  
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :2.054                                    
    ##  1st Qu.:4.552                                    
    ##  Median :5.385                                    
    ##  Mean   :4.913                                    
    ##  3rd Qu.:5.551                                    
    ##  Max.   :5.551                                    
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   :0.9221          
    ##  1st Qu.:0.000                        1st Qu.:3.6678          
    ##  Median :2.143                        Median :4.1444          
    ##  Mean   :1.459                        Mean   :4.1297          
    ##  3rd Qu.:2.143                        3rd Qu.:5.0355          
    ##  Max.   :2.143                        Max.   :5.1805          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :2.175          Min.   :0.000          
    ##  1st Qu.:3.915          1st Qu.:2.067          
    ##  Median :4.610          Median :2.574          
    ##  Mean   :4.588          Mean   :2.518          
    ##  3rd Qu.:5.480          3rd Qu.:3.314          
    ##  Max.   :6.437          Max.   :4.053          
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :0.0000        
    ##  1: 5                                       1st Qu.:0.8153        
    ##                                             Median :1.6295        
    ##                                             Mean   :1.6961        
    ##                                             3rd Qu.:2.4448        
    ##                                             Max.   :5.7049        
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   :1.200                Min.   :0.4441  
    ##  1st Qu.:3.284                1st Qu.:2.3094  
    ##  Median :3.949                Median :3.0200  
    ##  Mean   :3.941                Mean   :3.0145  
    ##  3rd Qu.:4.709                3rd Qu.:3.7306  
    ##  Max.   :5.636                Max.   :4.9742  
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :0.475                          A:23  
    ##  1st Qu.:2.896                          B:25  
    ##  Median :3.732                          C:22  
    ##  Mean   :3.632                          D:25  
    ##  3rd Qu.:4.377                          E: 6  
    ##  Max.   :5.578                                
    ## 

Next, Center Data Transform

``` r
# BEFORE
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.05                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :3.00                     Min.   :3.00                        
    ##  1st Qu.:4.00                     1st Qu.:4.00                        
    ##  Median :5.00                     Median :5.00                        
    ##  Mean   :4.49                     Mean   :4.68                        
    ##  3rd Qu.:5.00                     3rd Qu.:5.00                        
    ##  Max.   :5.00                     Max.   :5.00                        
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :3.00                                                                                   
    ##  1st Qu.:4.00                                                                                   
    ##  Median :4.00                                                                                   
    ##  Mean   :4.35                                                                                   
    ##  3rd Qu.:5.00                                                                                   
    ##  Max.   :5.00                                                                                   
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :3.00                                                                                     
    ##  1st Qu.:4.75                                                                                     
    ##  Median :5.00                                                                                     
    ##  Mean   :4.74                                                                                     
    ##  3rd Qu.:5.00                                                                                     
    ##  Max.   :5.00                                                                                     
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :2.00                                       
    ##  1st Qu.:4.00                                       
    ##  Median :5.00                                       
    ##  Mean   :4.65                                       
    ##  3rd Qu.:5.00                                       
    ##  Max.   :5.00                                       
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :1.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :4.00                                     
    ##  Mean   :4.11                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :2.00                                                      
    ##  1st Qu.:4.00                                                      
    ##  Median :4.00                                                      
    ##  Mean   :4.38                                                      
    ##  3rd Qu.:5.00                                                      
    ##  Max.   :5.00                                                      
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :1.00                                           
    ##  1st Qu.:4.00                                           
    ##  Median :5.00                                           
    ##  Mean   :4.61                                           
    ##  3rd Qu.:5.00                                           
    ##  Max.   :5.00                                           
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :3.00                      
    ##  1st Qu.:4.00                      
    ##  Median :5.00                      
    ##  Mean   :4.58                      
    ##  3rd Qu.:5.00                      
    ##  Max.   :5.00                      
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :3.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :5.00                                     
    ##  Mean   :4.55                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :3.0                                
    ##  1st Qu.:4.0                                
    ##  Median :5.0                                
    ##  Mean   :4.7                                
    ##  3rd Qu.:5.0                                
    ##  Max.   :5.0                                
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :1.00                                                                         
    ##  1st Qu.:4.00                                                                         
    ##  Median :4.00                                                                         
    ##  Mean   :4.25                                                                         
    ##  3rd Qu.:5.00                                                                         
    ##  Max.   :5.00                                                                         
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :2.00                                                     
    ##  1st Qu.:3.00                                                     
    ##  Median :4.00                                                     
    ##  Mean   :3.94                                                     
    ##  3rd Qu.:5.00                                                     
    ##  Max.   :5.00                                                     
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :2.00                             
    ##  1st Qu.:4.00                             
    ##  Median :5.00                             
    ##  Mean   :4.59                             
    ##  3rd Qu.:5.00                             
    ##  Max.   :5.00                             
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :3.00                                                       
    ##  1st Qu.:4.00                                                       
    ##  Median :5.00                                                       
    ##  Mean   :4.61                                                       
    ##  3rd Qu.:5.00                                                       
    ##  Max.   :5.00                                                       
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :3.00                                                                                                       
    ##  1st Qu.:4.00                                                                                                       
    ##  Median :5.00                                                                                                       
    ##  Mean   :4.55                                                                                                       
    ##  3rd Qu.:5.00                                                                                                       
    ##  Max.   :5.00                                                                                                       
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :1.00                        
    ##  1st Qu.:4.00                        
    ##  Median :4.00                        
    ##  Mean   :4.19                        
    ##  3rd Qu.:5.00                        
    ##  Max.   :5.00                        
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :1.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.08                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :1.00                         Min.   :2.0           
    ##  1st Qu.:4.00                         1st Qu.:4.0           
    ##  Median :4.00                         Median :5.0           
    ##  Mean   :4.17                         Mean   :4.6           
    ##  3rd Qu.:5.00                         3rd Qu.:5.0           
    ##  Max.   :5.00                         Max.   :5.0           
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :2.0                                       
    ##  1st Qu.:4.0                                       
    ##  Median :5.0                                       
    ##  Mean   :4.6                                       
    ##  3rd Qu.:5.0                                       
    ##  Max.   :5.0                                       
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :2.00                                                                                                                                                                                                                                                                                 
    ##  1st Qu.:4.00                                                                                                                                                                                                                                                                                 
    ##  Median :5.00                                                                                                                                                                                                                                                                                 
    ##  Mean   :4.54                                                                                                                                                                                                                                                                                 
    ##  3rd Qu.:5.00                                                                                                                                                                                                                                                                                 
    ##  Max.   :5.00                                                                                                                                                                                                                                                                                 
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :2.00                                                                                                                                                                    
    ##  1st Qu.:4.00                                                                                                                                                                    
    ##  Median :5.00                                                                                                                                                                    
    ##  Mean   :4.49                                                                                                                                                                    
    ##  3rd Qu.:5.00                                                                                                                                                                    
    ##  Max.   :5.00                                                                                                                                                                    
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :2.00                            
    ##  1st Qu.:4.00                            
    ##  Median :5.00                            
    ##  Mean   :4.33                            
    ##  3rd Qu.:5.00                            
    ##  Max.   :5.00                            
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :2.909                    Min.   :2.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.531                    Mean   :4.095                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :3.182                                    
    ##  1st Qu.:4.068                                    
    ##  Median :4.545                                    
    ##  Mean   :4.432                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.015                  Mean   : 62.39                  
    ##  3rd Qu.:1.250                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 3.00                    
    ##  1st Qu.:11.53                           1st Qu.: 7.00                    
    ##  Median :15.33                           Median : 9.00                    
    ##  Mean   :16.36                           Mean   : 9.53                    
    ##  3rd Qu.:19.63                           3rd Qu.:12.00                    
    ##  Max.   :31.25                           Max.   :15.00                    
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 3.00                         Min.   : 0.000                         
    ##  1st Qu.:10.91                         1st Qu.: 5.000                         
    ##  Median :13.50                         Median : 6.330                         
    ##  Mean   :13.94                         Mean   : 6.367                         
    ##  3rd Qu.:17.50                         3rd Qu.: 8.000                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :3.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.898                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :2.150                                                 
    ##  1st Qu.:3.150                                                 
    ##  Median :4.850                                                 
    ##  Mean   :4.166                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :2.85                                                   
    ##  1st Qu.:4.85                                                   
    ##  Median :4.85                                                   
    ##  Mean   :4.63                                                   
    ##  3rd Qu.:4.85                                                   
    ##  Max.   :5.00                                                   
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :1.850                                    
    ##  1st Qu.:4.100                                    
    ##  Median :4.850                                    
    ##  Mean   :4.425                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :32.89          Min.   :  0.00         
    ##  1st Qu.:59.21          1st Qu.: 51.00         
    ##  Median :69.73          Median : 63.50         
    ##  Mean   :69.39          Mean   : 62.13         
    ##  3rd Qu.:82.89          3rd Qu.: 81.75         
    ##  Max.   :97.36          Max.   :100.00         
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 5.00   
    ##  1st Qu.:20.44                1st Qu.:26.00   
    ##  Median :24.58                Median :34.00   
    ##  Mean   :24.53                Mean   :33.94   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72                                
    ## 

``` r
model_of_the_transform <- preProcess(student_performance_dataset, method = c("center"))
print(model_of_the_transform)
```

    ## Created from 51 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - ignored (51)

``` r
student_performance_dataset_center_transform <- predict(model_of_the_transform, # nolint
                                           student_performance_dataset)

# AFTER
summary(student_performance_dataset_center_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-2.05    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-2.05    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median :-0.05    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.00                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.95                
    ##                                            Max.   : 7.95                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-1.49                    Min.   :-1.68                       
    ##  1st Qu.:-0.49                    1st Qu.:-0.68                       
    ##  Median : 0.51                    Median : 0.32                       
    ##  Mean   : 0.00                    Mean   : 0.00                       
    ##  3rd Qu.: 0.51                    3rd Qu.: 0.32                       
    ##  Max.   : 0.51                    Max.   : 0.32                       
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-1.35                                                                                  
    ##  1st Qu.:-0.35                                                                                  
    ##  Median :-0.35                                                                                  
    ##  Mean   : 0.00                                                                                  
    ##  3rd Qu.: 0.65                                                                                  
    ##  Max.   : 0.65                                                                                  
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-1.74                                                                                    
    ##  1st Qu.: 0.01                                                                                    
    ##  Median : 0.26                                                                                    
    ##  Mean   : 0.00                                                                                    
    ##  3rd Qu.: 0.26                                                                                    
    ##  Max.   : 0.26                                                                                    
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-2.65                                      
    ##  1st Qu.:-0.65                                      
    ##  Median : 0.35                                      
    ##  Mean   : 0.00                                      
    ##  3rd Qu.: 0.35                                      
    ##  Max.   : 0.35                                      
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-3.11                                    
    ##  1st Qu.:-0.11                                    
    ##  Median :-0.11                                    
    ##  Mean   : 0.00                                    
    ##  3rd Qu.: 0.89                                    
    ##  Max.   : 0.89                                    
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-2.38                                                     
    ##  1st Qu.:-0.38                                                     
    ##  Median :-0.38                                                     
    ##  Mean   : 0.00                                                     
    ##  3rd Qu.: 0.62                                                     
    ##  Max.   : 0.62                                                     
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-3.61                                          
    ##  1st Qu.:-0.61                                          
    ##  Median : 0.39                                          
    ##  Mean   : 0.00                                          
    ##  3rd Qu.: 0.39                                          
    ##  Max.   : 0.39                                          
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-1.58                     
    ##  1st Qu.:-0.58                     
    ##  Median : 0.42                     
    ##  Mean   : 0.00                     
    ##  3rd Qu.: 0.42                     
    ##  Max.   : 0.42                     
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-1.55                                    
    ##  1st Qu.:-0.55                                    
    ##  Median : 0.45                                    
    ##  Mean   : 0.00                                    
    ##  3rd Qu.: 0.45                                    
    ##  Max.   : 0.45                                    
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-1.7                               
    ##  1st Qu.:-0.7                               
    ##  Median : 0.3                               
    ##  Mean   : 0.0                               
    ##  3rd Qu.: 0.3                               
    ##  Max.   : 0.3                               
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-3.25                                                                        
    ##  1st Qu.:-0.25                                                                        
    ##  Median :-0.25                                                                        
    ##  Mean   : 0.00                                                                        
    ##  3rd Qu.: 0.75                                                                        
    ##  Max.   : 0.75                                                                        
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-1.94                                                    
    ##  1st Qu.:-0.94                                                    
    ##  Median : 0.06                                                    
    ##  Mean   : 0.00                                                    
    ##  3rd Qu.: 1.06                                                    
    ##  Max.   : 1.06                                                    
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-2.59                            
    ##  1st Qu.:-0.59                            
    ##  Median : 0.41                            
    ##  Mean   : 0.00                            
    ##  3rd Qu.: 0.41                            
    ##  Max.   : 0.41                            
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-1.61                                                      
    ##  1st Qu.:-0.61                                                      
    ##  Median : 0.39                                                      
    ##  Mean   : 0.00                                                      
    ##  3rd Qu.: 0.39                                                      
    ##  Max.   : 0.39                                                      
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-1.55                                                                                                      
    ##  1st Qu.:-0.55                                                                                                      
    ##  Median : 0.45                                                                                                      
    ##  Mean   : 0.00                                                                                                      
    ##  3rd Qu.: 0.45                                                                                                      
    ##  Max.   : 0.45                                                                                                      
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-3.19                       
    ##  1st Qu.:-0.19                       
    ##  Median :-0.19                       
    ##  Mean   : 0.00                       
    ##  3rd Qu.: 0.81                       
    ##  Max.   : 0.81                       
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-3.08                             
    ##  1st Qu.:-0.08                             
    ##  Median :-0.08                             
    ##  Mean   : 0.00                             
    ##  3rd Qu.: 0.92                             
    ##  Max.   : 0.92                             
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-3.17                        Min.   :-2.6          
    ##  1st Qu.:-0.17                        1st Qu.:-0.6          
    ##  Median :-0.17                        Median : 0.4          
    ##  Mean   : 0.00                        Mean   : 0.0          
    ##  3rd Qu.: 0.83                        3rd Qu.: 0.4          
    ##  Max.   : 0.83                        Max.   : 0.4          
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-2.6                                      
    ##  1st Qu.:-0.6                                      
    ##  Median : 0.4                                      
    ##  Mean   : 0.0                                      
    ##  3rd Qu.: 0.4                                      
    ##  Max.   : 0.4                                      
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-2.54                                                                                                                                                                                                                                                                                
    ##  1st Qu.:-0.54                                                                                                                                                                                                                                                                                
    ##  Median : 0.46                                                                                                                                                                                                                                                                                
    ##  Mean   : 0.00                                                                                                                                                                                                                                                                                
    ##  3rd Qu.: 0.46                                                                                                                                                                                                                                                                                
    ##  Max.   : 0.46                                                                                                                                                                                                                                                                                
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-2.49                                                                                                                                                                   
    ##  1st Qu.:-0.49                                                                                                                                                                   
    ##  Median : 0.51                                                                                                                                                                   
    ##  Mean   : 0.00                                                                                                                                                                   
    ##  3rd Qu.: 0.51                                                                                                                                                                   
    ##  Max.   : 0.51                                                                                                                                                                   
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :-2.33                           
    ##  1st Qu.:-0.33                           
    ##  Median : 0.67                           
    ##  Mean   : 0.00                           
    ##  3rd Qu.: 0.67                           
    ##  Max.   : 0.67                           
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-1.62181                 Min.   :-2.095                           
    ##  1st Qu.:-0.25821                 1st Qu.:-0.595                           
    ##  Median : 0.01459                 Median :-0.095                           
    ##  Mean   : 0.00000                 Mean   : 0.000                           
    ##  3rd Qu.: 0.37819                 3rd Qu.: 0.405                           
    ##  Max.   : 0.46909                 Max.   : 0.905                           
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-1.2500                                  
    ##  1st Qu.:-0.3636                                  
    ##  Median : 0.1137                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.4773                                  
    ##  Max.   : 0.5682                                  
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-8.0109                  Min.   :-6.5822                  
    ##  1st Qu.:-0.6109                  1st Qu.:-0.5822                  
    ##  Median : 0.4891                  Median : 1.2178                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.9891                  3rd Qu.: 1.7178                  
    ##  Max.   : 1.9891                  Max.   : 3.4178                  
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-1.015                 Min.   :-62.392                 
    ##  1st Qu.:-1.015                 1st Qu.: -6.392                 
    ##  Median :-1.015                 Median :  4.008                 
    ##  Mean   : 0.000                 Mean   :  0.000                 
    ##  3rd Qu.: 0.235                 3rd Qu.:  9.208                 
    ##  Max.   : 3.985                 Max.   : 37.608                 
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-11.607                         Min.   :-6.5303                  
    ##  1st Qu.: -4.827                         1st Qu.:-2.5303                  
    ##  Median : -1.027                         Median :-0.5303                  
    ##  Mean   :  0.000                         Mean   : 0.0000                  
    ##  3rd Qu.:  3.273                         3rd Qu.: 2.4697                  
    ##  Max.   : 14.893                         Max.   : 5.4697                  
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-10.9357                      Min.   :-6.36742                       
    ##  1st Qu.: -3.0207                      1st Qu.:-1.36742                       
    ##  Median : -0.4357                      Median :-0.03742                       
    ##  Mean   :  0.0000                      Mean   : 0.00000                       
    ##  3rd Qu.:  3.5643                      3rd Qu.: 1.63258                       
    ##  Max.   :  8.0643                      Max.   : 6.30258                       
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-29.9592                               
    ##  1st Qu.:-12.3992                               
    ##  Median : -0.9092                               
    ##  Mean   :  0.0000                               
    ##  3rd Qu.:  8.9408                               
    ##  Max.   : 39.0308                               
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-1.898                               
    ##  1st Qu.: 0.102                               
    ##  Median : 0.102                               
    ##  Mean   : 0.000                               
    ##  3rd Qu.: 0.102                               
    ##  Max.   : 0.102                               
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-2.0163                                               
    ##  1st Qu.:-1.0163                                               
    ##  Median : 0.6837                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 0.8337                                               
    ##  Max.   : 0.8337                                               
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-1.7802                                                
    ##  1st Qu.: 0.2198                                                
    ##  Median : 0.2198                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.2198                                                
    ##  Max.   : 0.3698                                                
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-2.5747                                  
    ##  1st Qu.:-0.3247                                  
    ##  Median : 0.4253                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.5753                                  
    ##  Max.   : 0.5753                                  
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-3.404                       Min.   :-61.916         
    ##  1st Qu.:-3.404                       1st Qu.: -8.916         
    ##  Median : 1.596                       Median :  0.284         
    ##  Mean   : 0.000                       Mean   :  0.000         
    ##  3rd Qu.: 1.596                       3rd Qu.: 17.484         
    ##  Max.   : 1.596                       Max.   : 20.284         
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-36.5033       Min.   :-62.129        
    ##  1st Qu.:-10.1833       1st Qu.:-11.129        
    ##  Median :  0.3367       Median :  1.371        
    ##  Mean   :  0.0000       Mean   :  0.000        
    ##  3rd Qu.: 13.4967       3rd Qu.: 19.621        
    ##  Max.   : 27.9667       Max.   : 37.871        
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-15.4155      
    ##  1: 5                                       1st Qu.: -8.0055      
    ##                                             Median : -0.6055      
    ##                                             Mean   :  0.0000      
    ##                                             3rd Qu.:  6.8045      
    ##                                             Max.   : 36.4345      
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)   
    ##  Min.   :-17.05604            Min.   :-28.93814  
    ##  1st Qu.: -4.08604            1st Qu.: -7.93814  
    ##  Median :  0.05396            Median :  0.06186  
    ##  Mean   :  0.00000            Mean   :  0.00000  
    ##  3rd Qu.:  4.78396            3rd Qu.:  8.06186  
    ##  Max.   : 10.55396            Max.   : 22.06186  
    ##                               NA's   :4          
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-49.65                         A:23  
    ##  1st Qu.:-11.58                         B:25  
    ##  Median :  1.57                         C:22  
    ##  Mean   :  0.00                         D:25  
    ##  3rd Qu.: 11.71                         E: 6  
    ##  Max.   : 30.60                               
    ## 

# Standardize Data Transform

``` r
# BEFORE
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.05                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :3.00                     Min.   :3.00                        
    ##  1st Qu.:4.00                     1st Qu.:4.00                        
    ##  Median :5.00                     Median :5.00                        
    ##  Mean   :4.49                     Mean   :4.68                        
    ##  3rd Qu.:5.00                     3rd Qu.:5.00                        
    ##  Max.   :5.00                     Max.   :5.00                        
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :3.00                                                                                   
    ##  1st Qu.:4.00                                                                                   
    ##  Median :4.00                                                                                   
    ##  Mean   :4.35                                                                                   
    ##  3rd Qu.:5.00                                                                                   
    ##  Max.   :5.00                                                                                   
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :3.00                                                                                     
    ##  1st Qu.:4.75                                                                                     
    ##  Median :5.00                                                                                     
    ##  Mean   :4.74                                                                                     
    ##  3rd Qu.:5.00                                                                                     
    ##  Max.   :5.00                                                                                     
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :2.00                                       
    ##  1st Qu.:4.00                                       
    ##  Median :5.00                                       
    ##  Mean   :4.65                                       
    ##  3rd Qu.:5.00                                       
    ##  Max.   :5.00                                       
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :1.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :4.00                                     
    ##  Mean   :4.11                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :2.00                                                      
    ##  1st Qu.:4.00                                                      
    ##  Median :4.00                                                      
    ##  Mean   :4.38                                                      
    ##  3rd Qu.:5.00                                                      
    ##  Max.   :5.00                                                      
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :1.00                                           
    ##  1st Qu.:4.00                                           
    ##  Median :5.00                                           
    ##  Mean   :4.61                                           
    ##  3rd Qu.:5.00                                           
    ##  Max.   :5.00                                           
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :3.00                      
    ##  1st Qu.:4.00                      
    ##  Median :5.00                      
    ##  Mean   :4.58                      
    ##  3rd Qu.:5.00                      
    ##  Max.   :5.00                      
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :3.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :5.00                                     
    ##  Mean   :4.55                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :3.0                                
    ##  1st Qu.:4.0                                
    ##  Median :5.0                                
    ##  Mean   :4.7                                
    ##  3rd Qu.:5.0                                
    ##  Max.   :5.0                                
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :1.00                                                                         
    ##  1st Qu.:4.00                                                                         
    ##  Median :4.00                                                                         
    ##  Mean   :4.25                                                                         
    ##  3rd Qu.:5.00                                                                         
    ##  Max.   :5.00                                                                         
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :2.00                                                     
    ##  1st Qu.:3.00                                                     
    ##  Median :4.00                                                     
    ##  Mean   :3.94                                                     
    ##  3rd Qu.:5.00                                                     
    ##  Max.   :5.00                                                     
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :2.00                             
    ##  1st Qu.:4.00                             
    ##  Median :5.00                             
    ##  Mean   :4.59                             
    ##  3rd Qu.:5.00                             
    ##  Max.   :5.00                             
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :3.00                                                       
    ##  1st Qu.:4.00                                                       
    ##  Median :5.00                                                       
    ##  Mean   :4.61                                                       
    ##  3rd Qu.:5.00                                                       
    ##  Max.   :5.00                                                       
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :3.00                                                                                                       
    ##  1st Qu.:4.00                                                                                                       
    ##  Median :5.00                                                                                                       
    ##  Mean   :4.55                                                                                                       
    ##  3rd Qu.:5.00                                                                                                       
    ##  Max.   :5.00                                                                                                       
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :1.00                        
    ##  1st Qu.:4.00                        
    ##  Median :4.00                        
    ##  Mean   :4.19                        
    ##  3rd Qu.:5.00                        
    ##  Max.   :5.00                        
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :1.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.08                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :1.00                         Min.   :2.0           
    ##  1st Qu.:4.00                         1st Qu.:4.0           
    ##  Median :4.00                         Median :5.0           
    ##  Mean   :4.17                         Mean   :4.6           
    ##  3rd Qu.:5.00                         3rd Qu.:5.0           
    ##  Max.   :5.00                         Max.   :5.0           
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :2.0                                       
    ##  1st Qu.:4.0                                       
    ##  Median :5.0                                       
    ##  Mean   :4.6                                       
    ##  3rd Qu.:5.0                                       
    ##  Max.   :5.0                                       
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :2.00                                                                                                                                                                                                                                                                                 
    ##  1st Qu.:4.00                                                                                                                                                                                                                                                                                 
    ##  Median :5.00                                                                                                                                                                                                                                                                                 
    ##  Mean   :4.54                                                                                                                                                                                                                                                                                 
    ##  3rd Qu.:5.00                                                                                                                                                                                                                                                                                 
    ##  Max.   :5.00                                                                                                                                                                                                                                                                                 
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :2.00                                                                                                                                                                    
    ##  1st Qu.:4.00                                                                                                                                                                    
    ##  Median :5.00                                                                                                                                                                    
    ##  Mean   :4.49                                                                                                                                                                    
    ##  3rd Qu.:5.00                                                                                                                                                                    
    ##  Max.   :5.00                                                                                                                                                                    
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :2.00                            
    ##  1st Qu.:4.00                            
    ##  Median :5.00                            
    ##  Mean   :4.33                            
    ##  3rd Qu.:5.00                            
    ##  Max.   :5.00                            
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :2.909                    Min.   :2.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.531                    Mean   :4.095                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :3.182                                    
    ##  1st Qu.:4.068                                    
    ##  Median :4.545                                    
    ##  Mean   :4.432                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.015                  Mean   : 62.39                  
    ##  3rd Qu.:1.250                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 3.00                    
    ##  1st Qu.:11.53                           1st Qu.: 7.00                    
    ##  Median :15.33                           Median : 9.00                    
    ##  Mean   :16.36                           Mean   : 9.53                    
    ##  3rd Qu.:19.63                           3rd Qu.:12.00                    
    ##  Max.   :31.25                           Max.   :15.00                    
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 3.00                         Min.   : 0.000                         
    ##  1st Qu.:10.91                         1st Qu.: 5.000                         
    ##  Median :13.50                         Median : 6.330                         
    ##  Mean   :13.94                         Mean   : 6.367                         
    ##  3rd Qu.:17.50                         3rd Qu.: 8.000                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :3.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.898                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :2.150                                                 
    ##  1st Qu.:3.150                                                 
    ##  Median :4.850                                                 
    ##  Mean   :4.166                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :2.85                                                   
    ##  1st Qu.:4.85                                                   
    ##  Median :4.85                                                   
    ##  Mean   :4.63                                                   
    ##  3rd Qu.:4.85                                                   
    ##  Max.   :5.00                                                   
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :1.850                                    
    ##  1st Qu.:4.100                                    
    ##  Median :4.850                                    
    ##  Mean   :4.425                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :32.89          Min.   :  0.00         
    ##  1st Qu.:59.21          1st Qu.: 51.00         
    ##  Median :69.73          Median : 63.50         
    ##  Mean   :69.39          Mean   : 62.13         
    ##  3rd Qu.:82.89          3rd Qu.: 81.75         
    ##  Max.   :97.36          Max.   :100.00         
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 5.00   
    ##  1st Qu.:20.44                1st Qu.:26.00   
    ##  Median :24.58                Median :34.00   
    ##  Mean   :24.53                Mean   :33.94   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72                                
    ## 

``` r
model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
```

    ## Created from 51 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - centered (49)
    ##   - ignored (51)
    ##   - scaled (49)

``` r
student_performance_dataset_standardize_transform <- predict(model_of_the_transform, # nolint
                                                student_performance_dataset)
# AFTER
summary(student_performance_dataset_standardize_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1  paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :-0.9716   0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:-0.9716   1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median :-0.0237   NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 0.0000               
    ##                       NA's: 1   NA's: 1    3rd Qu.: 0.4502               
    ##                                            Max.   : 3.7678               
    ##                                            NA's   :1                     
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :-2.5063                  Min.   :-3.4293                     
    ##  1st Qu.:-0.8242                  1st Qu.:-1.3880                     
    ##  Median : 0.8579                  Median : 0.6532                     
    ##  Mean   : 0.0000                  Mean   : 0.0000                     
    ##  3rd Qu.: 0.8579                  3rd Qu.: 0.6532                     
    ##  Max.   : 0.8579                  Max.   : 0.6532                     
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :-2.0544                                                                                
    ##  1st Qu.:-0.5326                                                                                
    ##  Median :-0.5326                                                                                
    ##  Mean   : 0.0000                                                                                
    ##  3rd Qu.: 0.9892                                                                                
    ##  Max.   : 0.9892                                                                                
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :-3.75655                                                                                 
    ##  1st Qu.: 0.02159                                                                                 
    ##  Median : 0.56132                                                                                 
    ##  Mean   : 0.00000                                                                                 
    ##  3rd Qu.: 0.56132                                                                                 
    ##  Max.   : 0.56132                                                                                 
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :-4.6074                                    
    ##  1st Qu.:-1.1301                                    
    ##  Median : 0.6085                                    
    ##  Mean   : 0.0000                                    
    ##  3rd Qu.: 0.6085                                    
    ##  Max.   : 0.6085                                    
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :-3.5544                                  
    ##  1st Qu.:-0.1257                                  
    ##  Median :-0.1257                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 1.0172                                  
    ##  Max.   : 1.0172                                  
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :-3.4338                                                   
    ##  1st Qu.:-0.5483                                                   
    ##  Median :-0.5483                                                   
    ##  Mean   : 0.0000                                                   
    ##  3rd Qu.: 0.8945                                                   
    ##  Max.   : 0.8945                                                   
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :-5.5563                                        
    ##  1st Qu.:-0.9389                                        
    ##  Median : 0.6003                                        
    ##  Mean   : 0.0000                                        
    ##  3rd Qu.: 0.6003                                        
    ##  Max.   : 0.6003                                        
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :-2.8531                   
    ##  1st Qu.:-1.0474                   
    ##  Median : 0.7584                   
    ##  Mean   : 0.0000                   
    ##  3rd Qu.: 0.7584                   
    ##  Max.   : 0.7584                   
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :-2.4775                                  
    ##  1st Qu.:-0.8791                                  
    ##  Median : 0.7193                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.7193                                  
    ##  Max.   : 0.7193                                  
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :-3.2553                            
    ##  1st Qu.:-1.3404                            
    ##  Median : 0.5745                            
    ##  Mean   : 0.0000                            
    ##  3rd Qu.: 0.5745                            
    ##  Max.   : 0.5745                            
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :-4.1489                                                                      
    ##  1st Qu.:-0.3191                                                                      
    ##  Median :-0.3191                                                                      
    ##  Mean   : 0.0000                                                                      
    ##  3rd Qu.: 0.9574                                                                      
    ##  Max.   : 0.9574                                                                      
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :-2.24938                                                 
    ##  1st Qu.:-1.08990                                                 
    ##  Median : 0.06957                                                 
    ##  Mean   : 0.00000                                                 
    ##  3rd Qu.: 1.22904                                                 
    ##  Max.   : 1.22904                                                 
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :-4.1701                          
    ##  1st Qu.:-0.9499                          
    ##  Median : 0.6601                          
    ##  Mean   : 0.0000                          
    ##  3rd Qu.: 0.6601                          
    ##  Max.   : 0.6601                          
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :-2.6777                                                    
    ##  1st Qu.:-1.0145                                                    
    ##  Median : 0.6486                                                    
    ##  Mean   : 0.0000                                                    
    ##  3rd Qu.: 0.6486                                                    
    ##  Max.   : 0.6486                                                    
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :-2.5440                                                                                                    
    ##  1st Qu.:-0.9027                                                                                                    
    ##  Median : 0.7386                                                                                                    
    ##  Mean   : 0.0000                                                                                                    
    ##  3rd Qu.: 0.7386                                                                                                    
    ##  Max.   : 0.7386                                                                                                    
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :-3.6080                     
    ##  1st Qu.:-0.2149                     
    ##  Median :-0.2149                     
    ##  Mean   : 0.0000                     
    ##  3rd Qu.: 0.9161                     
    ##  Max.   : 0.9161                     
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :-3.10583                          
    ##  1st Qu.:-0.08067                          
    ##  Median :-0.08067                          
    ##  Mean   : 0.00000                          
    ##  3rd Qu.: 0.92772                          
    ##  Max.   : 0.92772                          
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :-3.2864                      Min.   :-3.5875       
    ##  1st Qu.:-0.1762                      1st Qu.:-0.8279       
    ##  Median :-0.1762                      Median : 0.5519       
    ##  Mean   : 0.0000                      Mean   : 0.0000       
    ##  3rd Qu.: 0.8605                      3rd Qu.: 0.5519       
    ##  Max.   : 0.8605                      Max.   : 0.5519       
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :-4.0904                                   
    ##  1st Qu.:-0.9439                                   
    ##  Median : 0.6293                                   
    ##  Mean   : 0.0000                                   
    ##  3rd Qu.: 0.6293                                   
    ##  Max.   : 0.6293                                   
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :-3.8612                                                                                                                                                                                                                                                                              
    ##  1st Qu.:-0.8209                                                                                                                                                                                                                                                                              
    ##  Median : 0.6993                                                                                                                                                                                                                                                                              
    ##  Mean   : 0.0000                                                                                                                                                                                                                                                                              
    ##  3rd Qu.: 0.6993                                                                                                                                                                                                                                                                              
    ##  Max.   : 0.6993                                                                                                                                                                                                                                                                              
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :-3.6142                                                                                                                                                                 
    ##  1st Qu.:-0.7112                                                                                                                                                                 
    ##  Median : 0.7403                                                                                                                                                                 
    ##  Mean   : 0.0000                                                                                                                                                                 
    ##  3rd Qu.: 0.7403                                                                                                                                                                 
    ##  Max.   : 0.7403                                                                                                                                                                 
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :-2.7301                         
    ##  1st Qu.:-0.3867                         
    ##  Median : 0.7850                         
    ##  Mean   : 0.0000                         
    ##  3rd Qu.: 0.7850                         
    ##  Max.   : 0.7850                         
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :-4.05150                 Min.   :-2.9674                          
    ##  1st Qu.:-0.64504                 1st Qu.:-0.8428                          
    ##  Median : 0.03645                 Median :-0.1346                          
    ##  Mean   : 0.00000                 Mean   : 0.0000                          
    ##  3rd Qu.: 0.94477                 3rd Qu.: 0.5736                          
    ##  Max.   : 1.17185                 Max.   : 1.2818                          
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :-2.4737                                  
    ##  1st Qu.:-0.7196                                  
    ##  Median : 0.2250                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.9445                                  
    ##  Max.   : 1.1244                                  
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :-3.8114                  Min.   :-2.3600                  
    ##  1st Qu.:-0.2907                  1st Qu.:-0.2087                  
    ##  Median : 0.2327                  Median : 0.4366                  
    ##  Mean   : 0.0000                  Mean   : 0.0000                  
    ##  3rd Qu.: 0.4706                  3rd Qu.: 0.6159                  
    ##  Max.   : 0.9464                  Max.   : 1.2255                  
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :-0.5683                Min.   :-3.0961                 
    ##  1st Qu.:-0.5683                1st Qu.:-0.3172                 
    ##  Median :-0.5683                Median : 0.1989                 
    ##  Mean   : 0.0000                Mean   : 0.0000                 
    ##  3rd Qu.: 0.1316                3rd Qu.: 0.4569                 
    ##  Max.   : 2.2310                Max.   : 1.8662                 
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :-1.7842                         Min.   :-2.1031                  
    ##  1st Qu.:-0.7420                         1st Qu.:-0.8149                  
    ##  Median :-0.1578                         Median :-0.1708                  
    ##  Mean   : 0.0000                         Mean   : 0.0000                  
    ##  3rd Qu.: 0.5032                         3rd Qu.: 0.7954                  
    ##  Max.   : 2.2894                         Max.   : 1.7615                  
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :-2.46748                      Min.   :-3.03179                       
    ##  1st Qu.:-0.68157                      1st Qu.:-0.65108                       
    ##  Median :-0.09831                      Median :-0.01782                       
    ##  Mean   : 0.00000                      Mean   : 0.00000                       
    ##  3rd Qu.: 0.80424                      3rd Qu.: 0.77734                       
    ##  Max.   : 1.81960                      Max.   : 3.00092                       
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :-1.81638                               
    ##  1st Qu.:-0.75175                               
    ##  Median :-0.05512                               
    ##  Mean   : 0.00000                               
    ##  3rd Qu.: 0.54207                               
    ##  Max.   : 2.36638                               
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :-4.8297                              
    ##  1st Qu.: 0.2597                              
    ##  Median : 0.2597                              
    ##  Mean   : 0.0000                              
    ##  3rd Qu.: 0.2597                              
    ##  Max.   : 0.2597                              
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :-1.9485                                               
    ##  1st Qu.:-0.9821                                               
    ##  Median : 0.6607                                               
    ##  Mean   : 0.0000                                               
    ##  3rd Qu.: 0.8056                                               
    ##  Max.   : 0.8056                                               
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :-2.7794                                                
    ##  1st Qu.: 0.3431                                                
    ##  Median : 0.3431                                                
    ##  Mean   : 0.0000                                                
    ##  3rd Qu.: 0.3431                                                
    ##  Max.   : 0.5773                                                
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :-2.8586                                  
    ##  1st Qu.:-0.3605                                  
    ##  Median : 0.4722                                  
    ##  Mean   : 0.0000                                  
    ##  3rd Qu.: 0.6387                                  
    ##  Max.   : 0.6387                                  
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :-1.4592                      Min.   :-3.20757        
    ##  1st Qu.:-1.4592                      1st Qu.:-0.46190        
    ##  Median : 0.6842                      Median : 0.01471        
    ##  Mean   : 0.0000                      Mean   : 0.00000        
    ##  3rd Qu.: 0.6842                      3rd Qu.: 0.90576        
    ##  Max.   : 0.6842                      Max.   : 1.05081        
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :-2.41349       Min.   :-2.51821       
    ##  1st Qu.:-0.67329       1st Qu.:-0.45107       
    ##  Median : 0.02226       Median : 0.05559       
    ##  Mean   : 0.00000       Mean   : 0.00000       
    ##  3rd Qu.: 0.89236       3rd Qu.: 0.79530       
    ##  Max.   : 1.84908       Max.   : 1.53501       
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :-1.69613      
    ##  1: 5                                       1st Qu.:-0.88083      
    ##                                             Median :-0.06663      
    ##                                             Mean   : 0.00000      
    ##                                             3rd Qu.: 0.74867      
    ##                                             Max.   : 4.00877      
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)   
    ##  Min.   :-2.74036             Min.   :-2.570415  
    ##  1st Qu.:-0.65650             1st Qu.:-0.705101  
    ##  Median : 0.00867             Median : 0.005494  
    ##  Mean   : 0.00000             Mean   : 0.000000  
    ##  3rd Qu.: 0.76863             3rd Qu.: 0.716090  
    ##  Max.   : 1.69569             Max.   : 1.959633  
    ##                               NA's   :4          
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :-3.15733                       A:23  
    ##  1st Qu.:-0.73640                       B:25  
    ##  Median : 0.09983                       C:22  
    ##  Mean   : 0.00000                       D:25  
    ##  3rd Qu.: 0.74465                       E: 6  
    ##  Max.   : 1.94590                             
    ## 

## Normalize Data Transform

``` r
#### The Normalize Transform on the Student Performance Dataset ----
summary(student_performance_dataset)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   : 0.00    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.: 0.00    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median : 2.00    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   : 2.05                
    ##                       NA's: 1   NA's: 1    3rd Qu.: 3.00                
    ##                                            Max.   :10.00                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :3.00                     Min.   :3.00                        
    ##  1st Qu.:4.00                     1st Qu.:4.00                        
    ##  Median :5.00                     Median :5.00                        
    ##  Mean   :4.49                     Mean   :4.68                        
    ##  3rd Qu.:5.00                     3rd Qu.:5.00                        
    ##  Max.   :5.00                     Max.   :5.00                        
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :3.00                                                                                   
    ##  1st Qu.:4.00                                                                                   
    ##  Median :4.00                                                                                   
    ##  Mean   :4.35                                                                                   
    ##  3rd Qu.:5.00                                                                                   
    ##  Max.   :5.00                                                                                   
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :3.00                                                                                     
    ##  1st Qu.:4.75                                                                                     
    ##  Median :5.00                                                                                     
    ##  Mean   :4.74                                                                                     
    ##  3rd Qu.:5.00                                                                                     
    ##  Max.   :5.00                                                                                     
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :2.00                                       
    ##  1st Qu.:4.00                                       
    ##  Median :5.00                                       
    ##  Mean   :4.65                                       
    ##  3rd Qu.:5.00                                       
    ##  Max.   :5.00                                       
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :1.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :4.00                                     
    ##  Mean   :4.11                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :2.00                                                      
    ##  1st Qu.:4.00                                                      
    ##  Median :4.00                                                      
    ##  Mean   :4.38                                                      
    ##  3rd Qu.:5.00                                                      
    ##  Max.   :5.00                                                      
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :1.00                                           
    ##  1st Qu.:4.00                                           
    ##  Median :5.00                                           
    ##  Mean   :4.61                                           
    ##  3rd Qu.:5.00                                           
    ##  Max.   :5.00                                           
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :3.00                      
    ##  1st Qu.:4.00                      
    ##  Median :5.00                      
    ##  Mean   :4.58                      
    ##  3rd Qu.:5.00                      
    ##  Max.   :5.00                      
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :3.00                                     
    ##  1st Qu.:4.00                                     
    ##  Median :5.00                                     
    ##  Mean   :4.55                                     
    ##  3rd Qu.:5.00                                     
    ##  Max.   :5.00                                     
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :3.0                                
    ##  1st Qu.:4.0                                
    ##  Median :5.0                                
    ##  Mean   :4.7                                
    ##  3rd Qu.:5.0                                
    ##  Max.   :5.0                                
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :1.00                                                                         
    ##  1st Qu.:4.00                                                                         
    ##  Median :4.00                                                                         
    ##  Mean   :4.25                                                                         
    ##  3rd Qu.:5.00                                                                         
    ##  Max.   :5.00                                                                         
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :2.00                                                     
    ##  1st Qu.:3.00                                                     
    ##  Median :4.00                                                     
    ##  Mean   :3.94                                                     
    ##  3rd Qu.:5.00                                                     
    ##  Max.   :5.00                                                     
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :2.00                             
    ##  1st Qu.:4.00                             
    ##  Median :5.00                             
    ##  Mean   :4.59                             
    ##  3rd Qu.:5.00                             
    ##  Max.   :5.00                             
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :3.00                                                       
    ##  1st Qu.:4.00                                                       
    ##  Median :5.00                                                       
    ##  Mean   :4.61                                                       
    ##  3rd Qu.:5.00                                                       
    ##  Max.   :5.00                                                       
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :3.00                                                                                                       
    ##  1st Qu.:4.00                                                                                                       
    ##  Median :5.00                                                                                                       
    ##  Mean   :4.55                                                                                                       
    ##  3rd Qu.:5.00                                                                                                       
    ##  Max.   :5.00                                                                                                       
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :1.00                        
    ##  1st Qu.:4.00                        
    ##  Median :4.00                        
    ##  Mean   :4.19                        
    ##  3rd Qu.:5.00                        
    ##  Max.   :5.00                        
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :1.00                              
    ##  1st Qu.:4.00                              
    ##  Median :4.00                              
    ##  Mean   :4.08                              
    ##  3rd Qu.:5.00                              
    ##  Max.   :5.00                              
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :1.00                         Min.   :2.0           
    ##  1st Qu.:4.00                         1st Qu.:4.0           
    ##  Median :4.00                         Median :5.0           
    ##  Mean   :4.17                         Mean   :4.6           
    ##  3rd Qu.:5.00                         3rd Qu.:5.0           
    ##  Max.   :5.00                         Max.   :5.0           
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :2.0                                       
    ##  1st Qu.:4.0                                       
    ##  Median :5.0                                       
    ##  Mean   :4.6                                       
    ##  3rd Qu.:5.0                                       
    ##  Max.   :5.0                                       
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :2.00                                                                                                                                                                                                                                                                                 
    ##  1st Qu.:4.00                                                                                                                                                                                                                                                                                 
    ##  Median :5.00                                                                                                                                                                                                                                                                                 
    ##  Mean   :4.54                                                                                                                                                                                                                                                                                 
    ##  3rd Qu.:5.00                                                                                                                                                                                                                                                                                 
    ##  Max.   :5.00                                                                                                                                                                                                                                                                                 
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :2.00                                                                                                                                                                    
    ##  1st Qu.:4.00                                                                                                                                                                    
    ##  Median :5.00                                                                                                                                                                    
    ##  Mean   :4.49                                                                                                                                                                    
    ##  3rd Qu.:5.00                                                                                                                                                                    
    ##  Max.   :5.00                                                                                                                                                                    
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :2.00                            
    ##  1st Qu.:4.00                            
    ##  Median :5.00                            
    ##  Mean   :4.33                            
    ##  3rd Qu.:5.00                            
    ##  Max.   :5.00                            
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :2.909                    Min.   :2.000                            
    ##  1st Qu.:4.273                    1st Qu.:3.500                            
    ##  Median :4.545                    Median :4.000                            
    ##  Mean   :4.531                    Mean   :4.095                            
    ##  3rd Qu.:4.909                    3rd Qu.:4.500                            
    ##  Max.   :5.000                    Max.   :5.000                            
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :3.182                                    
    ##  1st Qu.:4.068                                    
    ##  Median :4.545                                    
    ##  Mean   :4.432                                    
    ##  3rd Qu.:4.909                                    
    ##  Max.   :5.000                                    
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   : 0.000                   Min.   : 0.000                   
    ##  1st Qu.: 7.400                   1st Qu.: 6.000                   
    ##  Median : 8.500                   Median : 7.800                   
    ##  Mean   : 8.011                   Mean   : 6.582                   
    ##  3rd Qu.: 9.000                   3rd Qu.: 8.300                   
    ##  Max.   :10.000                   Max.   :10.000                   
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :  0.00                  
    ##  1st Qu.:0.000                  1st Qu.: 56.00                  
    ##  Median :0.000                  Median : 66.40                  
    ##  Mean   :1.015                  Mean   : 62.39                  
    ##  3rd Qu.:1.250                  3rd Qu.: 71.60                  
    ##  Max.   :5.000                  Max.   :100.00                  
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   : 4.75                           Min.   : 3.00                    
    ##  1st Qu.:11.53                           1st Qu.: 7.00                    
    ##  Median :15.33                           Median : 9.00                    
    ##  Mean   :16.36                           Mean   : 9.53                    
    ##  3rd Qu.:19.63                           3rd Qu.:12.00                    
    ##  Max.   :31.25                           Max.   :15.00                    
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   : 3.00                         Min.   : 0.000                         
    ##  1st Qu.:10.91                         1st Qu.: 5.000                         
    ##  Median :13.50                         Median : 6.330                         
    ##  Mean   :13.94                         Mean   : 6.367                         
    ##  3rd Qu.:17.50                         3rd Qu.: 8.000                         
    ##  Max.   :22.00                         Max.   :12.670                         
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :26.26                                  
    ##  1st Qu.:43.82                                  
    ##  Median :55.31                                  
    ##  Mean   :56.22                                  
    ##  3rd Qu.:65.16                                  
    ##  Max.   :95.25                                  
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :3.000                                
    ##  1st Qu.:5.000                                
    ##  Median :5.000                                
    ##  Mean   :4.898                                
    ##  3rd Qu.:5.000                                
    ##  Max.   :5.000                                
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :2.150                                                 
    ##  1st Qu.:3.150                                                 
    ##  Median :4.850                                                 
    ##  Mean   :4.166                                                 
    ##  3rd Qu.:5.000                                                 
    ##  Max.   :5.000                                                 
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :2.85                                                   
    ##  1st Qu.:4.85                                                   
    ##  Median :4.85                                                   
    ##  Mean   :4.63                                                   
    ##  3rd Qu.:4.85                                                   
    ##  Max.   :5.00                                                   
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :1.850                                    
    ##  1st Qu.:4.100                                    
    ##  Median :4.850                                    
    ##  Mean   :4.425                                    
    ##  3rd Qu.:5.000                                    
    ##  Max.   :5.000                                    
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.000                        Min.   : 17.80          
    ##  1st Qu.:0.000                        1st Qu.: 70.80          
    ##  Median :5.000                        Median : 80.00          
    ##  Mean   :3.404                        Mean   : 79.72          
    ##  3rd Qu.:5.000                        3rd Qu.: 97.20          
    ##  Max.   :5.000                        Max.   :100.00          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :32.89          Min.   :  0.00         
    ##  1st Qu.:59.21          1st Qu.: 51.00         
    ##  Median :69.73          Median : 63.50         
    ##  Mean   :69.39          Mean   : 62.13         
    ##  3rd Qu.:82.89          3rd Qu.: 81.75         
    ##  Max.   :97.36          Max.   :100.00         
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   : 0.00         
    ##  1: 5                                       1st Qu.: 7.41         
    ##                                             Median :14.81         
    ##                                             Mean   :15.42         
    ##                                             3rd Qu.:22.22         
    ##                                             Max.   :51.85         
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   : 7.47                Min.   : 5.00   
    ##  1st Qu.:20.44                1st Qu.:26.00   
    ##  Median :24.58                Median :34.00   
    ##  Mean   :24.53                Mean   :33.94   
    ##  3rd Qu.:29.31                3rd Qu.:42.00   
    ##  Max.   :35.08                Max.   :56.00   
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   : 7.47                          A:23  
    ##  1st Qu.:45.54                          B:25  
    ##  Median :58.69                          C:22  
    ##  Mean   :57.12                          D:25  
    ##  3rd Qu.:68.83                          E: 6  
    ##  Max.   :87.72                                
    ## 

``` r
model_of_the_transform <- preProcess(student_performance_dataset, method = c("range"))
print(model_of_the_transform)
```

    ## Created from 51 samples and 100 variables
    ## 
    ## Pre-processing:
    ##   - ignored (51)
    ##   - re-scaling to [0, 1] (49)

``` r
student_performance_dataset_normalize_transform <- predict(model_of_the_transform, # nolint
                                              student_performance_dataset)
summary(student_performance_dataset_normalize_transform)
```

    ##  class_group gender      YOB             regret_choosing_bi drop_bi_now
    ##  A:23        1:58   Min.   :1998-01-01   1: 2               1: 2       
    ##  B:37        0:43   1st Qu.:2000-01-01   0:99               0:99       
    ##  C:41               Median :2001-01-01                                 
    ##                     Mean   :2000-11-25                                 
    ##                     3rd Qu.:2002-01-01                                 
    ##                     Max.   :2003-01-01                                 
    ##                                                                        
    ##  motivator read_content_before_lecture anticipate_test_questions
    ##  1:76      1:11                        1: 5                     
    ##  0:25      2:25                        2: 6                     
    ##            3:47                        3:31                     
    ##            4:14                        4:43                     
    ##            5: 4                        5:16                     
    ##                                                                 
    ##                                                                 
    ##  answer_rhetorical_questions find_terms_I_do_not_know
    ##  1: 3                        1: 6                    
    ##  2:15                        2: 2                    
    ##  3:32                        3:30                    
    ##  4:38                        4:37                    
    ##  5:13                        5:26                    
    ##                                                      
    ##                                                      
    ##  copy_new_terms_in_reading_notebook take_quizzes_and_use_results
    ##  1: 5                               1: 4                        
    ##  2:10                               2: 5                        
    ##  3:24                               3:22                        
    ##  4:37                               4:32                        
    ##  5:25                               5:38                        
    ##                                                                 
    ##                                                                 
    ##  reorganise_course_outline write_down_important_points space_out_revision
    ##  1: 7                      1: 4                        1: 8              
    ##  2:16                      2: 8                        2:17              
    ##  3:28                      3:20                        3:34              
    ##  4:32                      4:38                        4:28              
    ##  5:18                      5:31                        5:14              
    ##                                                                          
    ##                                                                          
    ##  studying_in_study_group schedule_appointments goal_oriented spaced_repetition
    ##  1:34                    1:42                  1:20          1:12             
    ##  2:21                    2:35                  0:81          2:31             
    ##  3:21                    3:16                                3:48             
    ##  4:16                    4: 5                                4:10             
    ##  5: 9                    5: 3                                                 
    ##                                                                               
    ##                                                                               
    ##  testing_and_active_recall interleaving categorizing retrospective_timetable
    ##  1: 2                      1:14         1: 6         1:17                   
    ##  2:17                      2:51         2:28         2:36                   
    ##  3:55                      3:32         3:56         3:38                   
    ##  4:27                      4: 4         4:11         4:10                   
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  cornell_notes sq3r   commute   study_time repeats_since_Y1 paid_tuition
    ##  1:19          1:18   1   :16   1   :45    Min.   :0.000    0   :89     
    ##  2:26          2:28   2   :23   2   :39    1st Qu.:0.000    1   :11     
    ##  3:38          3:30   3   :33   3   :12    Median :0.200    NA's: 1     
    ##  4:18          4:25   4   :28   4   : 4    Mean   :0.205                
    ##                       NA's: 1   NA's: 1    3rd Qu.:0.300                
    ##                                            Max.   :1.000                
    ##                                            NA's   :1                    
    ##  free_tuition extra_curricular sports_extra_curricular exercise_per_week
    ##  0   :73      0   :47          0   :64                 0   :23          
    ##  1   :27      1   :53          1   :36                 1   :49          
    ##  NA's: 1      NA's: 1          NA's: 1                 2   :23          
    ##                                                        3   : 5          
    ##                                                        NA's: 1          
    ##                                                                         
    ##                                                                         
    ##  meditate    pray    internet   laptop    family_relationships friendships
    ##  0   :49   0   : 8   0   :13   0   :  0   1   : 0              1   : 0    
    ##  1   :35   1   :24   1   :87   1   :100   2   : 2              2   : 3    
    ##  2   : 7   2   :19   NA's: 1   NA's:  1   3   :18              3   :17    
    ##  3   : 9   3   :49                        4   :39              4   :56    
    ##  NA's: 1   NA's: 1                        5   :41              5   :24    
    ##                                           NA's: 1              NA's: 1    
    ##                                                                           
    ##  romantic_relationships spiritual_wellnes financial_wellness  health  
    ##  0   :56                1   : 1           1   :10            1   : 2  
    ##  1   : 0                2   : 8           2   :18            2   : 3  
    ##  2   : 6                3   :37           3   :41            3   :22  
    ##  3   :27                4   :33           4   :21            4   :35  
    ##  4   :11                5   :21           5   :10            5   :38  
    ##  NA's: 1                NA's: 1           NA's: 1            NA's: 1  
    ##                                                                       
    ##  day_out   night_out alcohol_or_narcotics  mentor   mentor_meetings
    ##  0   :27   0   :55   0   :68              0   :59   0   :53        
    ##  1   :67   1   :41   1   :30              1   :41   1   :29        
    ##  2   : 5   2   : 2   2   : 1              NA's: 1   2   :15        
    ##  3   : 1   3   : 2   3   : 1                        3   : 3        
    ##  NA's: 1   NA's: 1   NA's: 1                        NA's: 1        
    ##                                                                    
    ##                                                                    
    ##  A - 1. I am enjoying the subject A - 2. Classes start and end on time
    ##  Min.   :0.000                    Min.   :0.00                        
    ##  1st Qu.:0.500                    1st Qu.:0.50                        
    ##  Median :1.000                    Median :1.00                        
    ##  Mean   :0.745                    Mean   :0.84                        
    ##  3rd Qu.:1.000                    3rd Qu.:1.00                        
    ##  Max.   :1.000                    Max.   :1.00                        
    ##  NA's   :1                        NA's   :1                           
    ##  A - 3. The learning environment is participative, involves learning by doing and is group-based
    ##  Min.   :0.000                                                                                  
    ##  1st Qu.:0.500                                                                                  
    ##  Median :0.500                                                                                  
    ##  Mean   :0.675                                                                                  
    ##  3rd Qu.:1.000                                                                                  
    ##  Max.   :1.000                                                                                  
    ##  NA's   :1                                                                                      
    ##  A - 4. The subject content is delivered according to the course outline and meets my expectations
    ##  Min.   :0.000                                                                                    
    ##  1st Qu.:0.875                                                                                    
    ##  Median :1.000                                                                                    
    ##  Mean   :0.870                                                                                    
    ##  3rd Qu.:1.000                                                                                    
    ##  Max.   :1.000                                                                                    
    ##  NA's   :1                                                                                        
    ##  A - 5. The topics are clear and logically developed
    ##  Min.   :0.0000                                     
    ##  1st Qu.:0.6667                                     
    ##  Median :1.0000                                     
    ##  Mean   :0.8833                                     
    ##  3rd Qu.:1.0000                                     
    ##  Max.   :1.0000                                     
    ##  NA's   :1                                          
    ##  A - 6. I am developing my oral and writing skills
    ##  Min.   :0.0000                                   
    ##  1st Qu.:0.7500                                   
    ##  Median :0.7500                                   
    ##  Mean   :0.7775                                   
    ##  3rd Qu.:1.0000                                   
    ##  Max.   :1.0000                                   
    ##  NA's   :1                                        
    ##  A - 7. I am developing my reflective and critical reasoning skills
    ##  Min.   :0.0000                                                    
    ##  1st Qu.:0.6667                                                    
    ##  Median :0.6667                                                    
    ##  Mean   :0.7933                                                    
    ##  3rd Qu.:1.0000                                                    
    ##  Max.   :1.0000                                                    
    ##  NA's   :1                                                         
    ##  A - 8. The assessment methods are assisting me to learn
    ##  Min.   :0.0000                                         
    ##  1st Qu.:0.7500                                         
    ##  Median :1.0000                                         
    ##  Mean   :0.9025                                         
    ##  3rd Qu.:1.0000                                         
    ##  Max.   :1.0000                                         
    ##  NA's   :1                                              
    ##  A - 9. I receive relevant feedback
    ##  Min.   :0.00                      
    ##  1st Qu.:0.50                      
    ##  Median :1.00                      
    ##  Mean   :0.79                      
    ##  3rd Qu.:1.00                      
    ##  Max.   :1.00                      
    ##  NA's   :1                         
    ##  A - 10. I read the recommended readings and notes
    ##  Min.   :0.000                                    
    ##  1st Qu.:0.500                                    
    ##  Median :1.000                                    
    ##  Mean   :0.775                                    
    ##  3rd Qu.:1.000                                    
    ##  Max.   :1.000                                    
    ##  NA's   :1                                        
    ##  A - 11. I use the eLearning material posted
    ##  Min.   :0.00                               
    ##  1st Qu.:0.50                               
    ##  Median :1.00                               
    ##  Mean   :0.85                               
    ##  3rd Qu.:1.00                               
    ##  Max.   :1.00                               
    ##  NA's   :1                                  
    ##  B - 1. Concept 1 of 6: Principles of Business Intelligence and the DataOps Philosophy
    ##  Min.   :0.0000                                                                       
    ##  1st Qu.:0.7500                                                                       
    ##  Median :0.7500                                                                       
    ##  Mean   :0.8125                                                                       
    ##  3rd Qu.:1.0000                                                                       
    ##  Max.   :1.0000                                                                       
    ##  NA's   :1                                                                            
    ##  B - 2. Concept 3 of 6: Linear Algorithms for Predictive Analytics
    ##  Min.   :0.0000                                                   
    ##  1st Qu.:0.3333                                                   
    ##  Median :0.6667                                                   
    ##  Mean   :0.6467                                                   
    ##  3rd Qu.:1.0000                                                   
    ##  Max.   :1.0000                                                   
    ##  NA's   :1                                                        
    ##  C - 2. Quizzes at the end of each concept
    ##  Min.   :0.0000                           
    ##  1st Qu.:0.6667                           
    ##  Median :1.0000                           
    ##  Mean   :0.8633                           
    ##  3rd Qu.:1.0000                           
    ##  Max.   :1.0000                           
    ##  NA's   :1                                
    ##  C - 3. Lab manuals that outline the steps to follow during the labs
    ##  Min.   :0.000                                                      
    ##  1st Qu.:0.500                                                      
    ##  Median :1.000                                                      
    ##  Mean   :0.805                                                      
    ##  3rd Qu.:1.000                                                      
    ##  Max.   :1.000                                                      
    ##  NA's   :1                                                          
    ##  C - 4. Required lab work submissions at the end of each lab manual that outline the activity to be done on your own
    ##  Min.   :0.000                                                                                                      
    ##  1st Qu.:0.500                                                                                                      
    ##  Median :1.000                                                                                                      
    ##  Mean   :0.775                                                                                                      
    ##  3rd Qu.:1.000                                                                                                      
    ##  Max.   :1.000                                                                                                      
    ##  NA's   :1                                                                                                          
    ##  C - 5. Supplementary videos to watch
    ##  Min.   :0.0000                      
    ##  1st Qu.:0.7500                      
    ##  Median :0.7500                      
    ##  Mean   :0.7975                      
    ##  3rd Qu.:1.0000                      
    ##  Max.   :1.0000                      
    ##  NA's   :1                           
    ##  C - 6. Supplementary podcasts to listen to
    ##  Min.   :0.00                              
    ##  1st Qu.:0.75                              
    ##  Median :0.75                              
    ##  Mean   :0.77                              
    ##  3rd Qu.:1.00                              
    ##  Max.   :1.00                              
    ##  NA's   :1                                 
    ##  C - 7. Supplementary content to read C - 8. Lectures slides
    ##  Min.   :0.0000                       Min.   :0.0000        
    ##  1st Qu.:0.7500                       1st Qu.:0.6667        
    ##  Median :0.7500                       Median :1.0000        
    ##  Mean   :0.7925                       Mean   :0.8667        
    ##  3rd Qu.:1.0000                       3rd Qu.:1.0000        
    ##  Max.   :1.0000                       Max.   :1.0000        
    ##  NA's   :1                            NA's   :1             
    ##  C - 9. Lecture notes on some of the lecture slides
    ##  Min.   :0.0000                                    
    ##  1st Qu.:0.6667                                    
    ##  Median :1.0000                                    
    ##  Mean   :0.8667                                    
    ##  3rd Qu.:1.0000                                    
    ##  Max.   :1.0000                                    
    ##  NA's   :1                                         
    ##  C - 10. The quality of the lectures given (quality measured by the breadth (the full span of knowledge of a subject) and depth (the extent to which specific topics are focused upon, amplified, and explored) of learning - NOT quality measured by how fun/comical/lively the lectures are)
    ##  Min.   :0.0000                                                                                                                                                                                                                                                                               
    ##  1st Qu.:0.6667                                                                                                                                                                                                                                                                               
    ##  Median :1.0000                                                                                                                                                                                                                                                                               
    ##  Mean   :0.8467                                                                                                                                                                                                                                                                               
    ##  3rd Qu.:1.0000                                                                                                                                                                                                                                                                               
    ##  Max.   :1.0000                                                                                                                                                                                                                                                                               
    ##  NA's   :1                                                                                                                                                                                                                                                                                    
    ##  C - 11. The division of theory and practice such that most of the theory is done during the recorded online classes and most of the practice is done during the physical classes
    ##  Min.   :0.0000                                                                                                                                                                  
    ##  1st Qu.:0.6667                                                                                                                                                                  
    ##  Median :1.0000                                                                                                                                                                  
    ##  Mean   :0.8300                                                                                                                                                                  
    ##  3rd Qu.:1.0000                                                                                                                                                                  
    ##  Max.   :1.0000                                                                                                                                                                  
    ##  NA's   :1                                                                                                                                                                       
    ##  C - 12. The recordings of online classes
    ##  Min.   :0.0000                          
    ##  1st Qu.:0.6667                          
    ##  Median :1.0000                          
    ##  Mean   :0.7767                          
    ##  3rd Qu.:1.0000                          
    ##  Max.   :1.0000                          
    ##  NA's   :1                               
    ##  D - 1. Write two things you like about the teaching and learning in this unit so far.
    ##  Length:101                                                                           
    ##  Class :character                                                                     
    ##  Mode  :character                                                                     
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##                                                                                       
    ##  D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)
    ##  Length:101                                                                                                                          
    ##  Class :character                                                                                                                    
    ##  Mode  :character                                                                                                                    
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##                                                                                                                                      
    ##  Average Course Evaluation Rating Average Level of Learning Attained Rating
    ##  Min.   :0.0000                   Min.   :0.0000                           
    ##  1st Qu.:0.6522                   1st Qu.:0.5000                           
    ##  Median :0.7826                   Median :0.6667                           
    ##  Mean   :0.7757                   Mean   :0.6983                           
    ##  3rd Qu.:0.9565                   3rd Qu.:0.8333                           
    ##  Max.   :1.0000                   Max.   :1.0000                           
    ##  NA's   :1                        NA's   :1                                
    ##  Average Pedagogical Strategy Effectiveness Rating
    ##  Min.   :0.0000                                   
    ##  1st Qu.:0.4875                                   
    ##  Median :0.7500                                   
    ##  Mean   :0.6875                                   
    ##  3rd Qu.:0.9500                                   
    ##  Max.   :1.0000                                   
    ##  NA's   :1                                        
    ##  Project: Section 1-4: (20%) x/10 Project: Section 5-11: (50%) x/10
    ##  Min.   :0.0000                   Min.   :0.0000                   
    ##  1st Qu.:0.7400                   1st Qu.:0.6000                   
    ##  Median :0.8500                   Median :0.7800                   
    ##  Mean   :0.8011                   Mean   :0.6582                   
    ##  3rd Qu.:0.9000                   3rd Qu.:0.8300                   
    ##  Max.   :1.0000                   Max.   :1.0000                   
    ##                                                                    
    ##  Project: Section 12: (30%) x/5 Project: (10%): x/30 x 100 TOTAL
    ##  Min.   :0.000                  Min.   :0.0000                  
    ##  1st Qu.:0.000                  1st Qu.:0.5600                  
    ##  Median :0.000                  Median :0.6640                  
    ##  Mean   :0.203                  Mean   :0.6239                  
    ##  3rd Qu.:0.250                  3rd Qu.:0.7160                  
    ##  Max.   :1.000                  Max.   :1.0000                  
    ##  NA's   :1                                                      
    ##  Quiz 1 on Concept 1 (Introduction) x/32 Quiz 3 on Concept 3 (Linear) x/15
    ##  Min.   :0.0000                          Min.   :0.0000                   
    ##  1st Qu.:0.2558                          1st Qu.:0.3333                   
    ##  Median :0.3992                          Median :0.5000                   
    ##  Mean   :0.4380                          Mean   :0.5442                   
    ##  3rd Qu.:0.5615                          3rd Qu.:0.7500                   
    ##  Max.   :1.0000                          Max.   :1.0000                   
    ##                                          NA's   :2                        
    ##  Quiz 4 on Concept 4 (Non-Linear) x/22 Quiz 5 on Concept 5 (Dashboarding) x/10
    ##  Min.   :0.0000                        Min.   :0.0000                         
    ##  1st Qu.:0.4166                        1st Qu.:0.3946                         
    ##  Median :0.5526                        Median :0.4996                         
    ##  Mean   :0.5756                        Mean   :0.5026                         
    ##  3rd Qu.:0.7632                        3rd Qu.:0.6314                         
    ##  Max.   :1.0000                        Max.   :1.0000                         
    ##  NA's   :6                             NA's   :12                             
    ##  Quizzes and  Bonus Marks (7%): x/79 x 100 TOTAL
    ##  Min.   :0.0000                                 
    ##  1st Qu.:0.2545                                 
    ##  Median :0.4211                                 
    ##  Mean   :0.4343                                 
    ##  3rd Qu.:0.5638                                 
    ##  Max.   :1.0000                                 
    ##                                                 
    ##  Lab 1 - 2.c. - (Simple Linear Regression) x/5
    ##  Min.   :0.000                                
    ##  1st Qu.:1.000                                
    ##  Median :1.000                                
    ##  Mean   :0.949                                
    ##  3rd Qu.:1.000                                
    ##  Max.   :1.000                                
    ##  NA's   :3                                    
    ##  Lab 2 - 2.e. -  (Linear Regression using Gradient Descent) x/5
    ##  Min.   :0.0000                                                
    ##  1st Qu.:0.3509                                                
    ##  Median :0.9474                                                
    ##  Mean   :0.7075                                                
    ##  3rd Qu.:1.0000                                                
    ##  Max.   :1.0000                                                
    ##  NA's   :6                                                     
    ##  Lab 3 - 2.g. - (Logistic Regression using Gradient Descent) x/5
    ##  Min.   :0.0000                                                 
    ##  1st Qu.:0.9302                                                 
    ##  Median :0.9302                                                 
    ##  Mean   :0.8280                                                 
    ##  3rd Qu.:0.9302                                                 
    ##  Max.   :1.0000                                                 
    ##  NA's   :9                                                      
    ##  Lab 4 - 2.h. - (Linear Discriminant Analysis) x/5
    ##  Min.   :0.0000                                   
    ##  1st Qu.:0.7143                                   
    ##  Median :0.9524                                   
    ##  Mean   :0.8174                                   
    ##  3rd Qu.:1.0000                                   
    ##  Max.   :1.0000                                   
    ##  NA's   :18                                       
    ##  Lab 5 - Chart JS Dashboard Setup x/5 Lab Work (7%) x/25 x 100
    ##  Min.   :0.0000                       Min.   :0.0000          
    ##  1st Qu.:0.0000                       1st Qu.:0.6448          
    ##  Median :1.0000                       Median :0.7567          
    ##  Mean   :0.6808                       Mean   :0.7532          
    ##  3rd Qu.:1.0000                       3rd Qu.:0.9659          
    ##  Max.   :1.0000                       Max.   :1.0000          
    ##                                                               
    ##  CAT 1 (8%): x/38 x 100 CAT 2 (8%): x/100 x 100
    ##  Min.   :0.0000         Min.   :0.0000         
    ##  1st Qu.:0.4083         1st Qu.:0.5100         
    ##  Median :0.5714         Median :0.6350         
    ##  Mean   :0.5662         Mean   :0.6213         
    ##  3rd Qu.:0.7756         3rd Qu.:0.8175         
    ##  Max.   :1.0000         Max.   :1.0000         
    ##  NA's   :4              NA's   :31             
    ##  Attendance Waiver Granted: 1 = Yes, 0 = No Absenteeism Percentage
    ##  0:96                                       Min.   :0.0000        
    ##  1: 5                                       1st Qu.:0.1429        
    ##                                             Median :0.2856        
    ##                                             Mean   :0.2973        
    ##                                             3rd Qu.:0.4285        
    ##                                             Max.   :1.0000        
    ##                                                                   
    ##  Coursework TOTAL: x/40 (40%) EXAM: x/60 (60%)
    ##  Min.   :0.0000               Min.   :0.0000  
    ##  1st Qu.:0.4698               1st Qu.:0.4118  
    ##  Median :0.6197               Median :0.5686  
    ##  Mean   :0.6177               Mean   :0.5674  
    ##  3rd Qu.:0.7910               3rd Qu.:0.7255  
    ##  Max.   :1.0000               Max.   :1.0000  
    ##                               NA's   :4       
    ##  TOTAL = Coursework TOTAL + EXAM (100%) GRADE 
    ##  Min.   :0.0000                         A:23  
    ##  1st Qu.:0.4744                         B:25  
    ##  Median :0.6383                         C:22  
    ##  Mean   :0.6187                         D:25  
    ##  3rd Qu.:0.7646                         E: 6  
    ##  Max.   :1.0000                               
    ## 

## Box-Cox Power Transform

\`\`\`{Box-Cox Power Transform} summary(student_performance_dataset)

model_of_the_transform \<- preProcess(student_performance_dataset,
method = c(“BoxCox”)) print(model_of_the_transform)
student_performance_dataset_box_cox_transform \<-
predict(model_of_the_transform, \# nolint student_performance_dataset)

# AFTER

summary(student_performance_dataset_box_cox_transform)

\`\`\`

**etc.** as per the lab submission requirements. Be neat and communicate
in a clear and logical manner.
