# CCML: A two-step consensus clustering inputing multiple predictive labels with different sample coverages (missing labels)

## Dependencies
------------
* diceR
* ggplot2
* parallel
* plyr
* tidyr
* SNFtools
* ConsensusClusterPlus



## Installation
------------
Get the latest released version from CRAN:    
``` r
install.packages("ccml")
```
Or from GitHub:

``` r
remotes::install_github("*****")
```
Or install locally:
``` r
install.packages("ccml_1.0.0.tar.gz",repos = NULL, type="source")
```

## Setup
------------
This package needs to create a folder to store the result. Let’s call the folder
`output` and assume the full path to this folder is
`xxxxx/output`. Run the function below to set the path for the package.

``` r
library(ccml)
setwd("xxxxx/output")
```

Or a folder named "output" will be created under the default path when the program is running.



## Introduction
------------
NULL



## Functions
------------
* cml     
*A two-step consensus clustering inputing multiple predictive labels with different sample coverages (missing labels).*

* callNCW  
*Calculate normalized consensus weight(NCW) matrix based on permutation.*


* plotCompareCW  
*Plot of original consensus weights vs. normalized consensus weights grouping by the number of co-appeared percent of clustering(non-missing).*


* randConsensusMatrix   
*Calculate consensus weight matrix based on the permuted input label matrix. Internal function used by callNCW.*


* spectralClusteringAffinity  
*Perform spectral clustering algorithms for an affinity matrix, using SNFtool::spectralClustering.*




## Run examples
------------
In the repository, we give some examples to show how to run **ccml**.
*example_data is built into R package and can be loaded with data().*

* load data   
*A matrix or data frame of input labels or a character value of input file name, columns are different clustering results and rows are samples.*
  ``` r
  data(example_data)
  label=example_data
  ```

* output directory      
*This part is mentioned in Setup above.*
  ``` r
  title="output"
  ```
  
* run cml
   ```r
    # not estimate stability of permutation numbers.
    res_1=cml(title=title,label=label,nperm = 2,stability=F,maxK=3,pItem=0.8,plot = "pdf")

    # other methods for clustering of distance matrix
    res_2<-cml(title=title,label=label,nperm = 10,stability=F,maxK=3,pItem=0.9,plot = "pdf",clusterAlg = "hc")

    # not output as "rdata"
    res_3<-cml(title=title,label=label,nperm = 10,stability=F,maxK=3,pItem=0.9,plot = "pdf",output=FALSE)

    # The output is a list.Some examples are as follws
    # get consensusMatrix
    res$fcluster[[3]]$consensusMatrix

    # get consensusTree
    res$fcluster[[2]]$consensusTree

    # get consensusClass
    res$fcluster[[2]]$consensusClass

   ```

* run callNCW
   ```r
    ncw<-callNCW(title=title,label=label,nperm = 10, ncore = 1, seedn = 100, stability = TRUE)
   ```
   
* run plotCompareCW
   ```r
    plotCompareCW(title=title,label=label,ncw)
   ```
  

## Output Description
------------
* consensus     
  The heatmaps of the consensus matrices(for k= 2, 3, 4),consensus CDF Plot, Delta Area Plot and Tracking Plot are used to determine the best K value of clustering.
  

  <img src="img/k_2.jpg" width="29%">
  <img src="img/k_3.jpg" width="29%">
  <img src="img/k_4.jpg" width="29%">

  <img src="img/2.CDF.jpg" width="27%">
  <img src="img/2_Delta.jpg" width="27%">
  <img src="img/2_tracking.jpg" width="27%">


* icl  
  Item-Consensus Plot show the stability of members.   
  ![icl](img/3.icl.jpg)   
  ![icl_2](img/3.icl_2.jpg)

  
* plotCompareCW   
  This plot show the original consensus weights vs. normalized consensus weights grouping by the number of co-appeared percent of clustering(non-missing).The number of duplicates sample are indicated by the size of the colored portion, whose color corresponds to percent of co-appeared of clustering.   
  ![PCW](img/3.PCW.jpg)

* stability.seed100.n10K   
  The name of plot represents 10*1000 permutation using random numbers with seedn=100.The stability of normalized consensus weight is estimated based on permutation numbers.
  ![ncw](img/NCW.jpg)
