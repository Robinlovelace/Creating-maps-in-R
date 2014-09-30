# Loading and cleaning the data
library(readODS) # library to load Open Office documents
setwd("~/Dropbox/Cornerstone Reunion/") # navigate to reunion folder
d <- read.ods("Cornerstone reunion invitations.ods")[[1]]
d[1:2,] # take a look at data we've loaded
d <- d[-1,]
head(d)
d <- d[c(2,3,4,14)]
d[3:4] <- apply(d[3:4], 2, FUN = as.numeric)
names(d) <- c("First.name", "Second.name", "From", "Until")
d <- d[! is.na(d$From),] # remove people with no dates

d$Name <- paste(d$First.name, d$Second.name, sep = " ")
d$Name <- factor(d$Name, levels = d$Name[order(d$From, decreasing = T)], ordered = T)

library(ggplot2)
# Preliminary plot of the data
theme_chc <-
  theme(panel.background = element_blank(),
    panel.grid.major =
      element_line(colour = "grey", linetype = 3))

ggplot(d) + geom_segment(aes(x = From, xend = Until, y = Name, yend = Name ), size = 2) +
  theme(axis.title = element_blank()) + theme_chc
ggsave("prelim-time-plot.pdf", height = 30, width = 21, units = "cm")

# Divide into 2 parts (failed)
d$era <- "2000 +"
d$era[ d$From < 2000 ] <- "1990s"

# Replot
d$Until2 <- d$Until
d$Until2[d$Until > 2003] <- 2003

(a <- ggplot(d[d$From < 2003, ]) + geom_segment(aes(x = From, xend = Until2, y = Name, yend = Name ), size = 2) +
  theme(axis.title = element_blank()) + theme_chc +
  xlim(c(1993, 2002)) +
  scale_x_continuous(breaks = c(1995, 1998, 2003))
)

d$From2 <- d$From
d$From2[d$From2 < 2003] <- 2003

(b <- ggplot(d[ d$Until > 2003, ]) +
    geom_segment(aes(x = From2, xend = Until, y = Name, yend = Name ), size = 2) +
  theme(axis.title = element_blank()) + theme_chc +
  scale_x_continuous(breaks = c(2003, 2008, 2013))
  )

library(gridExtra) # join together 2 graphs
gridExtra::grid.arrange(a,b, ncol=2)
g <- arrangeGrob(a,b, ncol=2)
ggsave("prelim-time-plot2.pdf", height = 30, width = 21, units = "cm", g)
