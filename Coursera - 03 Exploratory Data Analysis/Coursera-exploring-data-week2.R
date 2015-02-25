# Coursera-exploring-data-week2.R
# 
# where I work through coursera exploratory data analysis stuff from week 2
# 
# CS O'Connell, UMN EEB/IonE



#####################################################################
# Week 2 Lectures

### lattice

library(lattice)

# xyplot
# bwplot
# histogram
# stripplot
# dotplot
# splom
# levelplot

xyplot(y ~ x | f * g, data)

library(datasets)
# simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)

# multi dimensional pannels can be made really easily in lattice
# e.g., month as factor
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout=c(5,1))

# lattice panel functions
# you can customize what happens in each panel

xyplot(y ~ x | f, panel = function(x,y,...) {
      panel.xyplot(x,y,...) # first call the defaul panel function for xyplot
      panel.abline(h = median(y), lty = 2) # add horizontal line at the median
})

# also possible: panel.lmline(x,y,col=2) # add in simple regression line

# but note that you can't mix functions between plotting systems, so you can only add in functions that apply to lattice

# defaults like margins and spacing are usually good, already set, so you don't have to worry about this like with the base graphic package

# really good for conditioning on variables, make same plot under different conditions


### ggplot2
library(ggplot2)

?qplot # quick plot (workhorse, analogous to plot() in the base plotting system)
?ggplot # core function, can do a lot that qplot can't do

# data always comes from a dataframe
# plots are made of aesthetics (size, color) and geoms (points, lines)

# factor vars are really important in ggplot2
# make sure they are labeled well (not 1,2,3, label with informative labels)

### qplot examples

# qplot basically publication ready
# quick but also really powerful
# customizing is really hard in qplot, use ggplot2 instead

str(mpg)
qplot(displ, hwy, data = mpg)
qplot(displ, hwy, data = mpg, color = drv) # modify aesthetics
qplot(displ, hwy, data = mpg, geom = c("point","smooth")) # add a new geom - points themselves and then the loess smooth
qplot(hwy, data = mpg, fill = drv) # 1 var --> histogram
qplot(hwy, data = mpg, facets = .~drv, binwidth = 2) # facets
qplot(displ, hwy, data = mpg, facets = .~drv) # facets

# can't remake these, but check out some more examples
qplot(log(eno), data = maacs, fill = mopos) # fill by category in a histogram
qplot(log(eno), data = maacs, geom = "density") # density smooth
qplot(log(eno), data = maacs, geom = "density", color = mopos) # density smooth separated out by a factor
qplot(log(pm25),log(eno), data = maacs, color = mopos, geom = c("point", "smooth"), method = "lm") # two linear regressions by mopos factor
qplot(log(pm25),log(eno), data = maacs, geom = c("point", "smooth"), method = "lm", facets = .~mopos) # split out into facets without using colors


### ggplot examples

# you need: 
# data frame
# aesthetic mappings
# geoms
# facets
# stats (smoothing, regressions, etc.)
# scales (what scale an aes uses, like binary males v females, etc.)
# coordinate system

# build a plot using an "artist's palette" model
# add things piece by piece in layers

# example

# qplot way
qplot(logpm25, NocturnalSympt, data = maacs, facets = .~bmicat, gemo = c("point", "smooth"), method = "lm")

# now in ggplot
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
summary(g)
print(g) # can't make a plot yet since there aren't layers teling it how to draw the plot yet
p <- g + geom_point()
print(p)
g + geom_point() # or autoprint

# with smoother
g + geom_point() + geom_smooth() # loess is default
g + geom_point() + geom_smooth(method = "lm") # lm instead
g + geom_point() + facet_grid(.~bmicat) + geom_smooth(method = "lm") # faceted

# annotation
# labels: xlab(), ylab(), ggtitle()
# can modify each geom function
# global things changed via theme(), e.g., theme(legend.position="none")
# theme_gray() vs theme_bw()

# constants vs. vars for aesthetics
g + geom_point(color = "steelblue", size = 4, alpha = 1/2) # alpha = transparency
g + geom_point(aes(color = bmicat), size = 4, alpha = 1/2) # color wrapped in aes here!!! since it's pointing to a variable

# font
g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times")


# axis limits and outliers

testdat <- data.frame(x=1:100,y=rnorm(100))
testdat[50,2] <- 100 # outlier
g <- ggplot(testdat, aes(x=x,y=y))
g + geom_line()

# ggplot subsets out the outlier this way
g + geom_line() + ylim(-3,3)

# no subsetting this way, now outlier is included in the dataset
g + geom_line() + coord_cartesian(ylim=c(-3,3))


# more complex example with adding layers

# categorize variable into a series of ranges

# calc deciles of the data
cutpoints <- quantile(maacs$logno2_new, seq(0,1,length=4), na.rm=TRUE)
# use cut()
# cut the data at the deciles and create a new factor variable
maacs$no2dec <- cut(maacs$logno2_new, cutpoints)
# see the levels
levels(maacs$no2dec)

# set up ggplot with dataframe
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
g + geom_point(alpha=1/3)
+ facet_wrap(bmicat~no2dec, nrow=2, ncol=4)
+ geom_smooth(method="lm", se=FALSE, col="steelblue")
+ theme_bw(base_family="Avenir", base_size=10)
+ labs(x = "xlab")
+ labs(y = "y lab")
+ labs(title="blah")



#####################################################################
# Week 2 Quiz

# Q7

data(airquality)

qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

qplot(Wind, Ozone, data = airquality, geom = "smooth")

# this one
airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

qplot(Wind, Ozone, data = airquality)



# Q10

qplot(votes, rating, data = movies)

qplot(votes, rating, data = movies, panel = panel.loess)

qplot(votes, rating, data = movies, smooth = "loess")

qplot(votes, rating, data = movies) + geom_smooth() # this one

qplot(votes, rating, data = movies) + stats_smooth("loess")


