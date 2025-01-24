# install packages (you only need to do this once)
#install.packages("tidyverse")
#install.packages("ggrepel")

#if (!require("BiocManager", quietly = TRUE))
  #install.packages("BiocManager")
#BiocManager::install("edgeR")

# load the packages you need 
library(tidyverse)
library(ggrepel)
library(edgeR)

# read in the data
gene.counts <- read_table("C:/Users/Sean Hernon/Documents/ITCGA/counts2/salicornia_all_counts.txt", skip = 1)

# set the treatments
condition <- c("AF", "AF", "AF", "AF", "AR", "AR", "AR", "AR","NF", "NF", "NF", "NF","NR", "NR", "NR", "NR")

# filter out genes expressed at a low level across samples
dim(gene.counts)

totalexp <- rowSums(gene.counts[,7:22])

hist(totalexp)

gene.counts <-  filter(gene.counts, totalexp > 10)

# put the annotation information in a separate dataframe
ann <- gene.counts[,1:6]

# modify the data format for edgeR
d <- DGEList(counts=gene.counts[,7:22], group=factor(condition), genes = ann)
str(d)
dim(d) #21,478 genes in 9 samples

# normalize the data
d <- calcNormFactors(d, method ="TMM")
d$samples

# plot MDS
samples <- c("AF1","AF2","AF3","AF4","AR1","AR2","AR3","AR4","NF1","NF2","NF3","NF4","NR1", "NR2", "NR3", "NR4")

plotMDS(d, method="bcv", col=as.numeric(d$samples$group), labels = d$samples$group)
legend("top", as.character(unique(d$samples$group)), col=1:3, pch=20)

# start to fit a model
dm <- estimateCommonDisp(d, verbose = T)
dm <- estimateTagwiseDisp(dm)
plotBCV(dm)
# if this were nice and flat (following the red line, we'd be happy with it, but it looks like we need a more complex model)

# generalized linear model fit
design <- model.matrix(~ 0 + d$samples$group)
design
colnames(design) <- levels(d$samples$group)

dg <- estimateGLMCommonDisp(d, design)
dg <- estimateGLMTrendedDisp(dg, design)
dg <- estimateGLMTagwiseDisp(dg, design)
plotBCV(dg)
# this looks like a much better fit

# Let's fit our new model
fit <- glmFit(dg, design)

####

# this compares group 1 (Cs) to group 2 (Ts)
# and does a likelihood ratio test for each gene
fitfloral <- glmLRT(fit, contrast=c(1,0, -1, 0))
fitroot <- glmLRT(fit, contrast=c(0,1,0,-1))

deCT <- decideTestsDGE(fitfloral, adjust.method="BH", p.value = 0.001)
deCTtags <- rownames(dg)[as.logical(deCT)]
plotSmear(fitfloral, de.tags=deCTtags)
abline(h = c(-2, 2), col = "blue")

deR <- decideTestsDGE(fitroot, adjust.method="BH", p.value = 0.001)
deRtags <- rownames(dg)[as.logical(deR)]
plotSmear(fitroot, de.tags=deRtags)
abline(h = c(-2, 2), col = "blue")

# sort out the differentially expressed genes
tabCT <- topTags(fitfloral,n=Inf,adjust.method="BH", sort.by = "PValue")$table

tabR <- topTags(fitroot,n=Inf,adjust.method="BH", sort.by = "PValue")$table

# volcano
# make a significance column
tabCT <- tabCT %>% 
  mutate(significance = case_when((FDR < 0.05 & logFC > 2) ~ "Upregulated", (FDR < 0.05 & logFC < -2) ~ "Downregulated", .default = "Not significant"))

tabR <- tabR %>% 
  mutate(significance = case_when((FDR < 0.05 & logFC > 2) ~ "Upregulated", (FDR < 0.05 & logFC < -2) ~ "Downregulated", .default = "Not significant"))

# save this file and also one with just the significant genes
write_delim(tabCT, file = "ITCGA/defloral.txt", delim = "\t")
write_delim(filter(tabCT, significance != "Not significant"), file = "~/ITCGA/defloral-sig.txt", delim = "\t")

write_delim(tabR, file = "ITCGA/deroot.txt", delim = "\t")
write_delim(filter(tabR, significance != "Not significant"), file = "~/ITCGA/deroot-sig.txt", delim = "\t")

top_genes <- filter(tabCT, -log10(PValue) > 5)
top_genesR <- filter(tabR, -log10(PValue) > 5)

volcano_plot <- ggplot(tabCT, aes(x = logFC, y = -log10(PValue), color = significance)) +
  geom_point(alpha = 0.5) +
  scale_color_manual(values = c("Not significant" = "grey","Upregulated" = "red", "Downregulated" = "blue")) +
  geom_text_repel(data = top_genes, aes(label = Geneid), size = 3.5, fontface = 'bold') +
  geom_hline(yintercept = 3, linetype = "dashed") +
  geom_vline(xintercept = c(2, -2), linetype = "dashed") +
  theme_classic() +
  theme(legend.position = 'None',
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 12, face = "bold"),
        legend.title = element_blank()
  ) +
  labs(x = "Log2 Fold Change", y = "-Log10 p-value")

volcano_plot

volcano_plotR <- ggplot(tabR, aes(x = logFC, y = -log10(PValue), color = significance)) +
  geom_point(alpha = 0.5) +
  scale_color_manual(values = c("Not significant" = "grey","Upregulated" = "red", "Downregulated" = "blue")) +
  geom_text_repel(data = top_genes, aes(label = Geneid), size = 3.5, fontface = 'bold') +
  geom_hline(yintercept = 3, linetype = "dashed") +
  geom_vline(xintercept = c(2, -2), linetype = "dashed") +
  theme_classic() +
  theme(legend.position = 'None',
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 12, face = "bold"),
        legend.title = element_blank()
  ) +
  labs(x = "Log2 Fold Change", y = "-Log10 p-value")

volcano_plotR

# Save the volcano plot
ggsave("~/ITCGA/volcano_floral_sm.png", plot = volcano_plot, width = 7, height = 5, units = "in", device = "png")
ggsave("~/ITCGA/volcano_Root_sm.png", plot = volcano_plotR, width = 7, height = 5, units = "in", device = "png")

