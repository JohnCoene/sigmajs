#' Add nodes and edges
#'
#' Add nodes and edges to a \code{sigmajs} graph.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param data Data.frame (or list) of nodes or edges.
#' @param ... any column.
#'
#' @details Eaach node must include a unique id, ideally the user passes \code{x} and \code{y}, if they are not passed then they are randomly generated.
#' Each edge also must include a unique id.
#'
#' @section Functions:
#' \itemize{
#'		\item{Functions ending in \code{*2} take a list that resembles the original sigma.js JSON inputs}
#'		\item{Other functions take the arguments described above.}
#' }
#'
#' @examples
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label) %>%
#'   sg_edges(edges, id, source, target) %>%
#'	 sg_settings(defaultNodeColor = "#0011ff")
#'
#' @rdname graph
#' @export
sg_nodes <- function(sg, data, ...) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

  nodes <- .build_data(data, ...) %>% 
    .check_ids() %>% 
    .check_x_y() %>% 
    .as_list()

  sg$x$data <- append(sg$x$data, list(nodes = nodes))
  sg
}

#' @rdname graph
#' @export
sg_edges <- function(sg, data, ...) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

  edges <- .build_data(data, ...) %>% 
    .check_ids() %>% 
    .as_list()

  sg$x$data <- append(sg$x$data, list(edges = edges))
  sg
}

#' @rdname graph
#' @export
sg_edges2 <- function(sg, data) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)


	sg$x$data <- append(sg$x$data, list(edges = data))
	sg
}

#' @rdname graph
#' @export
sg_nodes2 <- function(sg, data) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$data <- append(sg$x$data, list(nodes = data))
	sg
}
