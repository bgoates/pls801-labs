############# setup
# clean up existing objects
# this basically clears out our workspace and removes stuff from our environment
# you can also just use the broom icon in your environment -- to each their own
rm(list=ls())

# load in necessary packages
library(tidyverse)

# define ggplot theme - we're creating a function for this, but it's not necessary
# smTheme is basically allowing us to customize ggplot
smTheme = function(){
  theme_bw() + # setting the theme to black and white, no color 
    theme( 
      panel.border = element_blank(), # removing the box around our plot
      axis.ticks = element_blank(), # removing the tick marks
      legend.position = 'top' # putting the legend at the top 
    )
}
#############

#############
# load in our dataset
# the path is relative: run this script with the working directory set to
# this lab's folder (in RStudio: Session > Set Working Directory > To Source File Location),
# so the data load from, and the plots save to, this folder
lifeExp = read_csv("life_exp.csv")
#############

#############
# descriptive stats for numeric variables
# remember, the piping function lets us chain together multiple operations
# apparently the new pip function is |>...idc what you use 
lifeExp %>% 
# we only want to see the population and gdpPercap columns from our dataframe  
  select(pop, gdpPercap) %>%
# we just want to see some summary stats for pop and gdpPercap  
  summarize(
# na.rm = TRUE is super useful 
# we are telling R that we want to see the mean and med of our pop & gdpPercap vars, 
# but we want R to ignore any missing values that may skew our data  
    popMean = mean(pop, na.rm=TRUE),
    popMedian = median(pop, na.rm=TRUE),
    gdpPercapMean = mean(gdpPercap, na.rm=TRUE),
    gdpPercapMedian = median(gdpPercap, na.rm=TRUE)
  )

# ok, great. 
# now, what if we wanted to calculate the mean for lifeExp as well? 
# writing that out would be exhausting but we can restructure our
# data to make life easier

# here, we're using a new function called pivot_longer()
# it transforms our data from a "wide" to a "long" format
# this means it increases the number of rows and decreases the number of columns
# you can also do the inverse by using pivot_wider()
# basically, these are ways that make data manipulation way easier
# it also makes data visualization easier too 

# making a new var, pulling info from our dataset 
lifeExpLongIntVars = lifeExp %>%
# reshaping the data from a wide format to a long format so that the data is 
# collapsed into fewer columns 
  pivot_longer(
# specifying the columns we want pivoted into a longer format 
    cols=lifeExp:gdpPercap 
  ) %>%
# filters our data to keep only the rows where the name column matches the 
# vars we are interested in    
  filter(
# keeps only the rows where the name column matches pop, gdpPercap, lifeExp
    name %in% c('pop', 'gdpPercap', 'lifeExp') 
  )

# and now we can use group by when summarizing to view of the data
# this shows us the mean and median values of the var represented in the name column
lifeExpLongIntVars %>% 
  group_by(name) %>% 
  summarize(
    average = mean(value), 
    middle = median(value)
  )
#############

#############
# cool cool. now we want to see what all this stuff looks like. no one really cares about 
# numbers and values, we want to see pretty plots and graphs. 
# so, lets do some descriptive visualizations

# visualize histograms 1, and we will name is lifeExpHist
lifeExpHist = ggplot(lifeExpLongIntVars, aes(x=value)) +
# we are adding a histogram layer to our plot so see the distribution of our continuous var
  geom_histogram(color='white') + # changes the color of our bins
# creates separate histograms for each value in our name column, 
# so pop, gdpPercap, lifeExp get seperate subplots
  facet_wrap(~name, scales='free') + # scales just means each subplot gets its own x and y axis values
  smTheme()
# now, we want to save this plot so we can add it to a presentation/paper!
ggsave(
  lifeExpHist, 
# this is the code to save our plots directly to our file path
  file='hist_default.png', dpi=600, width=10, height=4) 

# visualize histograms too many bins
ggplot(lifeExpLongIntVars, aes(x=value)) +
  geom_histogram(bins=100) +
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='hist_tooMany.png', dpi=600, width=10, height=4)

# visualize histograms too few bins
ggplot(lifeExpLongIntVars, aes(x=value)) +
  geom_histogram(bins=3, color='white') + # bins changes the number of bins we see!
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='hist_tooFew.png', dpi=600, width=10, height=4)

# visualize 2
ggplot(lifeExpLongIntVars, aes(x=value)) +
# same kinda thing as above, but we want to see some density
  geom_density() +
# same thing as above, we want different plots for pop, gdpPercap, lifeExp
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='dens_default.png', dpi=600, width=10, height=4)

# visualize 3
ggplot(lifeExpLongIntVars, aes(x=value)) +
  geom_histogram(
    aes(y=after_stat(density)),
    bins=30, color='white'
  ) +
# this makes the lines thicker 
  geom_density(lwd = 2) +
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='hist_dens.png', dpi=600, width=10, height=4)
#############

#############
# cool, now we know what our data looks like
# now we want to create some categorical variables from numeric variables

# first population
# we'll use a new function called cut() that allows us to cut
# data into bins and specify the labels in our cuts
# super useful to create a factor from a continuous variable 

# save this so R knows where to cut, the 1st & 3rd quartiles  
popQts = quantile(lifeExp$pop, probs=c(0.25, 0.75)) 

lifeExp = lifeExp %>%
  mutate(
# cut -- used to divide the pop variable into categories 
    popLevel = cut(
      pop, 
# negative and positive infinity 
      breaks = c(-Inf, popQts, Inf), # the cuts we want
# 1 = lifeExp below the 1st quart, 2 = between the 1st and 3rd quart, and 3 = above the 3rd quart 
      labels = c(1, 2, 3) # what we'll label each value
    )
  )

# check to make sure it looks like we did things right
lifeExp %>% 
  group_by(popLevel) %>% 
  summarize(mean(pop, na.rm=TRUE))

# now we are going to do the same thing but with  income, or in our case, gdpPercap
gdpcapQts = quantile(lifeExp$gdpPercap, probs=c(0.25, 0.75))

lifeExp = lifeExp %>%
  mutate(
    gdpcapLevel = cut(
      gdpPercap, 
      breaks = c(-Inf, gdpcapQts, Inf),
      labels = c(1, 2, 3)
    )
  )

# check to make sure it looks like we did things right
lifeExp %>% 
  group_by(gdpcapLevel) %>% 
  summarize(mean(gdpPercap, na.rm=TRUE))
#############

#############
# descriptive statistics for categorical variables

# for some reason there is no base r function for mode
# but keep in mind that the mode of a variable is simply
# equal to the value that occurs most in that variable

# there are a number of ways to calculate it
# one way could be to use the table function to get
# a frequency count 
# (notice that table is a function from base R not the 
# tidyverse, so when trying to apply it to a variable
# from the lifeExp data.frame we have to use 
# the $ syntax)
table(lifeExp$gdpcapLevel)

# a quick visual glance shows you that
# the 2 category in gdpcapLevel has 852 values so the
# mode of gdpcapLevel is equal to 2

# note that taking the mode of a continuous variable
# is pretty pointless, why?
# bc the mode is more useful for categorical or discrete data, 
# where repeated values are common and meaningful, 
# but it doesn't provide much insight for continuous data where values rarely repeat 
table(lifeExp$gdpPercap)

# there are functions that you will find on the web
# for calculating the mode, they will typically look
# like this
mode = function(x) {
  # get out unique values
  u <- unique(x) 
  # count up instances of unique values in 
  # the vector x
  tab <- tabulate(match(x, u)) 
  # return only one value that is the mode
  out = u[tab == max(tab)]
  return(out)
}

# and if we apply it to gdpcapLevel we'll see that we get the same answer
mode(lifeExp$gdpcapLevel)
table(lifeExp$gdpcapLevel)

# and as before we can now restructure our data
# to see the most common values that exist
# in our data for continent, gdpcapLevel, and popLevel
lifeExpLongCatVars = lifeExp %>%
  pivot_longer(
    cols=c(continent, popLevel, gdpcapLevel)
  )  

# and now lets calculate the mode for each
# of these categorical variables
lifeExpLongCatVars %>%
  group_by(name) %>%
  summarize(
    mostFreq = mode(value)
  )
#############

#############
# cool cool. now we want to see some descriptive visualizations for categorical variables

# barplot viz
ggplot(lifeExpLongCatVars, aes(x=value)) +
  geom_bar() +
  facet_wrap(~name, scales='free')
ggsave(file='bar_default.png', dpi=600, width=10, height=4)
#############

#############
# comparing categorical-categorical variables

# lets create a categorical version of life expectancy
# so we can ask somewhat more reasonable questions
# and make our lives easier for when we want to compare lifeExp within our data
lifeExpQts = quantile(lifeExp$lifeExp, probs=c(0.25, 0.75))
lifeExp = lifeExp %>%
  mutate(
    lifeExpLevel = cut(
      lifeExp, 
      breaks = c(-Inf, lifeExpQts, Inf),
      labels = c(1, 2, 3)
    )
  )

# now lets run a cross-tab between lifeExpLevel and gdpcapLevel
# this kinda table helps us understand the rel bw these vars
table(lifeExp$lifeExpLevel, lifeExp$gdpcapLevel, useNA='always')
# interpretation: the combo of category 2 for lifeExpLevel and category 2 for 
# gdpcapLevel (Row 2, Column 2) is the most frequent with 591 occurrences
# the combo of category 3 for lifeExpLevel and category 1 for the gdpcapLevel 
# (Row 3, Column 1) doesn't occur at all (value = 0).

# stacked bar plot
ggplot(lifeExp, aes(x=lifeExpLevel, fill=gdpcapLevel)) +
  geom_bar() +
  smTheme()
ggsave(file='cat_cat_stack.png', dpi=600, width=10, height=4)
# interpretation: a pos corr btw higher GDP per capita and higher life expectancy 

# another way to visualize, a dodged bar pot
ggplot(lifeExp, aes(x=lifeExpLevel, fill=gdpcapLevel)) +
  geom_bar(position='dodge') +
  smTheme()
ggsave(file='cat_cat_dodge.png', dpi=600, width=10, height=4)
#############

#############
# comparing categorical-continuous variables

# lets start by comparing a nominal variable 
# and a continuous variable, specifically, 
# continent and lifeExp and continent and 
# lifeExp and gdpPercap

# first lets select variables and restructure
# our data
contCatData = lifeExp %>%
  select(continent, lifeExp, gdpPercap) %>%
  pivot_longer(
    cols = lifeExp:gdpPercap
  )

# and now lets get some summary stats
# and store the result in an object
# so that we can plot with it afterwards
contCatDataAvg = contCatData %>%
  group_by(continent, name) %>%
  summarize(
    average = mean(value),
    middle = median(value)
  )

# lets visualize 

# dot plot
# we are comparing 'middle' varies across different continents for multiple categories
ggplot(contCatDataAvg, aes(x=continent, y=middle)) +
  geom_point(size=2) + 
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='cont_cat_dot.png', dpi=600, width=10, height=4)

# just another way to visualizae, a bar plot
ggplot(contCatDataAvg, aes(x=continent, y=middle)) +
  geom_bar(stat='identity') + 
  facet_wrap(~name, scales='free') +
  smTheme()
ggsave(file='cont_cat_bar.png', dpi=600, width=10, height=4)
#############

#############
# comparing continuous-continuous variables

# we're going to get to statistical ways to understand
# how two (or more) continous variables are related to one
# another but for now lets focus on visualization

# lets start by just scattering gdp per capita and life expectancy
ggplot(lifeExp, aes(x=log(gdpPercap), y=lifeExp, color=continent)) +
  geom_point() +
  smTheme()
ggsave(file='cont_cont.png', dpi=600, width=10, height=4)
#############
