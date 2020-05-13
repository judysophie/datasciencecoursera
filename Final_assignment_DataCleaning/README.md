---
title: "README"
author: "Me"
date: "5/13/2020"
output: html_document
---

## Purpose and aim of the analysis

The data used in this analysis was compiled by avide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz and collected in the dataset "Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine"[1]. Refer to the original data for details about experimental setup and data generation, as well as naming of the measurements.

The data has been downloaded as a zipfolder.
The raw data contained in "Inertial Signals" subfolders was not used for analysis.
Purpose of this analysis is the preparation of the data in a tidy form and a first simple analysis.
"subject_test.txt" & "subject_train.txt" contains the subjects id, which will be used as the row label.
"test/X_test.txt" & "train/X_train.txt" contain the measured and calculated data.
"test/y_test.txt" & "train/y_train.txt" contain the code of the activities carried out at the measurements by the subject.
"features.txt" contains the list of measured and calculated features 1-561.
"activity_labels.txt" contains the code and associated activities for the activities denoted in the y_test and y_train data.

The final, tidy dataset can be found in "Grouped_Data.txt". To reload into R, use read.table(filepath, header=TRUE).

Use the R file "run_analysis.R" to reproduce the tidy dataset, it downloads the original data, opens, cleans and merges the datasets to generate a dataset for all observations (Test and Training), and further extracts only the columns showing the mean and standard deviation for each subject. This data is further grouped by Subject and Activity.
The final, tidy dataset "groupedData" contains the computed average for each subject
and each activity.
Subject IDs received a prefix: Test for subjects of the Test-group, Train for subjects of the Training group
Column names were adapted from the original data source (see [1] for details about the undertaken measurements and labels) and were prefixed with OverallMean.

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

