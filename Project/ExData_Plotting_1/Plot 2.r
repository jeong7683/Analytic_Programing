library(data.table);

consumption <- fread("C:\\Users\\Hyunjin\\Dropbox\\2016³â 2ÇÐ±â\\Analytics Programming\\Data\\household_power_consumption.txt", header=T)[-6840,];
DateTime <- data.frame(strptime(paste(consumption$Date, consumption$Time), format="%d/%m/%Y %H:%M:%S"));
names(DateTime) <- "DateTime";
consumption2 <- data.frame(c(consumption, DateTime));
as.numeric(c2$Global_active_power)

for (i in 3:9) {
  consumption2[,i] <- as.character(consumption2[,i]);
  consumption2[,i] <- as.numeric(consumption2[,i]);
}

consumption3 <- rbind(subset(consumption2, Date==("1/2/2007")), subset(consumption2, Date==("2/2/2007")))

win.graph(200,200);
with(consumption3, plot(DateTime, Global_active_power, type="n", xlab="daytime", ylab="Global Active Power (kilowatts)", axes=F, frame.plot=T));
axis(1, at=c(as.numeric(min(consumption3$DateTime)), as.numeric(min(consumption3$DateTime))+86400,
             as.numeric(min(consumption3$DateTime))+2*86400), labels=c("Thu", "Fri", "Sat"));
axis(2, yaxs="r");
with(consumption3, points(DateTime, Global_active_power, type = "l"));