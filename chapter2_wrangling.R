# Introduction to Open Data Science 2017
# 12/11/2017, by Anton Saressalo
# Chapter 2: Data wrangling exercises to prepare the raw data to be analyzed

# Download the raw data
raw_data = read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep="\t",header=T)

# Exclude the data where points = 0
raw_data = filter(raw_data,raw_data$Points > 0)

# Select the needed variables directly readable
direct_columns = c("gender","Age","Attitude","Points")
deep_columns <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_columns <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_columns <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

selected_data = select(raw_data,one_of(direct_columns))

# Calculate "Deep","Stra" and "Surf"
selected_data$deep <- rowMeans(select(raw_data,one_of(deep_columns)))

selected_data$surf <- rowMeans(select(raw_data,one_of(surface_columns)))

selected_data$stra <- rowMeans(select(raw_data,one_of(strategic_columns)))

# Save the results in file
write.csv(selected_data,file="data/chapter2data.csv",row.names=FALSE)

# Make sure that the file is also readable
read.csv("data/chapter2data.csv")
