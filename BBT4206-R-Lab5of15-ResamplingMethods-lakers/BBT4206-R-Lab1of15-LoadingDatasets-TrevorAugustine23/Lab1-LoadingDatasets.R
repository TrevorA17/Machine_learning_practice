# *****************************************************************************
# Lab 1: Loading Datasets ----
# 
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# 1. Sources of Datasets ----
# There are several repositories where you can find datasets (mostly free) for
# learning and/or to use as part of a project. These include:

# 1.	Data in Brief Journal: https://www.sciencedirect.com/journal/data-in-brief
# 2.	University of California (UC) Irvine: https://archive.ics.uci.edu/datasets
# 3.	Kaggle: https://www.kaggle.com/datasets
# 4.	Data Science Dojo:
#       https://datasciencedojo.com/blog/datasets-data-science-skills/ or
#       https://code.datasciencedojo.com/datasciencedojo/datasets
# 5.	Kenya Open Data: https://kenya.opendataforafrica.org/data/#menu=topic
# 6.	openAFRICA: https://africaopendata.org/
# 7.	Datahub.io: https://datahub.io/collections
# 8.	Data.world: https://data.world/
# 9.	Google Data Search: https://datasetsearch.research.google.com/
# 10.	Google Public Data Explorer: https://www.google.com/publicdata/directory
# 11.	Data.gov: https://www.data.gov/
# 12.	Global Health Observatory Data Repository:
#       https://apps.who.int/gho/data/node.home
# 13.	UNICEF Data: https://data.unicef.org/
# 14.	Earth Data: https://earthdata.nasa.gov/
# 15.	CERN Open Data Portal: http://opendata.cern.ch/
# 16.	FBI Crime Data Portal: https://crime-data-explorer.fr.cloud.gov/
# 17.	New York City Taxi Trip Data:
#       https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page
# 18.	Our World in Data: https://ourworldindata.org/
# 19.	World Bank Open Data: https://data.worldbank.org/
# 20.	World Poverty: https://worldpoverty.io/map
# 21.	Worldometers: https://www.worldometers.info/
# 22.	European Data: https://data.europa.eu/en
# 23.	Livestock Data for Decisions (LD4D):
#       https://www.livestockdata.org/type/datasets
# etc.


# 2. Classification Datasets -----
## 2.1 DATASET 1: Dow Jones Index Data Set ----

### Description ----
# In predicting stock prices you collect data over some period of time - day,
# week, month, etc. But you cannot take advantage of data from a time period
# until the next increment of the time period. For example, assume you collect
# data daily.  When Monday is over you have all of the data for that day.
# However you can invest on Monday, because you don't get the data until the
# end of the day.  You can use the data from Monday to invest on Tuesday.

# In our research each record (row) is data for a week.  Each record also has
# the percentage of return that stock has in the following week
# (percent_change_next_weeks_price). Ideally, you want to determine which stock
# will produce the greatest rate of return in the following week.  This can help
# you train and test your algorithm.

# Some of these attributes might not be use used in your research.  They were
# originally added to our database to perform calculations.  (Brown, Pelosi &
# Dirska, 2013) used percent_change_price, percent_change_volume_over_last_wk,
# days_to_next_dividend, and percent_return_next_dividend.  We left the other
# attributes in the dataset	in case you wanted to use any of them. Of course
# what you want to maximize is percent_change_next_weeks_price.

# Training data vs Test data:
# In (Brown, Pelosi & Dirska, 2013) we used quarter 1 (Jan-Mar) data for
# training and quarter 2 (Apr-Jun) data for testing.
#
# Interesting data points:
# If you use quarter 2 data for testing, you will notice something interesting
# in the week ending 5/27/2011 every Dow Jones Index stock lost money.
#
# Attribute Information
# quarter:  the yearly quarter (1 = Jan-Mar; 2 = Apr-Jun).
# stock: the stock symbol (see above)
# date: the last business day of the work (this is typically a Friday)
# open: the price of the stock at the beginning of the week
# high: the highest price of the stock during the week
# low: the lowest price of the stock during the week
# close: the price of the stock at the end of the week
# volume: the number of shares of stock that traded hands in the week
# percent_change_price: the percentage change in price throughout the week
# percent_change_volume_over_last_wek: the percentage change in the number of
#   shares of stock that traded hands for this week compared to the previous
#   week
# previous_weeks_volume: the number of shares of stock that traded hands in the
#   previous week
# next_weeks_open: the opening price of the stock in the following week
# next_weeks_close: the closing price of the stock in the following week
# percent_change_next_weeks_price: the percentage change in price of the stock
# in the following week
# days_to_next_dividend: the number of days until the next dividend
# percent_return_next_dividend: the percentage of return on the next dividend

### Sources ----
##### [Primary] Source 1: UCI ----
# https://archive.ics.uci.edu/ml/datasets/Dow+Jones+Index
##### [Secondary] Source 2: Data Science Dojo ----
# https://code.datasciencedojo.com/datasciencedojo/datasets/tree/master/Dow%20Jones%20Index # nolint: line_length_linter.
##### [Secondary] Source 3: Kaggle ----
# https://www.kaggle.com/datasets/mnassrib/dow-jones-industrial-average

# Transform the data as follows:
# Transform the Data using an Excel Spreadsheet
# Microsoft Excel also offers data transformation features. Navigate to the
# following menu in a Microsoft Excel Spreadsheet:
#   Data > Get Data > From File > From Text/CSV

# Import the “dow_jones_index.data” file and select “Transform Data”.

# Select the following columns: “open”, “high”, “low”, “close”,
# “next_weeks_open”, and “next_weeks_close”.

# Remove the dollar sign by selecting “Replace Values” and enter “$” in the
# “Value To Find” text field and leave the “Replace With” text field empty.

# The presence of the dollar sign can make a tool like R assume that the
# variable stores a text field, yet it is supposed to store an integer.

# There is no other transformation that needs to be done.

# Select "Close & Load" and save the file (the first work sheet) as a .CSV file
# in the following location: "data/transforms/dow_jones_index.csv"

### Code ----
library(readr)
stock_ror_dataset <- read_csv(
  "data/transforms/dow_jones_index.csv",
  col_types = cols(
    stock = col_factor(
      levels = c(
        "AA",
        "AXP",
        "BA",
        "BAC",
        "CAT",
        "CSCO",
        "CVX",
        "DD",
        "DIS",
        "GE",
        "HD",
        "HPQ",
        "IBM",
        "INTC",
        "JNJ",
        "JPM",
        "KRFT",
        "KO",
        "MCD",
        "MMM",
        "MRK",
        "MSFT",
        "PFE",
        "PG",
        "T",
        "TRV",
        "UTX",
        "VZ",
        "WMT",
        "XOM"
      )
    ),
    date = col_date(format = "%m/%d/%Y")
  )
)

 ## 2.2 DATASET 2: Default of Credit Card Clients ----
### Description ----
# This research aimed at the case of customers default payments in Taiwan and
# compares the predictive accuracy of probability of default among six data
# mining methods. From the perspective of risk management, the result of
# predictive accuracy of the estimated probability of default will be more
# valuable than the binary result of classification - credible or not credible
# clients. Because the real probability of default is unknown, this study
# presented the novel Sorting Smoothing Methods to estimate the real probability
# of default. With the real probability of default as the response variable (Y),
# and the predictive probability of default as the independent variable (X),
# the simple linear regression result (Y = A + BX) shows that the forecasting
# model produced by artificial neural network has the highest coefficient of
# determination; its regression intercept (A) is close to zero, and regression
# coefficient (B) to one. Therefore, among the six data mining techniques,
# artificial neural network is the only one that can accurately estimate the
# real probability of default.

# Attribute Information
# This research employed a binary variable, default payment (Yes = 1, No = 0),
# as the response variable. This study reviewed the literature and used the
# following 23 variables as explanatory variables:
# X1: Amount of the given credit (NT dollar): it includes both the individual
#     consumer credit and his/her family (supplementary) credit.
# X2: Gender (1 = male; 2 = female).
# X3: Education (1 = graduate school; 2 = university; 3 = high school;
#   4 = others).
# X4: Marital status (1 = married; 2 = single; 3 = others).
# X5: Age (year).
# X6 - X11: History of past payment. We tracked the past monthly payment
#   records (from April to September, 2005) as follows: X6 = the repayment
#   status in September, 2005; X7 = the repayment status in August, 2005; . . .;
#   X11 = the repayment status in April, 2005. The measurement scale for the
#   repayment status is: -1 = pay duly; 1 = payment delay for one month;
#   2 = payment delay for two months; . . .; 8 = payment delay for eight
#   months; 9 = payment delay for nine months and above.
# X12-X17: Amount of bill statement (NT dollar). X12 = amount of bill statement
#   in September, 2005; X13 = amount of bill statement in August, 2005; . . .;
#   X17 = amount of bill statement in April, 2005.
# X18-X23: Amount of previous payment (NT dollar). X18 = amount paid in
#   September, 2005; X19 = amount paid in August, 2005; . . .;X23 = amount paid
#   in April, 2005.

# Convert the XLS file into a CSV file

### Sources ----
#### [Primary] Source 1:  UCI ----
# https://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients
#### [Secondary] Source 2: Data Science Dojo ----
# https://code.datasciencedojo.com/datasciencedojo/datasets/tree/master/Default%20of%20Credit%20Card%20Clients ---- # nolint: line_length_linter.
### Code ====
library(readr)
defaulter_dataset <-
  readr::read_csv(
    "data/default of credit card clients.csv",
    col_types = cols(
      SEX = col_factor(levels = c("1", "2")),
      EDUCATION = col_factor(levels = c("0", "1", "2", "3", "4", "5", "6")),
      MARRIAGE = col_factor(levels = c("0", "1", "2", "3")),
      `default payment next month` = col_factor(levels = c("1", "0")),
      `default payment next month` = col_factor(levels = c("1", "0"))
    ),
    skip = 1
  )

# 3 Regression Datasets ----
## 3.1 DATASET 3: Daily Demand Forecasting Orders Data Set ----
### Objective ----
#' The dataset was collected during 60 days, this is a real database of a
#' Brazilian logistics company. The dataset has twelve predictive attributes
#' and a target that is the total of orders for daily treatment. The database
#' was used in academic research at the Universidade Nove de Julho.
#'
#' Attributes:
#'   .arff header for Weka:
#' @relation Daily_Demand_Forecasting_Orders
#' @attribute Week_of_the_month {1.0, 2.0, 3.0, 4.0, 5.0}
#' @attribute Day_of_the_week_(Monday_to_Friday) {2.0, 3.0, 4.0, 5.0, 6.0}
#' @attribute Non_urgent_order integer
#' @attribute Urgent_order integer
#' @attribute Order_type_A integer
#' @attribute Order_type_B integer
#' @attribute Order_type_C integer
#' @attribute Fiscal_sector_orders integer
#' @attribute Orders_from_the_traffic_controller_sector integer
#' @attribute Banking_orders_(1) integer
#' @attribute Banking_orders_(2) integer
#' @attribute Banking_orders_(3) integer
#' @attribute Target_(Total_orders) integer
#' @data

### Sources ----
#### [Primary] Source 1: UCI ----
# https://archive.ics.uci.edu/ml/datasets/Daily+Demand+Forecasting+Orders
#### [Secondary] Source 2: Data Science Dojo ----
# https://code.datasciencedojo.com/datasciencedojo/datasets/tree/master/Daily%20Demand%20Forecasting%20Orders # nolint: line_length_linter.
### Code ----
library(readr)
demand_forecasting_dataset <-
  readr::read_delim(
    "data/Daily_Demand_Forecasting_Orders.csv",
    delim = ";",
    escape_double = FALSE,
    col_types = cols(
      `Week of the month (first week, second, third, fourth or fifth week` =
        col_factor(levels = c("1", "2", "3", "4", "5")),
      `Day of the week (Monday to Friday)` =
        col_factor(levels = c("2", "3", "4", "5", "6"))
    ),
    trim_ws = TRUE
  )

## 3.2 DATASET 4: Iranian Churn Dataset ----
### Objective ----
# This dataset is randomly collected from an Iranian telecom company database
# over a period of 12 months. A total of 3150 rows of data, each representing a
# customer, bear information for 13 columns. The attributes that are in this
# dataset are call failures, frequency of SMS, number of complaints, number of
# distinct calls, subscription length, age group, the charge amount, type of
# service, seconds of use, status, frequency of use, and Customer Value.

# All of the attributes except for attribute churn is the aggregated data of
# the first 9 months. The churn labels are the state of the customers at the end
# of 12 months. The three months is the designated planning gap.

# Attribute Information:
# Anonymous Customer ID
# Call Failures: number of call failures
# Complains: binary (0: No complaint, 1: complaint)
# Subscription Length: total months of subscription
# Charge Amount: Ordinal attribute (0: lowest amount, 9: highest amount)
# Seconds of Use: total seconds of calls
# Frequency of use: total number of calls
# Frequency of SMS: total number of text messages
# Distinct Called Numbers: total number of distinct phone calls
# Age Group: ordinal attribute (1: younger age, 5: older age)
# Tariff Plan: binary (1: Pay as you go, 2: contractual)
# Status: binary (1: active, 2: non-active)
# Churn: binary (1: churn, 0: non-churn) - Class label
# Customer Value: The calculated value of customer

### Note: Skip the last 7 rows ----

### [Primary] Source 1: UCI ----
# https://archive.ics.uci.edu/dataset/563/iranian+churn+dataset
### Code ----
library(readr)
churn_dateset <- read_csv(
  "data/Customer Churn.csv",
  col_types = cols(
    Complains = col_factor(levels = c("0",
                                      "1")),
    `Age Group` = col_factor(levels = c("1",
                                        "2", "3", "4", "5")),
    `Tariff Plan` = col_factor(levels = c("1",
                                          "2")),
    Status = col_factor(levels = c("1",
                                   "2")),
    Churn = col_factor(levels = c("0",
                                  "1"))
  )
)

c# References ----
# Refer to the APA 7th edition manual for rules on how to cite datasets:
# https://apastyle.apa.org/style-grammar-guidelines/references/examples/data-set-references  # nolint: line_length_linter.

## Brown, M. (2014). Dow Jones index (Version 1) [Dataset]. University of California, Irvine (UCI) Machine Learning Repository. https://doi.org/10.24432/C5788V # nolint ----

## Ferreira, R., Martiniano, A., Ferreira, A., Ferreira, A., & Sassi, R. (2017). Daily demand forecasting orders (Version 1) [Dataset]. University of California, Irvine (UCI) Machine Learning Repository. https://doi.org/10.24432/C5BC8T # nolint ----

## Iranian churn dataset (Version 1). (2020). [Dataset]. University of California, Irvine (UCI) Machine Learning Repository. https://doi.org/10.24432/C5JW3Z # nolint ----

## Yeh, I.-C. (2016). Default of credit card clients (Version 1) [Dataset]. University of California, Irvine (UCI) Machine Learning Repository. https://doi.org/10.24432/C55S3H # nolint ----

# **Required Lab Work Submission** ----
## Part A ----
# Specify the code you have used to load your own dataset for the BI Project
# here:
library(readr)
Weather_Data <- read_csv("data/Weather_Data.csv", 
                         col_types = cols(Visibility_km = col_double(), 
                                          Weather = col_character()))
View(Weather_Data)

## Reference : Biswas Bhanupratap (2023). Weather Data - Understanding and Utilizing Weather Data [Dataset]. Kaggle. https://www.kaggle.com/datasets/bhanupratapbiswas/weather-data?resource=download # nolint ----

## Part B ----
# Upload *the link* to your "Lab1-LoadingDatasets.R" hosted on Github (do not
# upload the .R file itself) through the submission link provided on
# eLearning.

## Part C ----
# Create a markdown file called "BIProject.Rmd" and place it inside the folder
# called "markdown". The markdown should have a code chunk that explains how
# the dataset has been loaded.

## Part D ----
# Upload *the link* to "BIProject.md" (not .Rmd) markdown file hosted on Github
# (do not upload the .Rmd or .md markdown files) through the same submission
# link provided on eLearning.