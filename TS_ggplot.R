############################################################################################################
##                                           PLOT RESULTS                                                 ## 
############################################################################################################                           

## ggplot plot for SAVi Time Series Analyis results 
## inputs: 
## - .csv file containing median SAVI measurenments 
## - .csv files containing standard deviation 
## - .csv containing precipitation data 

## output: - pdf with ggplot 


## import libraries 
library(ggplot2)
library(tidyr)
library(dplyr)
library(pals) # for color palette 


## import data sheets  
setwd("C:/Users/49152/Documents/Universitas/Master_EAGLE/Intern_Krueger/VeggyBox/Paper/results/data_tables")

savi <- read.csv("SAVI_monthly_median.csv", sep = ",", header = T)
std <- read.csv("SAVI_monthly_stdDev.csv", sep = ",", header = T)
prec <- read.csv("rainfall_skukuza.csv",sep=";")


## change date format
Sys.setlocale("LC_ALL", "English") # the right time format for English abbreviations

savi$Date <- as.POSIXct(as.Date(savi$date, "%b %d, %Y"), tz = "GMT" )
savi <- subset(savi[2:16])

std$Date <- as.POSIXct(as.Date(std$date, "%b %d, %Y"), tz = "GMT" )
std <- subset(std[2:16])

prec$Date <- as.POSIXct(as.Date(prec$Date, "%d/%m/%Y"))


## change column names 
names(savi) <- c("Grass1","Grass2","Grass3","Grass5","Grass6","Grass7","Grass8","Grass11","Grass12","Grass13",
                 "Grass14","Grass15","Grass9","Grass10","Date")

names(std) <- c("Grass1","Grass2","Grass3","Grass5","Grass6","Grass7","Grass8","Grass11","Grass12","Grass13",
                "Grass14","Grass15","Grass9","Grass10","Date")


## reshape data frames 
savi <- savi %>% pivot_longer(cols=c("Grass1","Grass2","Grass3","Grass5","Grass6","Grass7","Grass8","Grass11","Grass12","Grass13",
                             "Grass14","Grass15","Grass9","Grass10",), 
                    names_to='Grass',
                    values_to='savi')

std <- std %>% pivot_longer(cols=c("Grass1","Grass2","Grass3","Grass5","Grass6","Grass7","Grass8","Grass11","Grass12","Grass13",
                                   "Grass14","Grass15","Grass9","Grass10",), 
                            names_to='Grass',
                            values_to='std')

## join the two data frames 
savi <- savi%>%left_join(std, by = c("Grass", "Date"))

#### GGPLOT ###############################################################################################

## color palette
colours <-watlington(14)


g <- ggplot(NULL, aes(x = Date)) + 
  ## precipitation barplot 
  geom_col(data = prec,  aes(y = rainfall_mm/175), color = "#3761a2", alpha = 0.4) + ## manipulating rainfall data to match the axis of SAVI data 
  ## savi values 
  geom_line(data = savi, aes(x = Date, y = savi, color = Grass), alpha = 0.5, size = 0.8, linetype = 1) +
  geom_point(data = savi, aes(x = Date, y = savi, color = Grass), size = 1.2) +
  ## standart deviation
  geom_ribbon(data = savi, aes(y = savi, ymin = savi - std, ymax = savi + std, fill = Grass), linetype = 0,  alpha = .2, show.legend = F) + 
  ## optional: smoothing function
  #stat_smooth(method = "gam", data = savi, aes(x = Date, y = savi), color = "red") +
  
  ## secondary y-axis
  scale_y_continuous("SAVI",sec.axis = sec_axis(~ . * 175, name = "Rainfall (mm)")) + 
  ## set colours 
  scale_color_manual('SAVI Time Series', values = colours) +
  ## x-axis format
  scale_x_datetime(date_breaks = "4 weeks", date_labels = "%Y-%m")  +
  ## set title 
  labs(title = "SAVI Time Series for experimental grass plots near Skukuza",
       subtitle = "Monthly median values mid 2019 to mid 2023", 
       caption = "SAVI values from Sentinel2 ") + 
  xlab("") + 
  ## theme options
  theme(plot.title = element_text(size = 17,  hjust = 0.02),
        plot.subtitle = element_text(size = 14, hjust = 0.02),
        plot.caption = element_text(size = 12),
        axis.text.x = element_text(vjust = 0.5, hjust = 0.7,size = 13, angle = 90),
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14),
        legend.key = element_rect(fill = "white"),
        legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = 15),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.grid.major.x = element_line("grey70", size = 0.3),
        panel.grid.major.y = element_line(colour = "grey70", size = 0.3),
        panel.grid.minor.x = element_line("grey70", size = 0.3),
        panel.grid.minor.y = element_line(colour = "grey70", size = 0.3),
        axis.ticks.length = unit(0.4, "cm")) +   
 ## break legend into multiple columns 
 guides(color = guide_legend(ncol = 7))


## show plot (doesnt look nice in R preview but when exportet)
g

## export plot as pdf 
ggsave("SAVI_TS_monthly_median_std_prec.pdf",g, width = 25, height = 10)


###################################################################################################
