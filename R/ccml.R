ccml<-function(title, label, output="rdata",nperm = 10, ncore = 1, seedn = 100, stability = TRUE, maxK = 15, reps = 1000, pItem = 0.9, plot = "pdf", clusterAlg = "spectralClusteringAffinity", innerLinkage = "complete",...){
#' A two-step consensus clustering inputing multiple predictive labels with different sample coverages (missing labels)
#'
#' @param title A character value for output directory. Directory is created only if not existed. This title can be an abosulte or relative path. Input for \code{callNCW, plotCompareCW, ConsensusClusterPlus::ConsensusClusterPlus, ConsensusClusterPlus::calcICL}
#' @param label A matrix or data frame of input labels or a character value of input file name, columns=different clustering results and rows are samples. \code{label} could be import as '.rdata', '.rda', or '.csv'. Input for \code{callNCW, plotCompareCW}
#' @param output A character value for output format, or "rdata"(default) as save to .rdata, others will return to workspace.
#' @param nperm A integer value of the permutation numbers, or nperm=10(default), which means \code{nperm}*1000 times of permutation. Input for \code{callNCW}
#' @param ncore A integer value of cores to use, or ncore=1 (default). It's the input core numbers for the parallel computation in R package \code{parallel}. Input for \code{callNCW}
#' @param seedn A numerical value to set the start random seed for reproducible results, or seedn=100 (default). For every 1000 iteration, the seed will +1 to get repeat results. Input for \code{callNCW, ConsensusClusterPlus::ConsensusClusterPlus}
#' @param stability A logical value. Should estimate the stability of normalized consensus weight based on permutation numbers (default stability=TRUE), or not? Input for \code{callNCW}
#' @param maxK integer value. maximum cluster number to evaluate. Input for \code{ConsensusClusterPlus::ConsensusClusterPlus} for the consensus clustering based on normalized consensus weights.
#' @param reps integer value. number of subsamples. Input for \code{ConsensusClusterPlus::ConsensusClusterPlus}
#' @param pItem numerical value. proportion of items to sample. Input for \code{ConsensusClusterPlus::ConsensusClusterPlus}
#' @param plot character value. NULL - print to screen, 'pdf', 'png', 'pngBMP' for bitmap png, helpful for large datasets, or 'pdf'(default). Input for \code{ConsensusClusterPlus::ConsensusClusterPlus, ConsensusClusterPlus::calcICL}
#' @param clusterAlg character value. cluster algorithm. 'spectralClusteringAffinity' for spectral clustering of similarity/affinity matrix(default), other methods for clustering of distance matrix, 'hc' heirarchical (hclust), 'pam' for paritioning around medoids, 'km' for k-means upon data matrix, 'kmdist' for k-means upon distance matrices (former km option), or a function that returns a clustering. Input for \code{ConsensusClusterPlus::ConsensusClusterPlus}.
#' @param innerLinkage heirarchical linkage method for subsampling, or "complete"(default). Input for \code{ConsensusClusterPlus::ConsensusClusterPlus}
#' @param ... Other input arguments for \code{ConsensusClusterPlus::ConsensusClusterPlus}
#' @return A list of three items
#' \itemize{
#'   \item ncw - A matrix of normalized consensus weights. Output from \code{callNCW}.
#'   \item fcluster - A list of length maxK. Each element is a list containing consensusMatrix (numerical matrix), consensusTree (hclust), consensusClass (consensus class asssignments). ConsensusClusterPlus also produces images. Output from \code{ConsensusClusterPlus::ConsensusClusterPlus}
#'   \item icl a list of two elements clusterConsensus and itemConsensus corresponding to cluster-consensus and item-consensus. Output from \code{ConsensusClusterPlus::ConsensusClusterPlus}
#' }
#' @import ConsensusClusterPlus
#' @export
#' @examples
#'
#' ## load data
#' data(example_data)
#' label=example_data
#'
#' ## run ccml
#' ## "output" is a character value for output directory
#' #title="output"
#'
#' ## not estimate stability of permutation numbers.
#' #res_1=ccml(title=title,label=label,nperm = 2,stability=F,maxK=3,pItem=0.8,plot = "pdf")
#'
#' ## other methods for clustering of distance matrix
#' #res_2<-ccml(title=title,label=label,nperm = 10,stability=F,maxK=3,
#' #           pItem=0.9,plot = "pdf",clusterAlg = "hc")
#'
#' ## not output as "rdata"
#' #res_3<-ccml(title=title,label=label,output=FALSE,nperm = 10,stability=F,maxK=3,
#' #           pItem=0.9,plot = "pdf")

  requireNamespace("ConsensusClusterPlus")
  requireNamespace("tidyr")

  # if (!requireNamespace("BiocManager", quietly = TRUE))
  #   install.packages("BiocManager")

  # install_bioc("ConsensusClusterPlus")
  # usethis::use_dev_package("ConsensusClusterPlus")

  ## convert 'title' for output directory to formated absolute path
  ### add "/" at the end of title
  if (!substr(title,nchar(title),nchar(title))=="/") {
    title = paste0(title,"/")
  }

  if (substr(title,1,2)=="./") {
    ### relative path to absolute path
    title = paste0(getwd(),"/",substr(title,3,nchar(title)))
  } else if (substr(title,1,1)=="D" | substr(title,1,1)=="E" | substr(title,1,1)=="F"| substr(title,1,1)=="C"){
    ### character input to absolute path
    title = title
  }else if (!substr(title,1,1)=="/"){
    ### character input to absolute path
    title = paste0(getwd(),"/",title)
  }

  # ## import label
  # if (all(is.character(label)&grepl(".rdata$|.rda$",label))){
  #   load(label)
  # } else if (all(is.character(label)&grepl(".csv$",label))){
  #   label2 = read.csv2(label,header = T)
  #   label = label2[,2:ncol(label2)]
  #   rownames(label) = label2[,1]
  #   rm(label2)}


  # calculate normalized consensus weight matrix
  message("Main Step 1 - Calculating normalized consensus weight matrix")
  ncw <- callNCW(title, label, nperm = nperm, ncore = ncore, seedn = seedn, stability = TRUE)
  # plot of comparison of original and normalized consensus weights
  message("Main Step 2 - Comparison between original and normalized consensus weights")
  plotCompareCW(title, label, ncw)

  # The second step consensus clustering

  message("Main Step 3 - The 2nd step of consensus clustering based on normalized consensus weights")
  fcluster = ConsensusClusterPlus(as.dist(ncw), maxK=maxK, reps=reps, pItem=pItem, title=title, plot=plot, clusterAlg=clusterAlg, seed=seedn,innerLinkage=innerLinkage,...)
  # network as an affinity matrix can be used only because the "spectalClustering" algorithm use affinity matrices; keep in mind that classic algorithms use distance matrices
  icl = calcICL(fcluster, title=title, plot=plot)
  res <- list(ncw=ncw,fcluster=fcluster,icl=icl)
  if (output=="rdata"){
    save(res,file=paste0(title,"s",seedn,"n",nperm,"res.rdata"))
    res = "Output to .rdata"
  }
  return(res)
}
