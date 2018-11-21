library('ProfileParsimony')
path <- 'C:/Research/iw/'
path <- 'C:/Work/Fun/implied_weight/oreilly/'## DELETE
bayes.path <- 'C:/Bayes64/iwor/'

charnos <- c(100, 350, 1000); paramnos <- 1:100; repnos <- 1:9 # TODO 1:10 once bayes runs complete.
fileno <- vapply(charnos, function (A) vapply(paramnos, function (B) vapply(repnos, function (C)
          paste0(A, '_', B, '_', C), '__'), character(length(repnos))), matrix('A',
          length(repnos), length(paramnos)))
mk.suboptimal.values <- seq(1, 0.5, length.out=20)

for (ifileno in fileno) {
  cons.file <- paste0(path, 'mbCons/', ifileno, '.con.nex')
  if (TRUE || !file.exists(cons.file)) {  # TODO remove "True"
    fileroot <- paste0(bayes.path, 'nexTrees/', ifileno, '.mb.nex.run')
    cat("\n - Processing ", fileroot, '*.nex', sep='')
    if (file.exists(paste0(fileroot, '1.nex')) & file.exists(paste0(fileroot, '2.nex'))) {
      run1 <- read.nexus(paste0(fileroot, '1.nex'))
      cat("\n   - Reading")
      run2 <- read.nexus(paste0(fileroot, '2.nex'))
      cat(" - calculating consensus")
      cons <- lapply(mk.suboptimal.values, function (so) consensus(c(run1, run2), p=so, check.labels=TRUE))
      cat("\n   - Saving:", vapply(cons, function (x) x$Nnode, double(1)), "nodes\n   - Saved to", cons.file)
      write.nexus(cons, file=cons.file)
    } else {
      cat("\n   ! No results yet at", ifileno)
    }
  }
}
cat ("\n=== Complete ===")
