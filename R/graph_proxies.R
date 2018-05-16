#' Add node or edge
#'
#' Proxies to dynamically add a node or an edge to an already existing graph.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param node,edge A \code{data.frame} of _one_ node or edge.
#' @param ... any column.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect.
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
#' @rdname add_p
#' @export
sg_add_node_p <- function(proxy, node, ..., refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	# build data
	nodes <- .build_data(node, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_node_p", message)

	return(proxy)
}

#' @rdname add_p
#' @export
sg_add_edge_p <- function(proxy, edge, ..., refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	# build data
	edges <- .build_data(edge, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = edges, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_edge_p", message)

	return(proxy)
}

#' Remove node or edge
#'
#' Proxies to dynamically remove a node or an edge to an already existing graph.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param id Id of edge or node to delete.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect.
#'
#' @examples
#' \dontrun{
#' demo("drop-node", package = "sigmajs")
#' }
#'
#' @rdname drop_p
#' @export
sg_drop_node_p <- function(proxy, id, refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	if (missing(id))
		stop("must pass id")

	message <- list(id = proxy$id, data = id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_drop_node_p", message)

	return(proxy)
}

#' @rdname drop_p
#' @export
sg_drop_edge_p <- function(proxy, id, refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	if (missing(id))
		stop("must pass id")

	message <- list(id = proxy$id, data = id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_drop_edge_p", message)

	return(proxy)
}

#' Clear or kill the graph
#'
#' Clear all nodes and edges from the graph or kills the graph.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect.
#'
#' @examples
#' \dontrun{
#' demo("clear-graph", package = "sigmajs")
#' }
#'
#' @rdname clear-kill
#' @export
sg_clear_p <- function(proxy, refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_clear_p", message)

	return(proxy)
}

#' @rdname clear-kill
#' @export
sg_kill_p <- function(proxy, refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_kill_p", message)

	return(proxy)
}