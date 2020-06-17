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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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
#' @return The \code{proxy} object.
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

#' Read
#'
#' Read nodes and edges to add to the graph. Other proxy methods to add data to a graph have to add nodes and edges one by one, 
#' thereby draining the browser, this method will add multiple nodes and edges more efficiently.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of _one_ node or edge.
#' @param ... any column.
#'
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_read_nodes_p} read nodes.}
#'   \item{\code{sg_read_edges_p} read edges.}
#'   \item{\code{sg_read_exec_p} send read nodes and edges to JavaScript front end.}
#' }
#' 
#' @examples
#' library(shiny)
#' 
#' ui <- fluidPage(
#' 	actionButton("add", "add nodes & edges"),
#' 	sigmajsOutput("sg")
#' )
#' 
#' server <- function(input, output, session){
#' 
#' 	nodes <- sg_make_nodes()
#' 	edges <- sg_make_edges(nodes)
#' 
#' 	output$sg <- renderSigmajs({
#' 		sigmajs() %>% 
#' 			sg_nodes(nodes, id, label, color, size) %>% 
#' 			sg_edges(edges, id, source, target) %>% 
#' 			sg_layout()
#' 	})
#' 
#' 	i <- 10
#' 
#' 	observeEvent(input$add, {
#' 		new_nodes <- sg_make_nodes()
#' 		new_nodes$id <- as.character(as.numeric(new_nodes$id) + i)
#' 		i <<- i + 10
#' 		ids <- 1:(i)
#' 		new_edges <- data.frame(
#' 			id = as.character((i * 2 + 15):(i * 2 + 29)),
#' 			source = as.character(sample(ids, 15)),
#' 			target = as.character(sample(ids, 15))
#' 		)
#' 		
#' 		sigmajsProxy("sg") %>% 
#' 			sg_force_kill_p() %>% 
#' 			sg_read_nodes_p(new_nodes, id, label, color, size) %>% 
#' 			sg_read_edges_p(new_edges, id, source, target) %>% 
#' 			sg_read_exec_p() %>% 
#' 			sg_force_start_p() %>% 
#' 			sg_refresh_p()
#' 	})
#' 
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @return The \code{proxy} object.
#' 
#' @name read
#' @export
sg_read_nodes_p <- function(proxy, data, ...){
  
  .test_proxy(proxy)

	# build data
	nodes <- data %>% 
		.build_data(...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	proxy$message$data$nodes <- nodes

	return(proxy)
}

#' @rdname read
#' @export
sg_read_edges_p <- function(proxy, data, ...){
  .test_proxy(proxy)

	# build data
	edges <- data %>% 
		.build_data(...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	proxy$message$data$edges <- edges

	return(proxy)
}

#' @rdname read
#' @export
sg_read_exec_p <- function(proxy){
	.test_proxy(proxy)

	proxy$message$id <- proxy$id

	if(is.null(proxy$message$data$edges))
		proxy$message$data$edges <- list()

	if(is.null(proxy$message$data$nodes))
		proxy$message$data$nodes <- list()

	proxy$session$sendCustomMessage("sg_read_exec_p", proxy$message)
	return(proxy)
}

#' Batch read
#' 
#' Read nodes and edges by batch with a delay.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data A \code{data.frame} of nodes or edges to add to the graph.
#' @param ... any column.
#' @param delay Column name of containing batch identifier.
#' @param refresh Whether to refresh the graph after each batch (\code{delay}) has been added to the graph.
#' Note that this will also automatically restart any running force layout.
#'
#' @details Add nodes and edges with \code{sg_read_delay_nodes_p} and \code{sg_read_delay_edges_p} then execute (send to JavaScript end) with \code{sg_read_delay_exec_p}.
#'
#' @examples
#' library(shiny)
#' 
#' ui <- fluidPage(
#' 	actionButton("add", "add nodes & edges"),
#' 	sigmajsOutput("sg")
#' )
#' 
#' server <- function(input, output, session){
#' 
#' 	output$sg <- renderSigmajs({
#' 		sigmajs()
#' 	})
#' 
#' 	observeEvent(input$add, {
#' 		nodes <- sg_make_nodes(50)
#' 		nodes$batch <- c(
#' 			rep(1000, 25),
#' 			rep(3000, 25)
#' 		)
#' 
#' 		edges <- data.frame(
#' 			id = 1:80,
#' 			source = c(
#' 				sample(1:25, 40, replace = TRUE),
#' 				sample(1:50, 40, replace = TRUE)
#' 			),
#' 			target = c(
#' 				sample(1:25, 40, replace = TRUE),
#' 				sample(1:50, 40, replace = TRUE)
#' 			),
#' 			batch = c(
#' 				rep(1000, 40),
#' 				rep(3000, 40)
#' 			)
#' 		) %>% 
#' 		dplyr::mutate_all(as.character)
#' 
#' 		sigmajsProxy("sg") %>% 
#'      sg_force_start_p() %>% 
#' 			sg_read_delay_nodes_p(nodes, id, color, label, size, delay = batch) %>% 
#' 			sg_read_delay_edges_p(edges, id, source, target, delay = batch) %>% 
#' 			sg_read_delay_exec_p()  %>% 
#' 			sg_force_stop_p()
#' 	})
#' 
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @return The \code{proxy} object.
#' 
#' @name read-batch
#' @export
sg_read_delay_nodes_p <- function(proxy, data, ..., delay){
  
  .test_proxy(proxy)

	if(missing(delay) || missing(data))
		stop("missing data or delay", call. = FALSE)

	delay <- deparse(substitute(delay))

	# build data
	nodes <- data %>% 
		.build_data(..., delay = delay) %>%
		.check_ids() %>%
		.check_x_y() %>%
		split(.[["delay"]]) %>% 
		purrr::map(.as_list)

	proxy$message$data$nodes <- nodes

	return(proxy)
}

#' @rdname read-batch
#' @export
sg_read_delay_edges_p <- function(proxy, data, ..., delay){
  .test_proxy(proxy)

	if(missing(delay) || missing(data))
		stop("missing data or delay", call. = FALSE)

	delay <- deparse(substitute(delay))

	# build data
	edges <- data %>% 
		.build_data(..., delay = delay) %>%
		.check_ids() %>%
		.check_x_y() %>%
		split(.[["delay"]]) %>% 
		purrr::map(.as_list)

	proxy$message$data$edges <- edges

	return(proxy)
}

#' @rdname read-batch
#' @export
sg_read_delay_exec_p <- function(proxy, refresh = TRUE){
	.test_proxy(proxy)

	proxy$message$id <- proxy$id

	if(is.null(proxy$message$data$edges))
		proxy$message$data$edges <- list()

	if(is.null(proxy$message$data$nodes))
		proxy$message$data$nodes <- list()

	proxy$message$data <- purrr::map2(proxy$message$data$nodes, proxy$message$data$edges, .grp) %>% 
		unname()

	proxy$message$refresh <- refresh

	proxy$session$sendCustomMessage("sg_read_bacth_exec_p", proxy$message)
	return(proxy)
}
