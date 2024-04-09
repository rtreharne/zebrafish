# Load the dataset
fish_data <- read.csv("fabricated_fish_data.csv", header=TRUE)

# Inspect the dataset
head(fish_data) # Display the first few rows of the dataset

# Descriptiv statistics
summary <- summary(fish_data)

# Add standard deviation to summary
summary$sd <- sapply(fish_data, sd)


# Perform Shapiro-Wilk Normality Test
normality_tests <- lapply(fish_data, shapiro.test)
print("Normality Test Results:")
print(normality_tests)

# Convert wide format data to long format for ANOVA/Kruskal-Wallis
long_fish_data <- stack(fish_data[names(fish_data)])
names(long_fish_data) <- c("Length", "Group") # Rename columns

# If data is normal, perform ANOVA
anova_res = aov(Length ~ Group, data = long_fish_data)
anova_summary <- summary(anova_res)
print(anova_summary)

# Perform post-hoc tests for ANOVA (TukeyHSD)
tukey_res <- TukeyHSD(anova_res)
print(tukey_res)

# For non-normally distributed data
# Perform Kruskal-Wallis Test
kruskal_res <- kruskal.test(Length ~ Group, data = long_fish_data)

# Print results of Kruskal-Wallis Test
print("Kruskal-Wallis Test Result:")
print(kruskal_res)


# Post-hoc analysis: Since base R does not have a direct equivalent to Dunn's test for post-hoc analysis
# following a Kruskal-Wallis test, I suggest performing pairwise comparisons using Wilcoxon rank sum test with Bonferroni correction.
# Here's how you can do it:
pairwise_wilcox_long <- pairwise.wilcox.test(
  long_fish_data$Length,
  long_fish_data$Group,
  p.adjust.method = "bonferroni")

# Print results of pairwise comparisons
print("Pairwise Comparisons (Wilcoxon) with Bonferroni Correction:")
print(pairwise_wilcox)

# Generating a boxplot
boxplot(Length ~ Group, data=long_fish_data,
        names = c("0%", "1.5%", "2%", "2.5%"),
        xlab = "Ethanol Concentration", ylab = "Length (microns)")
