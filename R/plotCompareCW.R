plotCompareCW<- function(title,label,ncw){
  #' Plot of original consensus weights vs. normalized consensus weights grouping by the number of co-appeared percent of clustering(non-missing).
  #'
  #' @param title A character value for output directory.
  #' @param label A matrix or data frame of input labels, columns=different clustering results and rows are samples.
  #' @param ncw A matrix of normalized consensus weights with sample-by-sample as the order of sample(rows) in \code{label}.
  #' @return A ggplot point in PDF format with x-axis: original consensus weights; y-axis: normalized consensus weights; color: percent of co-appeared of clustering; size: number of duplicates sample .
  #' @import diceR  ggplot2 plyr
  #' @export
  #' @examples
  #'
  #' ## load data
  #' data(example_data)
  #' label=example_data
  #'
  #' ## "output" is a character value for output directory
  #' #title="output"
  #'
  #' #ncw<-callNCW(title=title,label=label)
  #' #plotCompareCW(title=title,label=label,ncw)




  requireNamespace("diceR")
  requireNamespace("ggplot2")
  requireNamespace("tidyr")
  requireNamespace("plyr")

  # require(diceR);require(ggplot2);require(plyr)

  ## convert 'title' for output directory to formated absolute path
  ### add "/" at the end of title
  if (!substr(title,nchar(title),nchar(title))=="/") {
    title = paste0(title,"/")
  }

  if (substr(title,1,2)=="./") {
    ### relative path to absolute path
    title = paste0(getwd(),"/",substr(title,3,nchar(title)))
  }else if (substr(title,1,1)=="D"){
    ### character input to absolute path
    title = title
  }else if (!substr(title,1,1)=="/"){
    ### character input to absolute path
    title = paste0(getwd(),"/",title)
  }

  ### original consensus weight matrix of label
  cw <- diceR::consensus_matrix(label)

  ### pair wise index of sample pairs with non missing values
  pair.ind = which(!is.na(cw),arr.ind = T)
  pair.ind = pair.ind[pair.ind[,1]-pair.ind[,2]<0,]

  ### number of shared non missing clusterings for each pair of samples
  nclust <- sapply(1:nrow(pair.ind),function(a){sum(colSums(is.na(label[pair.ind[a,],]))==0)})/ncol(label)
  nclust = cut(nclust, breaks = seq(0,1,by=0.1),include.lowest = T) # convert to percentage

  # data frame for plot
  pdata <- cbind.data.frame(cw=cw[pair.ind],ncw=ncw[pair.ind],nclust=nclust)
  pdata=count(pdata,vars=colnames(pdata))
  pdata$freq = cut(pdata$freq, breaks = unique(floor(quantile(pdata$freq,probs=seq(0,1,0.1)))),include.lowest = T,ordered_result = T,dig.lab=ceiling(log10(max(pdata$freq)))+1) # cut frequency to 10 breaks

  colnames(pdata)[3] = "Clustering"
  colnames(pdata)[4] = "Duplicates"

  ggplot(data=pdata,aes(x=cw,y=ncw,color=Clustering,size=Duplicates)) +
    geom_point() +
    scale_colour_brewer(palette="Spectral",name="Clustering") +
    xlab("Original consensus weights") +
    ylab("Normalized consensus weights") +
    theme_bw(base_size = 14)

  ggsave(paste0(title,"plotCompareCW.pdf"),width=8,height=6)
}
