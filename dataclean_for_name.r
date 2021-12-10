library(rjson)
library(dplyr)
#library(jsonio)
library(jsonlite)
library(tidyverse)

data<- read.csv("data_race_pred_name.csv",sep = "," ,encoding = 'latin1')

colnames(data)[1] = "user_id"
data_clean<-data[,1:4]
data_clean<- data_clean%>%
  filter(race == "1"|race == "2"|race == "3"|race == "4"|race == "5")


data_sep <- data_clean %>% separate(col=name,
                                       into = c("fn", "ln", "add1",  "add2"),
                                       sep = " ",
                                       fill = "right")

data_sep <- data_sep %>%
  mutate(ln1 = ifelse(is.na(ln), fn, ln))

library(stringi)
data_sep$ln1<-stringi::stri_trans_general(data_sep$ln1, "latin-ascii")

dat <- data_sep$ln1
# convert string to vector of words
dat2 <- unlist(strsplit(dat, split=", "))
# find indices of words with non-ASCII characters
dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
# subset original vector of words to exclude words with non-ASCII char
dat4 <- dat2[-dat3]
# convert vector back to a string
dat5 <- paste(dat4, collapse = ", ")
for (i in 1:2646){
  data6[i,1]<- as.data.frame(dat4[i])
}
colnames(data6)[1]<- "ln1"
data_merge<-semi_join(data_sep,data6, by="ln1")

data_for_race_name<- data_merge[,c(1,2,3,6,7,8)]%>%
  mutate(full_name = paste(fn,ln1,sep = " "))%>%
  filter(race != "5")
write.csv(data_for_race_name,"data_for_race_name.csv",row.names=FALSE,col.names=TRUE,sep=",")

