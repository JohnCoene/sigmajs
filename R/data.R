#' Co-appearances of characters in "Les Miserables" as igraph object
#'
#' A graph where the nodes are characters in "Les Miserables" updated from its first encoding 
#' by Professor Donald Knuth, as part of the Stanford Graph Base (SGB)
#'
#' @format An igraph object with 181 nodes and 1589 edges
#' \describe{
#'   \item{\code{id}}{ abbreviation of character name}
#'   \item{\code{label}}{ character name}
#'   \item{\code{color}}{ random color}
#' }
#' @source \url{https://github.com/MADStudioNU/lesmiserables-character-network}
"lesmis_igraph"

#' Nodes from co-appearances of characters in "Les Miserables"
#'
#' A graph where the nodes are characters in "Les Miserables" updated from its first encoding 
#' by Professor Donald Knuth, as part of the Stanford Graph Base (SGB)
#'
#' @format An igraph object with 181 nodes and 2 variables
#' \describe{
#'   \item{\code{id}}{ abbreviation of character name}
#'   \item{\code{label}}{ character name}
#' }
#' @source \url{https://github.com/MADStudioNU/lesmiserables-character-network}
"lesmis_nodes"

#' Edges from co-appearances of characters in "Les Miserables"
#'
#' A graph where the nodes are characters in "Les Miserables" updated from its first encoding 
#' by Professor Donald Knuth, as part of the Stanford Graph Base (SGB)
#'
#' @format An igraph object with 181 nodes and 4 variables
#' \describe{
#'   \item{\code{source}}{ abbreviation of character name}
#'   \item{\code{target}}{ abbreviation of character name}
#'   \item{\code{id}}{ unique edge id}
#'	 \item{\code{label}}{ edge label}
#' }
#' @source \url{https://github.com/MADStudioNU/lesmiserables-character-network}
"lesmis_edges"
