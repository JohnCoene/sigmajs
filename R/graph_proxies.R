#' Add node or edge
#'
#' Proxies to dynamically add a node or an edge to an already existing graph.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of _one_ node or edge.
#' @param ... any column.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed.
#' 
#' @examples
#' \dontrun{
#' demo("add-node", package = "sigmajs")
#' demo("add-edge", package = "sigmajs")
#' demo("add-node-edge", package = "sigmajs")
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname add_p
#' @export
sg_add_node_p <- function(proxy, data, ..., refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	# build data
	nodes <- .build_data(data, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_node_p", message)

	return(proxy)
}

#' @rdname add_p
#' @export
sg_add_edge_p <- function(proxy, data, ..., refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	# build data
	edges <- .build_data(data, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = edges, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_edge_p", message) # send message

	return(proxy)
}

#' Add nodes or edges
#' 
#' Proxies to dynamically add *multiple* nodes or edges to an already existing graph.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of nodes or edges.
#' @param ... any column.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted at every iteration..
#' @param rate Refresh rate, either \code{once}, the graph is refreshed after data.frame of nodes is added or at each \code{iteration} (row-wise). Only applies if \code{refresh} is set to \code{TRUE}.
#' 
#' @examples
#' \dontrun{
#' demo("add-nodes", package = "sigmajs")
#' demo("add-edges", package = "sigmajs")
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname adds_p
#' @export
sg_add_nodes_p <- function(proxy, data, ..., refresh = TRUE, rate = "once") {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data))
		stop("must pass data", call. = FALSE)

	if (!rate %in% c("once", "iteration"))
		stop("incorrect rate", call. = FALSE)

	# build data
	nodes <- .build_data(data, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh, rate = rate) # create message

	proxy$session$sendCustomMessage("sg_add_nodes_p", message)

	return(proxy)
}

#' @rdname adds_p
#' @export
sg_add_edges_p <- function(proxy, data, ..., refresh = TRUE, rate = "once") {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data))
		stop("must pass data", call. = FALSE)

	if (!rate %in% c("once", "iteration"))
		stop("incorrect rate", call. = FALSE)

	# build data
	nodes <- .build_data(data, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh, rate = rate) # create message

	proxy$session$sendCustomMessage("sg_add_edges_p", message)

	return(proxy)
}

#' Remove node or edge
#'
#' Proxies to dynamically remove a node or an edge to an already existing graph.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param id Id of edge or node to delete.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted.
#'
#' @examples
#' \dontrun{
#' demo("drop-node", package = "sigmajs")
#' }
#'
#' @rdname drop_p
#' @export
sg_drop_node_p <- function(proxy, id, refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(id))
		stop("must pass id")

	message <- list(id = proxy$id, data = id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_drop_node_p", message)

	return(proxy)
}

#' @rdname drop_p
#' @export
sg_drop_edge_p <- function(proxy, id, refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

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
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted.
#'
#' @examples
#' \dontrun{
#' demo("clear-graph", package = "sigmajs")
#' }
#'
#' @rdname clear-kill
#' @export
sg_clear_p <- function(proxy, refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_clear_p", message)

	return(proxy)
}

#' @rdname clear-kill
#' @export
sg_kill_p <- function(proxy, refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, refresh = refresh)

	proxy$session$sendCustomMessage("sg_kill_p", message)

	return(proxy)
}

#' Add nodes or edges with a delay
#' 
#' Proxies to dynamically add multiple nodes or edges to an already existing graph with a *delay* between each addition.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of _one_ node or edge.
#' @param ... any column.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted at every iteration.
#' @param delay Column name containing delay in milliseconds.
#' @param cumsum Whether to compute the cumulative sum of the delay.
#' 
#' @details The delay helps for build dynamic visualisations where nodes and edges do not appear all at the same time.
#' How the delay works depends on the \code{cumsum} parameter. if \code{TRUE} the function computes the cumulative sum
#' of the delay to effectively add each row one after the other: delay is thus applied at each row (number of seconds to wait
#' before the row is added *since the previous row*). If \code{FALSE} this is the number of milliseconds to wait before the node or
#' edge is added to the visualisation; \code{delay} is used as passed to the function.
#'
#' @examples
#' \dontrun{
#' demo("add-nodes-delay", package = "sigmajs") # add nodes with a delay
#' demo("add-edges-delay", package = "sigmajs") # add edges with a delay
#' demo("add-delay", package = "sigmajs") # add nodes and edges with a delay
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname adds_delay_p
#' @export
sg_add_nodes_delay_p <- function(proxy, data, delay, ..., refresh = TRUE, cumsum = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data) || missing(delay))
		stop("must pass data and delay", call. = FALSE)

	delay_col <- eval(substitute(delay), data) # subset delay
	if (isTRUE(cumsum))
		delay_col <- cumsum(delay_col) # cumul for setTimeout
	delay_table <- dplyr::tibble(sigmajsdelay = delay_col) # build delay tibble

	# build data
	nodes <- .build_data(data, ...) %>%
		dplyr::bind_cols(delay_table) %>% # bind delay
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_nodes_delay_p", message)

	return(proxy)
}

#' @rdname adds_delay_p
#' @export
sg_add_edges_delay_p <- function(proxy, data, delay, ..., refresh = TRUE, cumsum = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data) || missing(delay))
		stop("must pass data and delay", call. = FALSE)

	delay_col <- eval(substitute(delay), data) # subset delay
	if (isTRUE(cumsum))
		delay_col <- cumsum(delay_col) # cumul for setTimeout
	delay_table <- dplyr::tibble(sigmajsdelay = delay_col) # build delay tibble

	# build data
	nodes <- .build_data(data, ...) %>%
		dplyr::bind_cols(delay_table) %>% # bind delay
	  .check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes, refresh = refresh) # create message

	proxy$session$sendCustomMessage("sg_add_edges_delay_p", message)

	return(proxy)
}

#' Drop nodes or edges
#' 
#' Proxies to dynamically drop *multiple* nodes or edges from an already existing graph.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of nodes or edges.
#' @param ids Column containing ids to drop from the graph.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect.
#' @param rate Refresh rate, either \code{once}, the graph is refreshed after data.frame of nodes is added or at each \code{iteration} (row-wise). Only applies if \code{refresh} is set to \code{TRUE}.
#' 
#' @examples
#' \dontrun{
#' demo("add-nodes", package = "sigmajs")
#' demo("add-edges", package = "sigmajs")
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname drops_p
#' @export
sg_drop_nodes_p <- function(proxy, data, ids, refresh = TRUE, rate = "once") {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data))
		stop("must pass data", call. = FALSE)

	if (!rate %in% c("once", "iteration"))
		stop("incorrect rate", call. = FALSE)

	ids <- eval(substitute(ids), data) # subset ids

	message <- list(id = proxy$id, data = ids, refresh = refresh, rate = rate) # create message

	proxy$session$sendCustomMessage("sg_drop_nodes_p", message)

	return(proxy)
}

#' @rdname drops_p
#' @export
sg_drop_edges_p <- function(proxy, data, ids, refresh = TRUE, rate = "once") {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	if (missing(data))
		stop("must pass data", call. = FALSE)

	if (!rate %in% c("once", "iteration"))
		stop("incorrect rate", call. = FALSE)

	ids <- eval(substitute(ids), data) # subset ids

	message <- list(id = proxy$id, data = ids, refresh = refresh, rate = rate) # create message

	proxy$session$sendCustomMessage("sg_drop_edges_p", message)

	return(proxy)
}

#' Drop nodes or edges with a delay
#' 
#' Proxies to dynamically drop multiple nodes or edges to an already existing graph with a *delay* between each removal.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of _one_ node or edge.
#' @param ids Ids of elements to drop.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted at every iteration.
#' @param delay Column name containing delay in milliseconds.
#' @param cumsum Whether to compute the cumulative sum of the delay.
#' 
#' @details The delay helps for build dynamic visualisations where nodes and edges do not disappear all at the same time.
#' How the delay works depends on the \code{cumsum} parameter. if \code{TRUE} the function computes the cumulative sum
#' of the delay to effectively drop each row one after the other: delay is thus applied at each row (number of seconds to wait
#' before the row is dropped *since the previous row*). If \code{FALSE} this is the number of milliseconds to wait before the node or
#' edge is added to the visualisation; \code{delay} is used as passed to the function.
#'
#' @examples
#' \dontrun{
#' demo("drop-nodes-delay", package = "sigmajs") # add nodes with a delay
#' demo("drop-edges-delay", package = "sigmajs") # add edges with a delay
#' demo("drop-delay", package = "sigmajs") # add nodes and edges with a delay
#' }
#'
#' @note Have the parameters from your initial graph match that of the node you add, i.e.: if you pass \code{size} in your initial chart,
#' make sure you also have it in your proxy.
#' 
#' @rdname drop_delay_p
#' @export
sg_drop_nodes_delay_p <- function(proxy, data, ids, delay, refresh = TRUE, cumsum = TRUE) {
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  if (missing(data))
    stop("must pass data", call. = FALSE)
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  ids <- eval(substitute(ids), data) # subset ids
  
  to_drop <- dplyr::tibble(
    id = ids,
    sigmajsdelay = delay_col
  )
  
  to_drop <- dplyr::tibble(
    id = ids,
    sigmajsdelay = delay_col
  ) %>% # bind delay
    .as_list()
  
  message <- list(id = proxy$id, data = to_drop, refresh = refresh) # create message
  
  proxy$session$sendCustomMessage("sg_drop_nodes_delay_p", message)
  
  return(proxy)
}

#' @rdname drop_delay_p
#' @export
sg_drop_edges_delay_p <- function(proxy, data, ids, delay, refresh = TRUE, cumsum = TRUE) {
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  if (missing(data))
    stop("must pass data", call. = FALSE)
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  ids <- eval(substitute(ids), data) # subset ids
  
  to_drop <- dplyr::tibble(
    id = ids,
    sigmajsdelay = delay_col
  )
  
  to_drop <- dplyr::tibble(
    id = ids,
    sigmajsdelay = delay_col
  ) %>% # bind delay
    .as_list()
  
  message <- list(id = proxy$id, data = to_drop, refresh = refresh) # create message
  
  proxy$session$sendCustomMessage("sg_drop_edges_delay_p", message)
  
  return(proxy)
}