source('../rfr_us.R')
library(ggplot2)
library(scatterplot3d)


# number of trees for forest
numtrees <- 100
# number of samples in dataset
sizeD <- 1000
# the 'k' of k nearest neighbors
k = 10


# create a sizeD by m synthetic dataset
X <- swissRoll(sizeD/2, size =1, dim3=T)
X <- as.matrix(X)[,2:4]

AkNN <- matrix(0, nrow=sizeD, ncol=sizeD)

# find the actual euclidean distance between all samples of the synthetic dataset
for(z in 1:sizeD){
AkNN[z,] <- sqrt(rowSums(sweep(X,2,X[z,])^2))
}

# create a similarity matrix using urerf
similarityMatrix <- createSimilarityMatrix (X, numtrees, k)
nnzPts <- which(similarityMatrix != 0)

#create output
pdf(file="../results/3dswissDvN.pdf")
with(data.frame(X), {
   scatterplot3d(x2, x3, x1,        # x y and z axis
                 color="blue", pch=19, # filled blue circles
                 main="3-D Swiss Roll",
                 xlab="X",
                 ylab="Y",
                 zlab="Z")
})

ssd <- data.frame(Distance = AkNN[nnzPts], Nearness = similarityMatrix[nnzPts])
ggplot(aes(x = Nearness, y = Distance), data = ssd) + geom_point() + labs(title="Distance vs Nearness\nSwiss Roll, n=1000, d=3, k=10, trees=100\nThree Samples (0 Nearness Omitted)")

nnzPts <- which(t(similarityMatrix[499:501,]) != 0)
ssd <- data.frame(Distance = t(AkNN[499:501,])[nnzPts], Nearness = t(similarityMatrix[499:501,])[nnzPts])
groupLabels <- c(rep("499",sizeD), rep("500", sizeD), rep("501",sizeD ))[nnzPts]
ssd[["Sample"]] <- groupLabels
ggplot(aes(x = Nearness, y = Distance, color = Sample), data = ssd) + geom_point()+ labs(title="Distance vs Nearness\nSwiss Roll, n=1000, d=3, k=10, trees=100\nThree Samples (0 Nearness Omitted)")+ geom_jitter()
dev.off()

