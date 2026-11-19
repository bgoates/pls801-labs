############
set.seed(6886)
############

############
# run with the working directory set to this folder
load('fish.RData')
############

############
library(modelsummary)
library(marginaleffects)
library(ggplot2)
############

############
# take a peek at the fish data
head(fish)

#
summary(fish)
############

############
# main model in fish's paper
mod = lm(
  fhrev ~
    muslim + income + elf + growth +
    britcol + postcom + opec, data=fish)
summary(mod)
############

library(marginaleffects)

plot_predictions(
  mod, 
  condition='elf',
  points=1
)

plot_predictions(
  mod, 
  'muslim'
)

############
# lets talk about graphical interpretation approaches

# say that you want to visualize the predicted difference between
# some of the binary variables in the model above

# we could try using jtools first
library(jtools)

# effect_plot example
effect_plot(
  model=mod,
  pred=muslim,
  interval=TRUE,
  int.type='confidence',
  plot.points=TRUE
)

# to some extent this plot makes no sense
# the model is making predictions about the
# dv between values of 0 and 1, when
# muslim is a binary variable, how would
# we make this plot ourselves?

# lets actually pivot towards a simpler plot
# so lets say that we want to understand the effect
# of being muslim for the "average" case
scenMuslim = c(
  intercept=1,
  muslim = 1,
  income = mean(fish$income),
  elf = mean(fish$elf),
  growth = mean(fish$growth),
  britcol = median(fish$britcol),
  postcom = median(fish$postcom),
  opec = median(fish$opec) )

scenNonMuslim = c(
  intercept=1,
  muslim = 0,
  income = mean(fish$income),
  elf = mean(fish$elf),
  growth = mean(fish$growth),
  britcol = median(fish$britcol),
  postcom = median(fish$postcom),
  opec = median(fish$opec) )

# lets get some predictions
# based on SCENARIOS
scen = rbind(scenMuslim, scenNonMuslim)
scen = data.frame(scen)
muslimPreds = predict(mod, newdata=scen, interval='confidence')

#
muslimPreds = data.frame(muslimPreds)
muslimPreds$muslim = c('Muslim Country', 'Non-Muslim Country')
fish$muslimLab = 'Non-Muslim Country'
fish$muslimLab[fish$muslim==1] = 'Muslim Country'

#
fish$cntryLab = NA
fish$cntryLab[fish$country=='UAE'] = 'UAE'
fish$cntryLab[fish$country=='Peru'] = 'Peru'
fish$cntryLab[fish$country=='Mali'] = 'Mali'

#
ggplot(muslimPreds, aes(x=muslim, y=fit)) +
  geom_point() +
  geom_linerange(aes(ymin=lwr, ymax=upr)) +
  labs(
    x='',
    y='Predicted Democracy Scores (avg case)'
  )  +
  geom_jitter(
    data=fish,
    aes(x=muslimLab, y=fhrev),
    width = 0.2, alpha=.3
  ) +
  theme_bw()
############

############
# do we really have to do it ourselves? nope!
# lets use the marginaleffects package
library(marginaleffects)

# one thing we need to do though before we create the same
# plot using this package
# we need to give a way for marginal effects to understand
# that muslim is a binary variable and not continous

# this requires making a change the variable in the 
# data.frame itself, specifically, we will use the
# factor() function to convert muslim to a factor
fish$muslim = factor(fish$muslim)

# need to do this for the other
# categorical variables as well
fish$britcol = factor(fish$britcol)
fish$postcom = factor(fish$postcom)
fish$opec = factor(fish$opec)

# now lets run the model again
mod = lm(
  fhrev ~
    muslim + income + elf + growth +
    britcol + postcom + opec, data=fish)

# and now lets feed it into the plot_cap
# function in the marginaleffects package
plot_predictions(
  mod,
  condition='muslim'
)

# 
plot_predictions(
  mod, 
  condition='growth',
  points=1
)

# woah, right!?
# we'll keep exploring this package in 
# subsequent r scripts
############

############
# moving onto an example involving a polytonomous
# variable (ie, number of categories more than 2)

# NOTE: gdpRegions.rda is not included in this repository, so this
# section only runs if you add the file to this folder.
if (file.exists('gdpRegions.rda')) {
# load data
load(file='gdpRegions.rda')

# convert to factor
gdpRegions$region = factor(gdpRegions$region)
gdpRegions$region = relevel(gdpRegions$region, ref='North America')

# run model 1
mod =lm(NY.GDP.PCAP.KD ~ region, data=gdpRegions)
summary(mod)

# suppress  intercept
mod =lm(NY.GDP.PCAP.KD ~ region-1, data=gdpRegions)
summary(mod)
}
############

############
# model as categorical or continuous?
# NOTE: income.rda is not included in this repository, so this
# section only runs if you add the file to this folder.
if (file.exists('income.rda')) {
load(file='income.rda')

# unit of observation: individual
# educCat1: binary, where 1 indicates no high school degree
# educCat2: binary, where 1 indicates high school degree
# educCat3: binary, where 1 indicates college degree
# educCat: ordinal version, where 1=no high school, 2=high school, 3=college
# pWealth: level of parent's wealth
# income: individual's income level

# so lets first run a model in which 
# we assume that there is a linear, proportional relationship
# between educCat and income when controlling for pWealth
income$educCat = as.numeric(as.character(income$educCat))

# lets run a model
modCont = lm(income ~ educCat + pWealth, data=income)

# 
summary(modCont)

# lets see what we would get if instead we modeled
# educCat as an ordinal categorical variable
income$educCat = factor(income$educCat)

# now lets run a model in which we use dummies instead
modDumm = lm(income ~ educCat + pWealth - 1, data=income)

# 
summary(modDumm)
}
############

############
# lets also practice using the wdi dataset from day 2
# WDI data from Lab 3 (the same variables as the wdi.rda used in class)
wdi = read.csv('wdiOrig.csv')

# some variable transformations
wdi$gdpCapLog = log(wdi$gdp_pc)
wdi$prop_rural = (wdi$pop_rural/wdi$pop_tot)*100

# lets run some models
naive = lm(life_exp ~ gdpCapLog + prop_rural, data=wdi )
mod = lm(life_exp ~ gdpCapLog + prop_rural + factor(year)-1, data=wdi)

mod2 = lm(life_exp ~ gdpCapLog + prop_rural + factor(country)-1, data=wdi)

#
summary(naive)$'coefficients'
summary(mod)$'coefficients'
summary(mod2)$'coefficients'

#
mod = lm(life_exp ~ gdpCapLog + prop_rural + year-1, data=wdi)

#
summary(mod)
############