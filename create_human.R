## Chapter 4

library(dplyr)

# 2. Reading the datasets into variables
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# 3. Printing the datasets to see their content
str(hd)
# 8 variables with 195 objects in each. Most variables are numerals but "Country" and "Gross.National.Income..GNI..per.Capita" are strings.
# The latter could be converted to a numeral though.

str(gii)
# Now we have 10 variables, but again, 195 observations for each (for every country). Here all but "Country" are numerical values.

# Printing the summaries
summary(hd)
summary(gii)

# 4. Renaming the variables
# Print the column names to remember their order
colnames(hd)
colnames(hd)[1] = "rank"
colnames(hd)[2] = "country"
colnames(hd)[3] = "HDI"
colnames(hd)[4] = "exp_life"
colnames(hd)[5] = "exp_education"
colnames(hd)[6] = "mean_education"
colnames(hd)[7] = "GNI"
colnames(hd)[8] = "GNI_m_HDI"

# Same for gii
colnames(gii)
colnames(gii)[1] = "rank"
colnames(gii)[2] = "country"
colnames(gii)[3] = "GII"
colnames(gii)[4] = "maternal_mortality"
colnames(gii)[5] = "birth_rate"
colnames(gii)[6] = "parliament_F"
colnames(gii)[7] = "education_F"
colnames(gii)[8] = "education_M"
colnames(gii)[9] = "labour_F"
colnames(gii)[10] = "labour_M"

# 5. New variables
gii = mutate(gii, education_ratio = education_F/education_M)
gii = mutate(gii, labour_ratio = labour_F/labour_M)

str(gii)
# Now we have 12 variables, just as expected!

# Joining and saving
human = inner_join(hd,gii,by="country")
str(human)
# 195 obhects in 19 variables, just as expected!

# Save the results in file
write.csv(human,file="data/human.csv",row.names=FALSE)

# Make sure that the file is also readable
glimpse(read.csv("data/human.csv"))

## Chapter 5: Continuing the wrangling
# 1. Remove the commas from GNI
library(tidyr)
library(stringr)
human$GNI = str_replace(human$GNI,pattern=",", replace="") %>% as.numeric
str(human$GNI) # success

# 2. Exclude the unnecesary variables
keep =  c("country", "education_ratio", "labour_ratio", "exp_life", "exp_education", "GNI", "maternal_mortality", "birth_rate", "parliament_F")
human = select(human,one_of(keep))

# 3. Remove the rows with NA observations
human = human[complete.cases(human),]

# 4. Exclude the non-countries
# The last 7 observations are not countries, but larger regions, let's exclude them
last = nrow(human)-7
human = human[1:last,]

# 5. Add countries as row names and remove that as variable
rownames(human) = human$country
human = select(human, -country)
glimpse(human)

# Save the results in file
write.csv(human,file="data/human_2.csv",row.names=TRUE)

# Make sure that the file is also readable
human1 = read.csv("data/human_2.csv",header=TRUE)
