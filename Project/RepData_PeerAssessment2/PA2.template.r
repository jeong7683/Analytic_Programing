library(data.table);
library(ggplot2);
library(sqldf);

# Data Import
storm <- fread("C:\\Users\\Hyunjin\\Dropbox\\2016³â 2ÇÐ±â\\Analytics Programming\\Data\\repdata%2Fdata%2FStormData.csv", head=T);

dim(storm);
str(storm);


# Q1. which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?¡±

## Data Processing 

fatalities <- sqldf('select EVTYPE,
                      sum(FATALITIES) as "SUM_FATALITIES"
                      from storm
                      group by EVTYPE
                      order by EVTYPE');
fatalities$SUM_FATALITIES <- as.numeric(fatalities$SUM_FATALITIES);
injuries <- sqldf('select EVTYPE,
                  sum(INJURIES) as "SUM_INJURIES"
                  from storm
                  group by EVTYPE
                  order by EVTYPE');
injuries$SUM_INJURIES <- as.numeric(injuries$SUM_INJURIES);

## Result

### fatalities
plot <- ggplot(subset(fatalities,SUM_FATALITIES>100), aes(EVTYPE, SUM_FATALITIES));
plot <- plot + geom_point(aes(color=EVTYPE)) + theme(legend.position="none", axis.text.x = element_text(angle = 45, hjust = 1, size=7)) +
  labs(x="EVTYPE") + labs(y="total fatalities") + ggtitle("fatalities based on the event type");
print(plot); # just plotting that the fatalities is over 100
#### A: Tornado

### injuries
plot <- ggplot(subset(injuries,SUM_INJURIES>100), aes(EVTYPE, SUM_INJURIES));
plot <- plot + geom_point(aes(color=EVTYPE)) + theme(legend.position="none", axis.text.x = element_text(angle = 45, hjust = 1, size=7)) +
  labs(x="EVTYPE") + labs(y="total injuries") + ggtitle("injuries based on the event type");
print(plot); # just plotting that the injuries is over 100
#### A: Tornado


# Q2. Across the United States, which types of events have the greatest economic consequences?

## Data Processing

propdmg <- sqldf('select EVTYPE,
                    sum(PROPDMG) as "SUM_PROPDMG"
                    from storm
                    group by EVTYPE
                    order by EVTYPE');
propdmg$SUM_PROPDMG <- as.numeric(propdmg$SUM_PROPDMG);
cropdmg <- sqldf('select EVTYPE,
                  sum(CROPDMG) as "SUM_CROPDMG"
                  from storm
                  group by EVTYPE
                  order by EVTYPE');
cropdmg$SUM_CROPDMG <- as.numeric(cropdmg$SUM_CROPDMG);

## Result

### progdmg
plot <- ggplot(subset(propdmg,SUM_PROPDMG>mean(SUM_PROPDMG)), aes(EVTYPE, SUM_PROPDMG));
plot <- plot + geom_point(aes(color=EVTYPE)) + theme(legend.position="none", axis.text.x = element_text(angle = 45, hjust = 1, size=7)) +
  labs(x="EVTYPE") + labs(y="total propdmg") + ggtitle("propdmg based on the event type");
print(plot); # just plotting that the propdmg is over mean
#### A: Tornado

### cropdmg
plot <- ggplot(subset(cropdmg,SUM_CROPDMG>mean(SUM_CROPDMG)), aes(EVTYPE, SUM_CROPDMG));
plot <- plot + geom_point(aes(color=EVTYPE)) + theme(legend.position="none", axis.text.x = element_text(angle = 45, hjust = 1, size=7)) +
  labs(x="EVTYPE") + labs(y="total cropdmg") + ggtitle("cropdmg based on the event type");
print(plot); # just plotting that the cropdmg is over mean
#### A: HAIL

