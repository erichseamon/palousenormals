

library("rerddap")
  library("plyr")
  library("dplyr")
  year = "2016"
  setwd(paste("/dmine/data/USDA/agmesh-scenarios/", "Idaho", "/summaries5/", sep=""))
  
  file  <- list.files(pattern = year)
  stateyear <- read.csv(file, header=TRUE)
  
  names(stateyear)[16] <- c("fips")
  stateyear <- join(stateyear, county.fips, by = "fips")
  stateyearname <- data.frame(strsplit(as.character(stateyear$polyname), ","))
  stateyearname <- t(stateyearname[2,])
  stateyearfinal <- cbind(stateyearname, stateyear)
  colnames(stateyearfinal)[1] <- "countyname"
  
  normals <- aggregate(stateyearfinal, by = list(stateyearfinal$month, stateyearfinal$countyname), FUN=mean)
  
  subnormals <- subset(normals, Group.2 =="idaho")
  colnames(subnormals)[1] <- "month"
  colnames(subnormals)[2] <- "county"
  subnormals <- data.frame(subnormals)
  
  subnormals$month <- trimws(subnormals$month, "r")
  
  subnormals$month <- factor(subnormals$month, tolower(month.abb), ordered=TRUE)
  subnormals <- subnormals[order(subnormals$month), ]
  
  

  #subnormals %>% mutate(month = factor(month.name[subnormals$month], levels = month.name)) %>% arrange(subnormals$month)
  #subnormals <- data.frame(subnormals)
  
  barplot(subnormals$tmmx, subnormals[,12], names.arg = c("J", "F", "M", "A", "M","J", "J","A", "S", "O", "N", "D"), las = 2)
  

  
