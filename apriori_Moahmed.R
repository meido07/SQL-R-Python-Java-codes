# Apriori

# Data Preprocessing
#install.packages('arules')
library(arules)
dataset = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE)
summary(dataset)
itemFrequencyPlot(dataset, topN = 100)
itemFrequencyPlot(dataset, topN = 10)

#Training Apriori on the dataset
# Let say if the product purcahse 3 time a day then the total purchase per week 
#divided by the total of all products 3*7/750 = 0.0028 ~ 0.003 (support) 
# Confidence is arbitrary choice, so we start with default value which is 0.8
rules = apriori(data = dataset, parameter = list(support = 0.003 , confidence = 0.8 ))
# let trt 4 products per day 4*7/7500 = .0037 ~ .004
rules = apriori(data = dataset, parameter = list(support = 0.004 , confidence = 0.8 ))

# so the important part after exe this script to look up at the rules, as noticed, it's zero
#which is mean, out of 6 purchase it must be 4 are true. we keep looking for smaller confi
rules = apriori(data = dataset, parameter = list(support = 0.003 , confidence = 0.4 ))
rules = apriori(data = dataset, parameter = list(support = 0.003 , confidence = 0.2 ))
rules = apriori(data = dataset, parameter = list(support = 0.004 , confidence = 0.2 ))

#Visulising the results
inspect(sort(rules, by = 'lift')[1:10])

                
          





