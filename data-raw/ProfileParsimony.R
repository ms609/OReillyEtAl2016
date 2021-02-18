library("TreeTools", warn.conflicts = FALSE)
library("TreeSearch")

# OReilly et al. 2016
# https://datadryad.org/stash/dataset/doi:10.5061/dryad.10qf3 -> Matrices
HOME <- "C:/research/r/OReillyEtAl2016/data-raw"

for (n in c(100, 350, 1000)) {
  for (i in 1:100) {
    for (j in 1:10) {
      mat <- ReadAsPhyDat(paste0(HOME, '/Matrices/', n, '_char_matrices/',
                                        n, '_', i, '_', j, '.NEX'))
      tree <- MaximizeParsimony(mat, concavity = 'profile')
      ape::write.tree(tree, paste0(HOME, '/Trees/pp.', n, '/', i, '_', j, '.tre'))
    }
  }
}
