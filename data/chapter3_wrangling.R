# Introduction to Open Data Science 2017
# 22/11/2017, by Anton Saressalo
# Chapter 3: Data wrangling exercises to prepare the raw data to be analyzed. Data downloaded from https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Move to the data directory
setwd("/home/saressal/drive/Duuni/Kurssit/IODS/IODS-project/data")

# Read the data files the raw data
mat = read.csv("student-mat.csv", header=TRUE, sep=";")
por = read.csv("student-por.csv", header=TRUE, sep=";")

# In mat, we have 33 variables with 395 objects for each. Many of the varibales are booloean strings (yes/no) and some either string or numerical entrys.
# In por, there are 33 variables in 649 objects for each. The variables are the same as in mat.

# Joining the two data sets
library(dplyr)
join_by = c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
joined_data = inner_join(mat, por, by = join_by, suffix = c(".mat",".por"))
# inner_join() includes only those who are present in both of the original sets
# Now we have the wanted variables in the first 13 columns, after that we have 20 "leftover" columns for both mat and por.
# So 53 variables and 382 objeccts in total.

# Get rid of the duplicate data pretty much as in the datacamp example
result_data = select(joined_data,one_of(join_by))
notjoined_cols = colnames(mat)[!colnames(mat) %in% join_by]

for (colname in notjoined_cols) {
  two_cols = select(joined_data,starts_with(colname))
  first_col = select(two_cols,1)[[1]]
  
  if(is.numeric(first_col)) {
    result_data[colname] = round(rowMeans(two_cols))
  } else {
    result_data[colname] = first_col
  }
}

# Add the columns alc_use and high_use
result_data = mutate(result_data, alc_use = (Dalc + Walc)/2)
result_data = mutate(result_data, high_use = (alc_use > 2))

# Glimpse the data and make sure that the dimensions are correct
glimpse(result_data)
# => Yes, 382 observations of 35 variables.

# Save the results in file
write.csv(result_data,file="chapter3data.csv",row.names=FALSE)

# Make sure that the file is also readable
glimpse(read.csv("chapter3data.csv"))
