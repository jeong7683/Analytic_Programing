
best <- function(state, outcome) {
  ## Read outcome data
  
  ## Check that state and outcome are valid
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
  df <- read.csv("C:\\Users\\Hyunjin\\Dropbox\\2016년 2학기\\Analytics Programming\\Data\\outcome-of-care-measures.csv", colClasses = "character")
  
  states <- unique(df$State)
  outcomes <- c("heart attack", "heart failure", "pneumonia")
  
  if (!(state %in% states)) {
    stop("invalid state")
  }
  
  if (!(outcome %in% outcomes)) {
    stop("invalid outcome")
  }
  
  df2 <- df[df$State == state, ]
  df2[, c(11, 17, 23)] <- sapply(df2[, c(11, 17, 23)], as.numeric)
  df2 <- df2[order(df2[, 2]), ]
  
  if (outcome == "heart attack") {
    best <- df2[which.min(df2[, 11]), "Hospital.Name"]
  }
  else if (outcome == "heart failure") {
    best <- df2[which.min(df2[, 17]), "Hospital.Name"]
  }
  else {
    best <- df2[which.min(df2[, 23]), "Hospital.Name"]
  }
  
  best
}

#state <- "NN"
#state <- "NY"
#outcome <- "pneumonia"

best("SC", "heart attack")
best("NY", "pneumonia")
best("AK","pneumonia")



df <- read.csv("C:\\Users\\Hyunjin\\Dropbox\\2016년 2학기\\Analytics Programming\\Data\\outcome-of-care-measures.csv", colClasses = "character")
df <- df[c(2, 7, 11, 17, 23)]
df[, c(3, 4, 5)] <- sapply(df[, c(3, 4, 5)], as.numeric)

state <- "AK"
outcome <- "heart failure"
num <- 10L

rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  
  ## Check that state and outcome are valid
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  
  states <- unique(df$State)
  outcomes <- c("heart attack", "heart failure", "pneumonia")
  
  if (!(state %in% states)) {
    stop("invalid state")
  }
  
  if (!(outcome %in% outcomes)) {
    stop("invalid outcome")
  }
  
  df2 <- df[df$State == state, ]
  
  if (outcome == "heart attack") {
    df2 <- df2[order(df2[, 3], df2[, 1]), ]
    df2 <- df2[!is.na(df2[, 3]), ]
  }
  else if (outcome == "heart failure") {
    df2 <- df2[order(df2[, 4], df2[, 1]), ]
    df2 <- df2[!is.na(df2[, 4]), ]
  }
  else {
    df2 <- df2[order(df2[, 5], df2[, 1]), ]
    df2 <- df2[!is.na(df2[, 5]), ]
  }
  
  if (num == "best") {
    num <- 1L
  }  
  else if (num == "worst") {
    num <- nrow(df2)
  }
  else {
    num <- as.numeric(num)
  }
  
  df2[num, 1]
}

#state <- "WA"

#outcome <- "pneumonia"
#num <- "1000"
rankhospital("NC", "heart attack", "worst")
rankhospital("WA", "heart attack", 7)
rankhospital("TX", "pneumonia", 10)
rankhospital("NY", "heart attack", 7)
#head(bestdf)
#head(bestdfrank)
#head(singledf[, 3:5])
#bestdfrank[ which(bestdfrank$State== state), ]





#rankhospital("WA", "pneumonia", 1000)


df <- df[c(2, 7, 11, 17, 23)]
df[, c(3, 4, 5)] <- sapply(df[, c(3, 4, 5)], as.numeric)

rankall <- function(outcome, num = "best") {
  ## Read outcome data
  
  ## Check that state and outcome are valid
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  
  states <- unique(df$State)
  states <- sort(states)
  
  ranks <- data.frame(hospital=NA, state=NA)
  
  for (i in 1:length(states)) {
    ranks[i, ] <- c(rankhospital(states[i], outcome, num), states[i])
  }
  
  ranks
}

df <- df[order(df[, 4]), ]
df <- df[!is.na(df[, 4]), ]
rstudio::viewData(df[df$State == state, ])

r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)
r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)
