library(lubridate);
library(sqldf);

### [1] Loading and preprocessing the data

## 1. Load the data
activity <- read.csv("C:\\Users\\Hyunjin\\Dropbox\\2016³â 2ÇÐ±â\\Analytics Programming\\Data\\activity.csv", head=T);
head(activity)

## 2. Process/transform the data (if necessary into a format suitable for your analysis)

# A: not need to process or transform the data


### [2] What is mean total number of steps taken per day?

## 1. Calculate the total number of steps taken per day
tt_number_pday <- sqldf('select date,
                        sum(steps) as "total_steps"
                        from activity
                        group by date
                        order by date');
tt_number_pday$total_steps <- as.numeric(tt_number_pday$total_steps);

## 2. Make a histogram of the total number of steps taken each day
hist(tt_number_pday$total_steps, main="total number of steps taken per day", xlab="total steps per day");

## 3. Calculate and report the mean and median of the total number of steps taken per day
mean(tt_number_pday$total_steps, na.rm=T); # 10766.19
median(tt_number_pday$total_steps, na.rm=T); # 10765


### [3] What is the average daily activity pattern?

## 1, Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis)
## and the average number of steps taken, averaged across all days (y-axis)

avg_number_pint <- sqldf('select interval,
                        avg(steps) as "avg_steps"
                        from activity
                        group by interval
                        order by interval');
avg_number_pint$avg_steps <- as.numeric(avg_number_pint$avg_steps);
plot(x=avg_number_pint$interval, y=avg_number_pint$avg_steps, type="l",
     xlab="interval", ylab="average number of steps",
     main="average number of steps per 5-minute");

## 2. Which 5-minute interval, on average across all the days in the dataset,
## contains the maximum number of steps?

max_steps <- max(avg_number_pint$avg_steps);
for (i in 1:nrow(avg_number_pint)) {
  if (avg_number_pint$avg_steps[i] == max_steps) int <- avg_number_pint$interval[i];
}
int; # 835


### [4] Imputing missing values

## 1. Calculate and report the total number of missing values in the dataset
## (i.e. the total number of rows with NAs)
missing_dataset <- subset(activity, is.na(activity$steps)==T);
nrow(missing_dataset); # 2304

## 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated.
## For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

# A: I will replace the missing values to mean for that 5-minute interval.

## 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

activity_mod <- activity;

for (i in 1:nrow(activity_mod)) {
  if (is.na(activity_mod$steps[i])==T) {
    interval_pointer <- activity_mod$interval[i];
    temp_activity <- subset(activity_mod, interval==interval_pointer);
    activity_mod$steps[i] = mean(temp_activity$steps, na.rm=T);
  }
}

## 4. Make a histogram of the total number of steps taken each day
## and Calculate and report the mean and median total number of steps taken per day.
## Do these values differ from the estimates from the first part of the assignment?
## What is the impact of imputing missing data on the estimates of the total daily number of steps?

imp_tt_number_pday <- sqldf('select date,
                        sum(steps) as "total_steps"
                        from activity_mod
                        group by date
                        order by date');
imp_tt_number_pday$total_steps <- as.numeric(imp_tt_number_pday$total_steps);

hist(imp_tt_number_pday$total_steps, main="total number of steps taken per day (imp)", xlab="total steps per day");

mean(imp_tt_number_pday$total_steps, na.rm=T); # 10766.19
median(imp_tt_number_pday$total_steps, na.rm=T); # 10766.19

# A: Because I used the mean for imputation, mean didn't change, and median got more close to mean.


### [5] Are there differences in activity patterns between weekdays and weekends?

## 1. Create a new factor variable in the dataset with two levels
## ??? ¡°weekday¡± and ¡°weekend¡± indicating whether a given date is a weekday or weekend day.

activity_mod$day_of_week <- weekdays(as.Date(activity_mod$date));
activity_mod$weekday_num <- format(as.Date(activity_mod$date),"%w");

for (i in 1:nrow(activity_mod)) {
  if ((activity_mod$weekday_num[i]==0) || (activity_mod$weekday_num[i]==6)) {
    activity_mod$weekday[i] = "weekend";
  } else activity_mod$weekday[i] = "weekday";
}

## 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis)
## and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

activity_weekend <- subset(activity_mod, weekday=="weekend");
activity_weekday <- subset(activity_mod, weekday=="weekday");

# weekend 
avg_number_pint_we <- sqldf('select interval,
                         avg(steps) as "avg_steps"
                         from activity_weekend
                         group by interval
                         order by interval');
avg_number_pint_we$avg_steps <- as.numeric(avg_number_pint_we$avg_steps);
plot(x=avg_number_pint_we$interval, y=avg_number_pint_we$avg_steps, type="l",
     xlab="interval", ylab="average number of steps",
     main="average number of steps per 5-minute (weekend)");

# weekday
avg_number_pint_wd <- sqldf('select interval,
                            avg(steps) as "avg_steps"
                            from activity_weekday
                            group by interval
                            order by interval');
avg_number_pint_wd$avg_steps <- as.numeric(avg_number_pint_wd$avg_steps);
plot(x=avg_number_pint_wd$interval, y=avg_number_pint_wd$avg_steps, type="l",
     xlab="interval", ylab="average number of steps",
     main="average number of steps per 5-minute (weekday)");

