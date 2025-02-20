# iTCGA_Workshop_Salicornia_Eutrophication
Salicornia serves an important function in marsh ecosystems and may be threatenened by eutrophication. In this project we compare the effects of ammonium and nitrate on root growth and flower production in Salicornia depressa. Analyze how nitrogen availability influences gene expression to uncover insights into nutrient uptake mechanisms, stress tolerance, and reproductive fitness.

# iTCGA: Integrated Training in Computational Genomics and Data Sciences funded by NIH/NCL Grant #U54CA156734-13S2

# **Expressional Response to Ammonium and Nitrate in *Salicornia depressa***

## **Overview**
This project explores the effects of ammonium (NH₄⁺) and nitrate (NO₃⁻) on the gene expression, root growth, and flower production of *Salicornia depressa* (pickleweed), a salt-tolerant marsh plant. By leveraging RNA-Seq analysis and statistical methods, this project seeks to understand how different forms of nitrogen impact plant growth in eutrophic salt marsh environments.

---

## **Contents**

### **1. Presentation**
- File: `Salicornia_and_Eutrophication.pptx`
- Description: This presentation provides an overview of the project, background on eutrophication, the importance of nitrogen forms in marsh ecosystems, and key findings from the RNA-Seq analysis.

### **2. Project Notes**
- File: `Salicornia_Project_Outline.docx`
- Description: A document summarizing the project's scope, hypotheses, methods, and key references, as well as detailed notes on prior studies and results.

### **3. Pipeline**
The RNA-Seq analysis pipeline includes:
1. **Raw Read Trimming**:
   - Tool: `cuadapt` script.
   - Purpose: Remove low-quality sequences and adapter contamination from raw FASTQ files.
2. **Alignment**:
   - Tool: `hisat2`.
   - Purpose: Align reads to a reference *Salicornia* genome, generating SAM files.
3. **Conversion and Sorting**:
   - Tool: `samtools`.
   - Purpose: Convert SAM to BAM files, sort and index BAM files for downstream analysis.
4. **Gene Count Matrix**:
   - Tool: `featureCounts`.
   - Purpose: Generate a matrix of gene expression levels for statistical analysis.
5. **Differential Expression Analysis**:
   - Tool: R scripts.
   - Purpose: Identify genes differentially expressed under ammonium and nitrate treatments using statistical models (e.g., Volcano plots).

---

## **Research Questions**
1. How do ammonium and nitrate affect the growth of roots and flowers in *Salicornia depressa*?
2. What are the transcriptomic responses of *Salicornia depressa* to these two forms of nitrogen?
3. Do ammonium and nitrate influence genes involved in stress tolerance and nutrient transport differently?

---

## **Key Findings**
- **Eutrophication Impact**: Ammonium and nitrate, key contributors to eutrophication, have distinct effects on *Salicornia*'s growth and gene expression.
- **Gene Expression**:
  - Nitrate-treated samples showed downregulation of nitrogen transport genes, indicating sufficient nitrogen availability.
  - Ammonium-treated samples exhibited upregulation of stress-related genes, suggesting potential stress from excess ammonium.
- **Root and Flower Response**:
  - Ammonium promoted longer and thinner roots.
  - Nitrate encouraged lateral root growth and increased above-ground biomass.

---

## **Dependencies**
- **Python**:
  - For initial sequence trimming and alignment scripts.
- **SAMtools**:
  - For handling SAM/BAM files.
- **R**:
  - For differential expression analysis and generating visualizations (e.g., Volcano plots).
- **HISAT2**:
  - For spliced-read alignment to the *Salicornia depressa* reference genome.

---

## **How to Use**
1. Clone this repository:
   ```bash
   git clone <repository_url>
   ```
2. Ensure required tools and dependencies are installed.
3. Follow the pipeline described in the documentation to replicate the analysis.
4. Open `Salicornia_and_Eutrophication.pptx` for a summarized explanation of the project and results.

---

## **References**
- Johnson, D. S., et al. (2016). Saltmarsh plant responses to eutrophication. *Ecological Applications.*
- Bloom, A. J., et al. (2003). Root growth as a function of ammonium and nitrate in the root zone. *Plant Cell and Environment.*
- Salazar, O. R., et al. (2024). SOS1 tonoplast neo-localization and the RGG protein SALTY in *Salicornia bigelovii*. *Nature Communications.*
- Guo et al. (2022). Transcriptome analysis reveals multiple effects of nitrogen accumulation and metabolism in the roots, shoots, and leaves of potato (Solanum tuberosum L.). *BMC Plant Biology*
- Dahuja et al. (2021). Role of ATP-binding cassette transporters in maintaining plant homeostasis under abiotic and biotic stresses. *Physiologia Plantarum*
- Janowska et al. (2019). Mechanisms of Small Heat Shock Proteins. *Cold Spring Harbor Perspectives in Biology*

---

## **Contact**
For any questions or contributions, please contact:
- **Project Leads**: Jeny Sherchan, Jayna Fawcett, Sean Hernon
- **Email**: sherchan.jen1@gmail.com, jayna.k.fawcett@gmail.com, seanhernon@verizon.com 
