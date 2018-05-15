#' Add node or edge
#'
#' Proxy to dynamically add a node or an edge to already existing graph.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param node,edge A \code{data.frame} of _one_ node or edge.
#' @param ... any column.
#' 
#' @examples
#' \dontrun{
#' demo("add-node", package = "sigmajs")
#' demo("add-edge", package = "sigmajs")
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname add
#' @export
sg_add_node_p <- function(proxy, node, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	nodes <- .build_data(node, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes)

	proxy$session$sendCustomMessage("sg_add_node_p", message)

	return(proxy)
}

#' @rdname add
#' @export
sg_add_edge_p <- function(proxy, edge, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	edges <- .build_data(edge, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = edges)

	proxy$session$sendCustomMessage("sg_add_edge_p", message)

	return(proxy)
}
