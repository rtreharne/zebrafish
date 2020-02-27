data <- read.csv("zebrafish.csv", header=T)


data_long <-reshape(data[2:5],
                      varying = list(names(data[2:5])),
                      v.names = "length_micron",
                      timevar = "alcohol_content_pc",
                      times = c("0.0", "1.5", "2.0", "2.5"),
                      direction = "long")

data_long <- na.omit(data_long)
data_long <- data_long[1:2]
rownames(data_long) <- NULL

hist(data_long$length_micron)

group_1 = subset(data_long, data_long$alcohol_content_pc=="0.0" | data_long$alcohol_content_pc=="2.5")

t.test(length_micron ~ alcohol_content_pc, group_1)

# https://www.datanovia.com/en/blog/how-to-create-histogram-by-group-in-r/

library(ggplot2)
theme_set(
  theme_classic() + 
    theme(legend.position = "top")
)

# Change line color by alcohol content
ggplot(data_long, aes(x = length_micron)) +
  geom_histogram(aes(color = alcohol_content_pc, fill=alcohol_content_pc),
                 position = "identity", bins = 30, alpha = 0.4) +
  scale_color_manual(values = c("red", "yellow", "green", "blue")) +
  scale_fill_manual(values = c("red", "yellow", "green", "blue")) +
  labs(x="Length (micron)", y="Frequency", fill="Alcohol concentration (%)")
