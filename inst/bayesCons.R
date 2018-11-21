#library('ProfileParsimony')
path <- 'C:/Research/iw/'
bayesPath <- 'C:/Bayes64/DELETE_iwor/'
ReadNexus <- ape::read.nexus
WriteNexus <- ape::write.nexus
Consensus <- ape::consensus

charNos <- c(100, 350, 1000); paramNos <- 1:100; repNos <- 1:10
fileNo <- vapply(charNos, function (A) vapply(paramNos, function (B) vapply(repNos, function (C)
          paste0(A, '_', B, '_', C), '__'), character(length(repNos))), matrix('A',
          length(repNos), length(paramNos)))
mkSuboptimalValues <- seq(0.5, 1, length.out=21)
names(mkSuboptimalValues) <- paste0('consensus_', mkSuboptimalValues)

for (iFileNo in fileNo) {
  consFile <- paste0(path, 'mbCons/', iFileNo, '.con.nex')
  if (!file.exists(consFile)) {
    fileRoot <- paste0(bayesPath, 'nexTrees/', iFileNo, '.mb.nex.run')
    cat("\n - Processing ", fileRoot, '*.nex', sep='')
    if (file.exists(paste0(fileRoot, '1.nex')) & file.exists(paste0(fileRoot, '2.nex'))) {
      run1 <- ReadNexus(paste0(fileRoot, '1.nex'))
      cat("\n   - Reading")
      run2 <- ReadNexus(paste0(fileRoot, '2.nex'))
      cat(" - calculating consensus")
      cons <- lapply(mkSuboptimalValues, function (so) Consensus(c(run1, run2), p=so, check.labels=TRUE))
      cat("\n   - Saving:", vapply(cons, function (x) x$Nnode, double(1)), "nodes\n   - Saved to", consFile)
      WriteNexus(cons, file=consFile)
    } else {
      cat("\n   ! No results yet at", iFileNo)
    }
  }
}
cat ("\n=== Complete ===")
