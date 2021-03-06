#' O'Reilly et al. reference tree
#'
#' The tree topology used to generate the matrices in O'Reilly _et al._ 2016
#'
#' @format A single phylogenetic tree saved as an object of class \code{phylo}
#'
#' @references
#' \insertRef{OReilly2016}{Quartet}
#'
#' @examples
#'   library('ape') # Contains tree plotting functions
#'   data(orReferenceTree)
#'   plot(orReferenceTree)
#'
#' @source \insertRef{OReilly2016}{Quartet}
"orReferenceTree"

#' Partition and Quartet similarity counts for trees generated from
#' the datasets of O'Reilly _et al._
#'
#' For each of the 3000 matrices simulated by O'Reilly _et al._ (2016),, I conducted
#' phylogenetic analysis under different methods:
#'
#' \itemize{
#' \item{markov}{Using the Markov K model in MrBayes.}
#' \item{equal}{Using equal weights in TNT.}
#' \item{implied1,implied2,implied3,implied5,implied10}{Using implied weights in TNT,
#'   with the concavity constant (_k_) set to 1, 2, 3, 5, or 10}
#' \item{impliedC}{By taking the strict *c*onsensus of all trees recovered by implied
#' weights parsimony analysis under the _k_ values 2, 3, 5 and 10 (but not 1).}
#' }
#'
#' For each analysis, I recorded the strict consensus of all optimal trees, and also
#' the consensus of trees that were suboptimal by a specified degree.
#'
#' I then calculated, of the total number of <%= quartet %>s that were resolved in the
#' reference tree, how many were the *s*ame or *d*ifferent in the tree that resulted from
#' the phylogenetic analysis, and how many were not resolved in this tree (*r2*).
#'
#' The data object contains a list whose elements are named after the methods, as listed above.
#'
#' Each list entry is a three-dimensional array, whose dimensions are:
#' \itemize{
#' \item{1}{The suboptimality of the tree: for _markov_, the consensus at a 50%,
#'  52.5%, ... 97.5%, 100% posterior probability; for _equal_, the consensus of
#'  all trees that are 0, 1, .... 19, 20 steps less optimal than the optimal
#'  tree; for _implied_, the consensus of all trees that are 0.73^(19:0)
#' less optimal than the optimal tree.}
#' \item{2}{The number of <%=quartet%>s in total, the same, different, resolved
#'  in the estimated tree but not the generative tree (= 0), resolved in the
#'  generative tree but not the estimated tree}
#' \item{3}{The number of the matrix, from 1 to 100.}
#' }
#'
#' @seealso `\link[CongreveLamsdell2016]{clMatrices}`,
#'  `\link[CongreveLamsdell2016]{clReferenceTree}`.
#' @source \insertRef{Congreve2016}{Quartet}
"orQuartets"

#' @rdname orQuartets
"orPartitions"
