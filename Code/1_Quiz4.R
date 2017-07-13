library(datasets);
data(iris);
?iris;
head(iris)
tapply(iris$Sepal.Length, iris$Species, mean);

apply(iris,1,mean);
apply(iris[,1:4],1,mean);
colMeans(iris);
rowMeans(iris[,1:4]);
apply(iris,2,mean);
apply(iris[,1:4],2,mean);

data(mtcars);

apply(mtcars, 2, mean)
with(mtcars, tapply(mpg, cyl, mean))
mean(mtcars$mpg, mtcars$cyl)
sapply(split(mtcars$mpg, mtcars$cyl), mean)
lapply(mtcars, mean)
tapply(mtcars$mpg, mtcars$cyl, mean)
tapply(mtcars$cyl, mtcars$mpg, mean)
split(mtcars, mtcars$cyl)
sapply(mtcars, cyl, mean)

abs(mean(mtcars$hp[mtcars$cyl==4])-mean(mtcars$hp[mtcars$cyl==8]))
debug(ls)
