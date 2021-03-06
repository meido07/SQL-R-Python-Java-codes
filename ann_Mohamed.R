# Artificial Neural Network

# Classification template

# Importing the dataset

dataset = read.csv('Churn_Modelling.csv')
dataset = dataset[4:14]

# Encoding the categorical variables as factors

dataset$Geography = as.numeric(factor(dataset$Geography,
                                      levels = c('France', 'Spain', 'Germany'),
                                      labels = c(1, 2, 3)))
dataset$Gender = as.numeric(factor(dataset$Gender,
                                   levels = c('Female', 'Male'),
                                   labels = c(1, 2)))

# Spliting the dataset into the training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Exited, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)


# Feature Scaling
training_set[-11] = scale(training_set[-11])
test_set[-11] = scale(test_set[-11])

# Fitting ANN to the Training set

#install.packages('h2o')
library(h2o)
h2o.init(nthreads = -1)
classifier = h2o.deeplearning(y = 'Exited',
                               training_frame = as.h2o(training_set),
                               activation = 'Rectifier',
                              hidden = c(6,6),
                              epochs = 100,
                              train_samples_per_iteration = -2)

# Predicting the Test set results

prob_pred = h2o.predict(classifier, newdata = as.h2o(test_set[-11]))
y_pred = (y_pred > 0.5)
y_pred = as.vector(y_pred)

# Making the confusion Matrix

cm = table(test_set[, 11], y_pred)

# the result of CM was 1536 who stayed and 195 who left the bank, to the accuracy we need to
# calculte the correct result and divide by the total of the training set

(1536 + 195)/ 2000 # 0.8655 around %86 accuracy, which we can share with the bank

h2o.shutdown() #shut down the h2o to save memory

