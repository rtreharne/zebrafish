data <- read.csv("zebrafish.csv")

data_long <- reshape(data[2:5],
                     varying = list(names(data[2:5])),
                     v.names = "length_micron",
                     timevar = "alcohol_content_pc",
                     times = c("0.0", "1.5", "2.0", "2.5"),
                     direction ="long")

# Get rid of all the NA values
data_long <- na.omit(data_long)

# Get rid of the random "id" end column
data_long <- data_long[1:2]

# Reset the index of your dataframe (don't need to but it looks nicer)
rownames(data_long) <- NULL

# Generate a boxplot
boxplot(length_micron ~ alcohol_content_pc, data_long)

# Subset the data so that it only contains rows or alcohol_content_pcs of 0% and 2.5% (or any other % you choose)
sub <- subset(data_long, data_long$alcohol_content_pc == "0.0" | data_long$alcohol_content_pc == "2.5")

# Perform your t-test on these two groups
t.test(length_micron ~ alcohol_content_pc, sub)

# How about a boss histogram?
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
  labs(x="Length (micron)", y="Frequency")
