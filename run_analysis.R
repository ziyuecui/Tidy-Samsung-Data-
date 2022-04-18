setwd("~/Desktop/Data Science/Data Science Specialization/UCI HAR Dataset")
library(dplyr)
library(reshape2)

######### find the relevent features (index and names)
read.table('features.txt')[, 2] %>%
        as.character() -> features
grep(pattern = 'mean|std', features) -> features.index
features[features.index] %>% # adjust var names
        gsub(pattern = '[()]', replacement = '') %>%
        gsub(pattern = '^t', replacement = 'time-') %>%
        gsub(pattern = '^f', replacement = 'frequency-') %>%
        gsub(pattern = 'Acc', replacement = 'Accelaration') %>%
        gsub(pattern = 'Gyro', replacement = 'Gyroscope') -> features.name

######### use the index and name to merge the data
xtest <- read.table('./test/X_test.txt')[, features.index]
ytest <- read.table('./test/Y_test.txt')
testee <- read.table('./test/subject_test.txt')
xtrain <- read.table('./train/X_train.txt')[, features.index]
ytrain <- read.table('./train/Y_train.txt')
trainee <- read.table('./train/subject_train.txt')
# merge and adjust names and labels
full <- rbind(cbind(testee, ytest, xtest),
              cbind(trainee, ytrain, xtrain) )
colnames(full) <- c('subject', 'activity', features.name)
activity.label <- read.table('activity_labels.txt')
full$activity <- factor(full$activity, levels = activity.label[, 1], labels = activity.label[, 2])

######### melt and cast data to a txt file
melt(full, id.vars = c('subject', 'activity')) %>%
        dcast(subject + activity ~ variable, mean) %>%
        write.table("output.txt", row.names = FALSE)
