data <- read.csv("zebrafish.csv")

data_long <- reshape(data[2:5],
                     varying = list(names(data[2:5])),
                     v.names = "length_micron",
                     timevar = "alcohol_content_pc",
                     times = c("0.0", "1.5", "2.0", "2.5"),
                     direction ="long")

data_long <- na.omit(data_long)
data_long <- data_long[1:2]
rownames(data_long) <- NULL
