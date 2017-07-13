library(httr)
require(httpuv)
require(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
myapp <- oauth_app("quiz2", "ddb0d599de51ccd02f4b", secret="6af1109f6ecf442d292425087d49bb13d9bbe9c8")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)
list(output[[4]]$name, output[[4]]$created_at)

library(data.table)
library(sqldf)
library(MSG)
library(htmlTable)

acs <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", head=T)
acs <- read.csv(fname, header = TRUE, sep = ",")

answer2 <- sqldf("select pwgtp1 from acs where AGEP < 50")
message("Probability weights for people with ages less than 50:")
message("sqldf('select pwgtp1 from acs where AGEP < 50'):", head(answer2))

connection <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(connection)
close(connection)
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))

require(httr)
require(XML)
htmlCode <- GET("http://biostat.jhsph.edu/~jleek/contact.html")
content <- content(htmlCode, as="text")
htmlParsed <- htmlParse(content, asText=TRUE)
xpathSApply(htmlParsed, "//title", xmlValue)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
lines <- readLines(url, n=10)
w <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames <- c("filler", "week", "filler", "sstNino12", "filler", "sstaNino12", "filler", "sstNino3", "filler", "sstaNino3", "filler", "sstNino34", "filler", "sstaNino34", "filler", "sstNino4", "filler", "sstaNino4")
d <- read.fwf(url, w, header=FALSE, skip=4, col.names=colNames)
d <- d[, grep("^[^filler]", names(d))]
sum(d[, 4])
