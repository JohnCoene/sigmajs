#' Add nodes and edges
#'
#' Add nodes and edges to a \code{sigmajs} graph.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param data Data.frame of nodes or edges.
#' @param ... any column.
#'
#' @details Eaach node must include a unique id, ideally the user passes \code{x} and \code{y}, if they are not passed then they are randomly generated.
#' Each edge also must include a unique id.
#'
#' @examples
#' ids <- as.character(1:10)
#'
#' nodes <- data.frame(
#'   id = ids,
#'   label = LETTERS[1:10],
#'   stringsAsFactors = FALSE
#' )
#'
#' edges <- data.frame(
#'   id = 1:15,
#'   source = sample(ids, 15, replace = TRUE),
#'   target = sample(ids, 15, replace = TRUE),
#'   type = "curvedArrow",
#'   stringsAsFactors = FALSE
#' )
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label) %>%
#'   sg_edges(edges, id, source, target)
#'
#' @rdname graph
#' @export
sg_nodes <- function(sg, data, ...) {

  nodes <- .build_data(data, ...) %>% 
    .check_ids() %>% 
    .check_x_y() %>% 
    .as_list()

  sg$x$data <- append(sg$x$data, list(nodes = nodes))
  sg
}

#' @rdname graph
#' @export
sg_edges <- function(sg, data, ...){

  edges <- .build_data(data, ...) %>% 
    .check_ids() %>% 
    .as_list()

  sg$x$data <- append(sg$x$data, list(edges = edges))
  sg
}

#' @rdname graph
#' @export
sg_edges2 <- function(sg, data) {
	sg$x$data <- append(sg$x$data, list(edges = data))
	sg
}

#' @rdname graph
#' @export
sg_nodes2 <- function(sg, data) {
	sg$x$data <- append(sg$x$data, list(nodes = data))
	sg
}