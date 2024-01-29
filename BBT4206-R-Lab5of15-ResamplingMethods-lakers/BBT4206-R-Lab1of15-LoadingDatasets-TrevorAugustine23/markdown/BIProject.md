Business Intelligence Project
================
<Specify your name here>
<Specify the date when you submitted the lab>

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [Understanding the Dataset (Exploratory Data Analysis
  (EDA))](#understanding-the-dataset-exploratory-data-analysis-eda)
  - [Loading the Dataset](#loading-the-dataset)
    - [Source:](#source)
    - [Reference:](#reference)

# Student Details

|                                              |                         |
|----------------------------------------------|-------------------------|
| **Student ID Number**                        | 134780                  |
| **Student Name**                             | Trevor Augustine Okinda |
| **BBIT 4.2 Group**                           | C                       |
| **BI Project Group Name/ID (if applicable)** | …                       |

# Setup Chunk

**Note:** the following KnitR options have been set as the global
defaults: <BR>
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

# Understanding the Dataset (Exploratory Data Analysis (EDA))

## Loading the Dataset

### Source:

The dataset that was used can be downloaded here:
<https://www.kaggle.com/datasets/bhanupratapbiswas/weather-data?resource=download>

### Reference:

Biswas Bhanupratap (2023). Weather Data - Understanding and Utilizing
Weather Data \[Dataset\]. Kaggle.
<https://www.kaggle.com/datasets/bhanupratapbiswas/weather-data?resource=download>
\#no lint

``` r
library(readr)
Weather_Data <- read_csv("Weather_Data.csv", 
                         col_types = cols(Visibility_km = col_double(), 
                                          Weather = col_character()))
View(Weather_Data)
```

…to be continued
