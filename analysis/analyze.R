#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

d = read.csv(file="io500.csv", header=TRUE)
figsize = c(20,10)

# Performance per rank
d = d[order(d$io500__score, decreasing=TRUE),]

g = ggplot(d, aes(x=1:nrow(d), y=io500__score)) +
  geom_point(aes(col=log10(io500__bw), size=log10(io500__md))) +
  geom_smooth(method="loess", se=F) +
  scale_color_gradientn(colours = rainbow(3)) + scale_y_log10() +
  #xlim(c(0, 0.1)) +
  #ylim(c(0, 500000)) +
  labs(x="Rank #", y="IO-500 Score", title="Performance per rank")
ggsave("all-Performanceperrank.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

d$perThread = d$io500__score / d$information__client_total_procs
g = ggplot(d, aes(x=1:nrow(d), y=perThread)) +
  geom_point(aes(col=information__filesystem_type)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="Performance per process")
ggsave("all-performancePerProcess.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

g = ggplot(d, aes(x=information__filesystem_type, y=perThread)) +
  geom_boxplot() +
  labs(x="Rank #", y="IO-500 Score per Process", title="File system performance per process")
ggsave("all-performancePerProcess-fs.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)


# Scatterplot
g = ggplot(d, aes(x=information__filesystem_type, y=io500__score)) +
  geom_point(aes(col=log10(io500__bw), size=log10(io500__md))) +
  scale_color_gradientn(colours = rainbow(3)) + scale_y_log10() +
  #xlim(c(0, 0.1)) +
  #ylim(c(0, 500000)) +
  labs(x="File system", y="IO-500 Score", title="Overview per file system")
plot(g)

g = ggplot(d, aes(x=io500__bw, y=io500__md)) +
  geom_point(aes(col=information__filesystem_type)) +
  scale_y_log10() + scale_x_log10() +
  labs(x="IO-500 BW", y="IO-500 MD", title="Scores")
plot(g)


g = ggplot(d, aes(x=information__filesystem_type, y=io500__score)) +
  geom_boxplot() +
  labs(x="File system", y="IO-500 Score", title="Score per file system")
plot(g)


g = ggplot(d, aes(x=information__filesystem_type, y=io500__md)) +
  geom_boxplot() +
  labs(x="File system", y="IO-500 Metadata", title="Metadata Score per file system")
plot(g)

g = ggplot(d, aes(x=information__filesystem_type, y=io500__bw)) +
  geom_boxplot() +
  labs(x="File system", y="IO-500 Bw", title="Bandwidth Score per file system")
plot(g)

# information__ds_storage_type
# ggsave(g, "x.png")


# 10 Node analysis
t = d %>% filter(information__client_nodes==10)
g = ggplot(t, aes(x=information__filesystem_type, y=io500__score)) +
  geom_boxplot() +
  labs(x="File system", y="IO-500 Score", title="Score per file system")
plot(g)

# Performance per rank
t = t[order(t$io500__score, decreasing=TRUE),]
g = ggplot(t, aes(x=1:nrow(t), y=io500__score)) +
  geom_point(aes(col=log10(io500__bw), size=log10(io500__md))) +
  geom_smooth(method="loess", se=F) +
  scale_color_gradientn(colours = rainbow(3)) + scale_y_log10() +
  labs(x="Rank #", y="IO-500 Score", title="10 Node Challenge -- Performance per rank")
ggsave("10N-Performanceperrank.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

# Performance per thread
t$perThread = t$io500__score / t$information__client_total_procs
g = ggplot(t, aes(x=1:nrow(t), y=perThread)) +
  geom_point(aes(col=information__filesystem_type)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="10 Node Challenge -- Performance per Process")
ggsave("10N-performancePerProcess.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)
