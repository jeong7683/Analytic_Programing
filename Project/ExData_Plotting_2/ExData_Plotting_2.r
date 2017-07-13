library(dplyr);
library(ggplot2);
library(sqldf);

## Read RDS File ##

NEI <- readRDS("C:\\Users\\Hyunjin\\Dropbox\\2016년 2학기\\Analytics Programming\\Data\\summarySCC_PM25.rds");
SCC <- readRDS("C:\\Users\\Hyunjin\\Dropbox\\2016년 2학기\\Analytics Programming\\Data\\Source_Classification_Code.rds");


## Q1 ##
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

total_emission <- sqldf('select year,
                         sum(Emissions) as "total_emission"
                         from NEI
                         group by year
                         order by year');


with(total_emission, plot(year, total_emission, type="n", xaxt="n", yaxt="n",
                    main="Total Emissions of PM2.5 in the United States",
                    ylab="Total Emissions (million tons)", xlab="Year",
                    xlim=c(1999,2008), ylim=c(3,8)*10^6) );

with(total_emission, lines(year, total_emission));
axis(1, c(1999,2002,2005,2008), las=0);
axis(2, at=3:8*10^6, labels=3:8, las=1);


## Q2 ##
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Use the base plotting system to make a plot answering this question.

Baltimore_NEI <- subset(NEI, fips=="24510");
total_emission_b <- sqldf('select year,
                         sum(Emissions) as "total_emission"
                         from Baltimore_NEI
                         group by year
                         order by year');

with(total_emission_b, plot(year, total_emission, type="n", xaxt="n", yaxt="n",
                          main="Total Emissions of PM2.5 in Baltimore City",
                          ylab="Total Emissions (tons)", xlab="Year",
                          xlim=c(1999,2008)));

with(total_emission_b, lines(year, total_emission));
axis(1, c(1999,2002,2005,2008), las=0);
axis(2, las=1);


## Q3 ##
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999???2008 for Baltimore City?
# Which have seen increases in emissions from 1999???2008? Use the ggplot2 plotting system to make a plot answer this question.

total_emission_b2 <- sqldf('select year, type,
                         sum(Emissions) as "total_emission"
                         from Baltimore_NEI
                         group by year, type
                         order by year, type');

plot <- ggplot(total_emission_b2, aes(year, total_emission));
plot <- plot + geom_line(aes(color=type));
plot <- plot + xlab("Year") + ylab("Total Emissions (tons)");
plot <- plot + ggtitle("Emissions of PM2.5 in the Baltimore City by 4 Types");
print(plot);


## Q4 ##
# Across the United States, how have emissions from coal combustion-related sources changed from 1999???2008?

Coal <- SCC %>% mutate(Match = ifelse(grepl("Coal", EI.Sector, ignore.case = T), "Yes", "NO")) %>% filter(Match=="Yes");
Coal_NEI <- NEI[NEI$SCC %in% Coal$SCC,];

total_emission_coal <- sqldf('select year,
                          sum(Emissions) as "total_emission"
                          from Coal_NEI
                          group by year
                          order by year');

plot <- ggplot(total_emission_coal, aes(year, total_emission/1000)); # unit: 1000 tons
plot <- plot + geom_line(color="black") + 
    labs(x="Year") + labs(y="Total Emissions (thousand tons)") + ggtitle("Total Emissions of PM2.5 from Coal Combustion-Related Sources");
print(plot);


## Q5 ##
# How have emissions from motor vehicle sources changed from 1999???2008 in Baltimore City?

Vehicle <- SCC %>% mutate(Match = ifelse(grepl("Mobile", EI.Sector, ignore.case = T), "Yes", "NO")) %>% filter(Match=="Yes");
Vehicle_NEI <- NEI[NEI$SCC %in% Vehicle$SCC,];
Baltimore_Veh_NEI <- subset(Vehicle_NEI, fips=="24510");

total_emission_veh_b <- sqldf('select year,
                            sum(Emissions) as "total_emission"
                            from Baltimore_Veh_NEI
                            group by year
                            order by year');

plot <- ggplot(total_emission_veh_b, aes(year, total_emission));
plot <- plot + geom_line(color="black") + 
  labs(x="Year") + labs(y="Total Emissions (tons)") + ggtitle("Total Emissions of PM2.5 from Motor Vehicle Sources in Baltimore");
print(plot);


## Q6 ##
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

LA_Veh_NEI <- subset(Vehicle_NEI, fips=="06037");

total_emission_veh_LA <- sqldf('select year,
                                sum(Emissions) as "total_emission"
                                from LA_Veh_NEI
                                group by year
                                order by year');

total_emission_veh_b$region = "Baltimore City";
total_emission_veh_LA$region = "Los Angeles County";

# Normalization (because the question is "Which city has seen greater changes over time in motor vehicle emissions?")
for (i in 1:4) {
  total_emission_veh_b$norm_emission[i] <- total_emission_veh_b$total_emission[i]/total_emission_veh_b$total_emission[1];
  total_emission_veh_LA$norm_emission[i] <- total_emission_veh_LA$total_emission[i]/total_emission_veh_LA$total_emission[1];
}

total_emission_veh_b_LA <- rbind(total_emission_veh_b, total_emission_veh_LA);


plot <- ggplot(total_emission_veh_b_LA, aes(year, norm_emission));
plot <- plot + geom_line(aes(color=region)) + 
  labs(x="Year") + labs(y="Normalized Emission") + ggtitle("Total Emissions from Motor Vehicle in Baltimore and LA (Normalized)");
print(plot);
