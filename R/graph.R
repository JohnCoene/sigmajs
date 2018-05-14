#' Add nodes
#'
#' Add nodes.
#'
#' @param nodes Data.frame of nodes.
#' @param ... any column.
#'
#' @examples
#' ids <- as.character(1:10)
#'
#' nodes <- data.frame(
#'   id = ids,
#'   label = LETTERS[1:10],
#'   x = runif(10, 1, 20),
#'   y = runif(10, 1, 20),
#'   stringsAsFactors = FALSE
#' )
#'
#' edges <- data.frame(
#'   id = 1:15,
#'   source = sample(ids, 15, replace = TRUE),
#'   target = sample(ids, 15, replace = TRUE),
#'   stringsAsFactors = FALSE
#' )
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, x, y) %>%
#'   sg_edges(edges, id, source, target)
#'
#' @rdname graph
#' @export
sg_nodes <- function(sg, nodes, ...){

  nodes <- .build_data(nodes, ...)
  nodes <- .as_list(nodes)

  sg$x$data <- append(sg$x$data, list(nodes = nodes))
  sg
}

#' @rdname graph
#' @export
sg_edges <- function(sg, edges, ...){

  edges <- .build_data(edges, ...)
  edges <- .as_list(edges)

  sg$x$data <- append(sg$x$data, list(edges = edges))
  sg
}
