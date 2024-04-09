
# Instructional Guide for Analysing Zebrafish Embryo Size Dataset

*Robert Treharne*

[Watch the video Walkthrough](https://youtu.be/profkcl3EYo?si=en-0Emc3StpJp0-Q)

This comprehensive guide provides a structured approach to analysing the effects of different concentrations of ethanol on the size of zebrafish embryos using R. It includes steps for preliminary data inspection, statistical analysis, visualisation, and decision-making processes for selecting appropriate tests.

This document serves as an appendix to your *LIFE113: Quantitative Skills* course which does not provide you with the full knowledge required to perform an analysis of the zebrafish dataset.

## Dataset Overview

Your dataset should include measurements of zebrafish embryos' sizes across various concentrations of ethanol solution, with each column representing a different concentration, including a control group.

## Preliminary Steps

### Load the Dataset

```r
dataset <- read.csv("path/to/your/dataset.csv")
```

### Inspect the Dataset

```r
head(dataset)
```

## Statistical Analysis Flow

1. **Start with your dataset**.
2. **Inspect Data**: Understand its structure and check for missing values.
3. **Descriptive Statistics**: Calculate mean, median, and standard deviation for each group.
4. **Check Normality** with Shapiro-Wilk test:
   - **Normal**: Proceed to ANOVA.
   - **Not Normal**: Proceed to Kruskal-Wallis Test.
5. **ANOVA** (if normal):
   - **Significant**: Perform Tukey's HSD for post hoc analysis.
   - **Not Significant**: End analysis.
6. **Kruskal-Wallis Test** (if not normal):
   - **Significant**: Proceed to post hoc analysis with Dunn's Test or Pairwise Mann-Whitney tests with Bonferroni correction.
   - **Not Significant**: End analysis.
7. **Visualize Data**: Use box plots or other relevant visualisations.
8. **Conclusion**: Draw conclusions based on the analyses.

### Descriptive Statistics

```r
# This will calculate, mean and median but NOT standard deviation!
summary <- summary(dataset)

# To calculate standard deviation for each column, you can try something like this:
summary$sd <- sapply(fish_data, sd)

# To view the summary:
print(summary)
```

### Normality Test

The `shapiro.test` function in R performs the Shapiro-Wilk test for normality. The null hypothesis for this test is that the data are drawn from a normal distribution. 

```r
# Apply the Shapiro-Wilk test for normality to each column in the dataset
lapply(dataset, shapiro.test)
```
### Converting from wide to long format

Before we perform any further statistical tests it will be really useful to have data in a *long* format. This makes the coding much easier!

```r
# Convert wide format data to long format for ANOVA/Kruskal-Wallis
long_dataset <- stack(dataset[names(dataset)])
names(long_dataset) <- c("Length", "Group") # Rename columns
```

### ANOVA or Kruskal-Wallis Test

Depending on the outcome of the normality test, choose between ANOVA and Kruskal-Wallis Test. If ANY group in your dataset is non-normal you should proceed with Kruskal-Wallis.

```r
# For normally distributed data
aov_res <- aov(Length ~ Group, data = dataset)
aov_summary <- summary(aov_res)

# For non-normally distributed data
krushkal_res <- kruskal.test(Length ~ Group, data = dataset)
```

### Post Hoc Analysis

#### For ANOVA

```r
TukeyHSD(aov_res)
```

#### For Kruskal-Wallis

```r
# Assuming `dunn.test` package is installed and loaded for Dunn's test
dunn_test_long <- dunn.test(
    dataset$Size, dataset$Group, method="bonferroni"
    )
```

OR

```r
pairwise_wilcox_long <- pairwise.wilcox.test(
  long_fish_data$Length,
  long_fish_data$Group,
  p.adjust.method = "bonferroni"
  )
```

## Visualisation

### Box Plots

```r
boxplot(fish_data$ethanol_conc_0, fish_data$ethanol_conc_1.5, fish_data$ethanol_conc_2, fish_data$ethanol_conc_2.5,
    names = c("0%", "1.5%", "2%", "2.5%"),
    xlab = "Ethanol Concentration", ylab = "Length (microns)")
```

## Conclusion

This guide, with its structured approach to statistical analysis and visualisation, enables researchers to identify significant effects of ethanol concentration on zebrafish embryo size, ensuring informed conclusions are drawn from the data.



