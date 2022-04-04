library(tidyverse)
library(sf)
library(fmi2)

kaisaniemi_data <- obs_weather_daily(starttime = "2022-02-01",
                                     endtime = "2022-02-28",
                                     fmisid = 100971)

jyvaskyla_data <- obs_weather_daily(starttime = "2022-02-01",
                               endtime = "2022-02-28",
                               fmisid = 101339)

nuorgam_data <- obs_weather_daily(starttime = "2022-02-01",
                                  endtime = "2022-02-28",
                                  place = "Nuorgam")

jyvaskyla_data$location <- "Jyväskylä"
nuorgam_data$location <- "Nuorgam"
kaisaniemi_data$location <- "Helsinki Kaisaniemi"

all_data <- rbind(kaisaniemi_data, jyvaskyla_data, nuorgam_data)

all_data <- all_data %>% 
  dplyr::mutate(location = factor(location, 
                                  levels = c("Nuorgam", "Jyväskylä", "Helsinki Kaisaniemi"),
                                  ordered = TRUE))

all_data %>% 
  dplyr::filter(variable == "rrday" & !is.na(value)) %>% 
  ggplot(aes(x = time, y = value, color = variable)) + 
  ggtitle("Precipitation (mm) in February 2022") +
  geom_line() + facet_wrap(~ location, ncol=1) + ylab("Precipitation amount (mm)\n") +
  xlab("\nDate") + theme(legend.position="none", axis.title.y = element_blank()
)

# Note, dpi should be bigger
ggsave("rain.png", width = 10, height = 12, dpi = 70, units = "cm", device = 'png')
