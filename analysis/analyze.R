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
  labs(x="Rank #", y="IO-500 Score", title="Performance")
ggsave("all-Performanceperrank.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

d$perThread = d$io500__score / d$information__client_total_procs


g = ggplot(d, aes(x=information__client_nodes, y=io500__score)) +
  geom_point() +
  labs(x="Client nodes", y="IO-500 Score", title="Score achieved relative to the nodes")
ggsave("all-Performance-nodes-withNodeCounts.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)


g = ggplot(d, aes(x=information__client_nodes, y=io500__score/information__client_nodes)) +
  geom_point()+
  labs(x="Client nodes", y="IO-500 Score", title="Contribution to the IO-500 score per node")
ggsave("all-Performance-nodes-pernode.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)


g = ggplot(d, aes(x=1:nrow(d), y=perThread)) +
  geom_point(aes(col=information__filesystem_type)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="Performance per process")
ggsave("all-performancePerProcess.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

g = ggplot(d, aes(x=information__filesystem_type, y=perThread)) +
  geom_boxplot() +
  labs(x="Rank #", y="IO-500 Score per Process", title="File system performance per process")
ggsave("all-performancePerProcess-fs.png", g, width=figsize[1]*2, height=figsize[2], units="cm")
plot(g)

t = d[grep( "NVMe", d$information__ds_storage_type),]
g = ggplot(t, aes(x=information__filesystem_type, y=perThread)) +
  geom_boxplot() +
  ylim(c(0, 2.5)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="File system performance per process (NVME)")
ggsave("all-performancePerProcess-fs-nvme.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)


t = d[grep( "HDD", d$information__ds_storage_type),]
g = ggplot(t, aes(x=information__filesystem_type, y=perThread)) +
  geom_boxplot() +
  ylim(c(0, 2.5)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="File system performance per process (HDD)")
ggsave("all-performancePerProcess-fs-hdd.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)


t = d[grep( "SSD", d$information__ds_storage_type),]
g = ggplot(t, aes(x=information__filesystem_type, y=perThread)) +
  geom_boxplot() +
  ylim(c(0, 2.5)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="File system performance per process (SSD)")
ggsave("all-performancePerProcess-fs-ssd.png", g, width=figsize[1]*2, height=figsize[2], units="cm")
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

scores = function(d){
  bd = max(d$ior__easy_write) * max(d$ior__easy_read) * max(d$ior__hard_write) * max(d$ior__hard_read)
  md = max(d$mdtest__easy_write) * max(d$mdtest__easy_stat) * max(d$mdtest__easy_delete) * max(d$mdtest__hard_write) * max(d$mdtest__hard_read) * max(d$mdtest__hard_stat) * max(d$mdtest__hard_delete) * max(d$find__easy)
  print(sprintf("bw: %.2f md: %.2f score: %.2f", bd^(1/4), md^(1/8), (md*bd)^(1/12)))
}

scores(d)

# 10 Node analysis
t = d %>% filter(information__client_nodes==10)
scores(t)

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
  labs(x="Rank #", y="IO-500 Score", title="10 Node Challenge")
ggsave("10N-Performanceperrank.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)

# Performance per thread
t$perThread = t$io500__score / t$information__client_total_procs
g = ggplot(t, aes(x=1:nrow(t), y=perThread)) +
  geom_point(aes(col=information__filesystem_type)) +
  labs(x="Rank #", y="IO-500 Score per Process", title="10 Node Challenge -- Performance per Process")
ggsave("10N-performancePerProcess.png", g, width=figsize[1], height=figsize[2], units="cm")
plot(g)
