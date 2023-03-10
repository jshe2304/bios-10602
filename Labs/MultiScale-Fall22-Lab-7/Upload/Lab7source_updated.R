library(seqinr, lib.loc = "./packages")

ORFTable <- function(sequence, minLength) {
    if(suppressMessages(require(Rcpp))) {
        sourceCpp("ORF1-1.cpp")
    } else {
        return("Rcpp is required")
    }
    ORFs <- findORF(sequence, minLength)
    output <- cbind("Start" = ORFs[[1]], "Stop" = ORFs[[2]], "Length" = ORFs[[2]] - ORFs[[1]] + 1, "Frame" = (ORFs[[1]] - 1) %% 3 + 1)
    return(output)
}

compStrand <- function(sequence) {
    return(rev(chartr("atcg", "tagc", sequence)))
}
print(paste0("Functions successfully loaded | ", date()))

HumanChr3 <- read.fasta("Homo_sapiens_Chr3.fasta")[[1]]
print(paste0("Chromosome sequence successfully loaded | ", date()))

write.csv(x = ORFTable(HumanChr3, 100), file = "./Homo_sapiens_Chr3_ORFs_forward.csv", row.names = F)
print(paste0("Forward ORFs written out | ", date()))

write.csv(x = ORFTable(compStrand(HumanChr3), 100), file = "./Homo_sapiens_Chr3_ORFs_reverse.csv", row.names = F)
print(paste0("Reverse ORFs written out | ", date()))

print("Program complete")
