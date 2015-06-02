library(ggplot2)

vignette(package = "ggplot2")

head(crime_ag)

df <- lnd@data

head(df)

plot(df$Pop_2001, df$CrimeCount)

qplot(Pop_2001, CrimeCount, data = df)

ggplot(df) +
  geom_point(aes(Pop_2001, CrimeCount, colour = Partic_Per)) +
  geom_line(aes(Pop_2001, Partic_Per * 1000)) +
  geom_smooth(aes(Pop_2001, CrimeCount)) +
  # geom_point(aes(Month, CrimeCount), data = crime_data, colour = "blue") +
  scale_colour_continuous(low = "green", high = "violet")
  

