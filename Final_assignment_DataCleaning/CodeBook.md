---
title: "CodeBook.md"
author: "Me"
date: "5/13/2020"
output: html_document
---

# Code Book 

This code book gives a short overview about the changes and computations made to the original data. 
Details on original experiment, the variables measured, and computations can be found in [1].

The following changes and computations were made:

* Only the following files were used:
    + "subject_test.txt" / "subject_train.txt"
    + "test/X_test.txt" / "train/X_train.txt"
    + "test/y_test.txt" / "train/y_train.txt": contain the code of activities carried out at the measurements by the subject.
    + "activity_labels.txt"
    + "features.txt": specifies the measurements and is used as colnames
* Mearurements in features.txt: In order to use the same syntax for all measurements, i.e. indicating the computation at the end of the feature description (compare features.txt in the original dataset), the structure was changed as follows:
    + angle(tBodyAccMean,gravity) = tBodyAccMean_gravity-angle
    + angle(tBodyAccJerkMean),gravityMean) = tBodyAccJerkMean_gravityMean-angle
    + angle(tBodyGyroMean,gravityMean) = tBodyGyroMean_gravityMean-angle
    + angle(tBodyGyroJerkMean,gravityMean) = tBodyGyroJerkMean_gravityMean-angle
    + angle(X,gravityMean) = X_gravityMean-angle
    + angle(Y,gravityMean) = Y_gravityMean-angle
    + angle(Z,gravityMean) = Z_gravityMean-angle
* All measurement names in features.txt are cleaned with the following steps:
    + Abbreviations "t" and "f" are replaced by "time" and "frequency", respectively
    + Parenthesis are removed
    + Comma are exchanged with underscore "_" to avoid problems with csv- formats
    + Duplicate columnames are made unique by adding integers with make.unique()
* During merging of the datasets contained in the files X, y, and subject for test and training, respectively, following changes were made:
    + Subject Data was named "Subjectid"
    + Activity Data was named "Activity"
    + Numbers in the Activity column were decoded into strings describing the corresponding activities
* Subject IDs were changed by appending a prefix to allow merging with unique subject IDs:
    + "Test-" to the test dataset
    + "Train-" to the training dataset
* From the merged dataset containing both the test and training data, only columns describing the average (mean) and standard deviation (std) were extracted.
    + Columns including a mean value used for a different calculation (e.g Z_gravityMean-angle) were not extracted
* The extracted data containing mean and std was grouped according to subjectid and activity to be able to compute the average for each activity and subject using mean()
    + The column names were prefixed with "OverallMean"

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012