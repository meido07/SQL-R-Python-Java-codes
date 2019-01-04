# Natural Language Processing

# Importing the dataset
dataset = read.delim('Restaurant_Reviews.tsv', quote = '', stringsAsFactors = FALSE)

#dataset_original = read.delim('Restaurant_Reviews.tsv', quote = '', stringsAsFactors = FALSE)

# Cleaning the text 
#install.packages('tm')
#install.packages('SnowballC')
#install.packages('NLP')
library(tm)
library(SnowballC)
library(NLP)
corpus = VCorpus(VectorSource(dataset$Review))
corpus = tm_map(corpus, content_transformer(tolower))
# to check the first column and lookup the tranformation from Cap to lower alpha
#as.character(corpus[[1]])
corpus = tm_map(corpus, removeNumbers)
#as.character(corpus[[841]])
corpus = tm_map(corpus, removePunctuation)
#as.character(corpus[[1]])
# reomve irrelevant words
corpus = tm_map(corpus, removeWords, stopwords())
# stem brings the root of the word for example loved to love, bucks to buck
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

# Create the bag of Words  model 
dtm = DocumentTermMatrix(corpus)
# Now we will update dtm to filter not frequent words
dtm = removeSparseTerms(dtm, 0.999) #it mean we will keep %99 of frequent words
# we use Random Forest classification 
dataset = as.data.frame(as.matrix(dtm))
dataset$Liked = dataset_original$Liked

# Encoding the target feature as factor
dataset$Liked = factor(dataset$Liked, levels = c(0, 1))

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Liked, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting Random Forest Classification to the Training set
# install.packages('randomForest')
library(randomForest)
set.seed(123)
classifier = randomForest(x = training_set[-692],
                          y = training_set$Liked,
                          ntree = 10)

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692])

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)



