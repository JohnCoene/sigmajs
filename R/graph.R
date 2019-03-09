globalVariables(c("id", "label", "sigmajsdelay", "size"))

#' Add nodes and edges
#'
#' Add nodes and edges to a \code{sigmajs} graph.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param data Data.frame (or list) of nodes or edges.
#' @param ... Any column name, see details.
#'
#' @details 
#' \strong{nodes}:
#' Must pass \code{id} (\emph{unique}), \code{size} and \code{color}. If \code{color} is omitted than specify 
#' \code{defaultNodeColor} in \code{\link{sg_settings}} otherwise nodes will be transparent. Ideally nodes 
#' also include \code{x} and \code{y}, 
#' if they are not passed then they are randomly generated, you can either get these coordinates with \code{\link{sg_get_layout}}
#' or \code{\link{sg_layout}}.
#' 
#' \strong{edges}:
#' Each edge also must include a unique \code{id} as well as two columns named \code{source} and \code{target} which correspond to
#' node \code{id}s. If an edges goes from or to an \code{id} that is not in node \code{id}.
#' 
#' @note \code{node} also takes a \link[crosstalk]{SharedData}.
#'
#' @section Functions:
#' \itemize{
#'		\item{Functions ending in \code{2} take a list like the original sigma.js JSON.}
#'		\item{Other functions take the arguments described above.}
#' }
#'
#' @examples
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#'
#' sg <- sigmajs() %>%
#'   sg_nodes(nodes, id, label, size, color) %>%
#'   sg_edges(edges, id, source, target) 
#'   
#' sg # no layout
#' 
#' # layout
#' sg %>% 
#'   sg_layout()
#'
#' # directed graph
#' edges$type <- "arrow" # directed
#' 
#' # omit color
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target, type) %>% 
#'   sg_settings(defaultNodeColor = "#141414")
#'   
#' # all source and target are present in node ids
#' all(c(edges$source, edges$target) %in% nodes$id)
#'
#' @rdname graph
#' @export
sg_nodes <- function(sg, data, ...) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)
  
  .test_sg(sg)
  
  # crosstalk
  if (crosstalk::is.SharedData(data)) {
    df <- data$origData()
    
    # crosstalk settings
    sg$x$crosstalk$crosstalk_key <- data$key()
    sg$x$crosstalk$crosstalk_group <- data$groupName()
  } else {
    df <- data
  }

  nodes <- .build_data(df, ...) %>% 
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

  .test_sg(sg)

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

  .test_sg(sg)

	sg$x$data <- append(sg$x$data, list(edges = data))
	sg
}

#' @rdname graph
#' @export
sg_nodes2 <- function(sg, data) {

	if (missing(sg) || missing(data))
		stop("missing sg or data", call. = FALSE)

  .test_sg(sg)

	sg$x$data <- append(sg$x$data, list(nodes = data))
	sg
}

#' Add nodes and edges
#' 
#' Add nodes or edges.
#' 
#' @inheritParams sg_nodes
#' @param delay Column name containing delay in milliseconds.
#' @param cumsum Whether to compute the cumulative sum of the delay.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted at every iteration.
#' 
#' @details The delay helps for build dynamic visualisations where nodes and edges do not appear all at the same time.
#' How the delay works depends on the \code{cumsum} parameter. if \code{TRUE} the function computes the cumulative sum
#' of the delay to effectively add each row one after the other: delay is thus applied at each row (number of seconds to wait
#' before the row is added *since the previous row*). If \code{FALSE} this is the number of milliseconds to wait before the node or
#' edge is added to the visualisation; \code{delay} is used as passed to the function.
#' 
#' @examples 
#' # initial nodes
#' nodes <- sg_make_nodes()
#' 
#' # additional nodes
#' nodes2 <- sg_make_nodes()
#' nodes2$id <- as.character(seq(11, 20))
#' 
#' # add delay
#' nodes2$delay <- runif(nrow(nodes2), 500, 1000)
#' 
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size, color) %>%
#'   sg_add_nodes(nodes2, delay, id, label, size, color)
#'   
#' edges <- sg_make_edges(nodes, 25)
#' edges$delay <- runif(nrow(edges), 100, 2000)
#' 
#' sigmajs() %>%
#'   sg_force_start() %>%
#'   sg_nodes(nodes, id, label, size, color) %>% 
#'   sg_add_edges(edges, delay, id, source, target, cumsum = FALSE) %>%
#'   sg_force_stop(2300) # stop after all edges added
#' 
#' @rdname add_static
#' @export
sg_add_nodes <- function(sg, data, delay, ..., cumsum = TRUE) {
  
  if (missing(data) || missing(delay) || missing(sg))
    stop("must pass sg, data and delay", call. = FALSE)
  
  .test_sg(sg)
  
  # crosstalk
  if (crosstalk::is.SharedData(data)) {
    df <- data$origData()
    
    # crosstalk settings
    sg$x$crosstalk$crosstalk_key <- data$key()
    sg$x$crosstalk$crosstalk_group <- data$groupName()
  } else {
    df <- data
  }
  
  delay_col <- eval(substitute(delay), df) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  delay_table <- dplyr::tibble(sigmajsdelay = delay_col) # build delay tibble
  
  # build data
  nodes <- .build_data(df, ...) %>%
    dplyr::bind_cols(delay_table) %>% # bind delay
    .check_ids() %>%
    .check_x_y() %>%
    dplyr::mutate(id = as.character(id)) %>% 
    dplyr::arrange(sigmajsdelay) %>% 
    .as_list()
  
  sg$x$addNodesDelay <- append(sg$x$addNodesDelay, nodes)
  
  sg
} 

#' @rdname add_static
#' @export
sg_add_edges <- function(sg, data, delay, ..., cumsum = TRUE, refresh = FALSE) {
  
  if (missing(data) || missing(delay) || missing(sg))
    stop("must pass sg, data and delay", call. = FALSE)
  
  .test_sg(sg)
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  delay_table <- dplyr::tibble(sigmajsdelay = delay_col) # build delay tibble
  
  # build data
  nodes <- .build_data(data, ...) %>%
    dplyr::bind_cols(delay_table) %>% # bind delay
    .check_ids() %>%
    dplyr::mutate(id = as.character(id)) %>% 
    dplyr::arrange(sigmajsdelay) %>% 
    .as_list()
  
  sg$x$addEdgesDelay <- append(sg$x$addEdgesDelay, list(data = nodes, refresh = refresh))
  sg
} 


#' Drop
#' 
#' Drop nodes or edges.
#' 
#' @inheritParams sg_nodes
#' @param delay Column name containing delay in milliseconds.
#' @param ids Ids of elements to drop.
#' @param cumsum Whether to compute the cumulative sum of the delay.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect, if you are running force the algorithm is killed and restarted at every iteration.
#' 
#' @details The delay helps for build dynamic visualisations where nodes and edges do not disappear all at the same time.
#' How the delay works depends on the \code{cumsum} parameter. if \code{TRUE} the function computes the cumulative sum
#' of the delay to effectively drop each row one after the other: delay is thus applied at each row (number of seconds to wait
#' before the row is dropped *since the previous row*). If \code{FALSE} this is the number of milliseconds to wait before the node or
#' edge is dropped to the visualisation; \code{delay} is used as passed to the function.
#' 
#' @examples 
#' nodes <- sg_make_nodes(75)
#' 
#' # nodes to drop
#' nodes2 <- nodes[sample(nrow(nodes), 50), ]
#' nodes2$delay <- runif(nrow(nodes2), 1000, 3000)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size, color) %>% 
#'   sg_drop_nodes(nodes2, id, delay, cumsum = FALSE)
#' 
#' @rdname drop_static 
#' @export
sg_drop_nodes <- function(sg, data, ids, delay, cumsum = TRUE) {
  
  if (missing(data) || missing(sg) || missing(ids) || missing(delay))
    stop("must pass sg, data, ids and delay", call. = FALSE)
  
  .test_sg(sg)
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  ids <- eval(substitute(ids), data) # subset ids
  
  to_drop <- dplyr::tibble(
    id = as.character(ids),
    sigmajsdelay = delay_col
  ) %>%
    dplyr::arrange(sigmajsdelay) %>% 
    .as_list()
  
  sg$x$dropNodesDelay <- append(sg$x$dropNodes, to_drop)
  sg
}

#' @rdname drop_static 
#' @export
sg_drop_edges <- function(sg, data, ids, delay, cumsum = TRUE, refresh = FALSE) {
  
  if (missing(data) || missing(sg) || missing(ids) || missing(delay))
    stop("must pass sg, data, ids and delay", call. = FALSE)
  
  .test_sg(sg)
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  ids <- eval(substitute(ids), data) # subset ids

  to_drop <- dplyr::tibble(
    id = as.character(ids),
    sigmajsdelay = delay_col
  ) %>%
    dplyr::arrange(sigmajsdelay) %>% 
    .as_list()
  
  sg$x$dropEdgesDelay <- list(data = to_drop, refresh = refresh)
  sg
}

#' Read 
#' 
#' Read nodes and edges into your graph, with or without a delay.
#' 
#' @inheritParams sg_nodes
#' @param delay Column name containing delay in milliseconds.
#' @param refresh Whether to refresh the \code{\link{force}} layout.
#'
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_read_nodes} read nodes.}
#'   \item{\code{sg_read_edges} read edges.}
#'   \item{\code{sg_read_exec} send read nodes and edges to JavaScript front end.}
#' }
#' 
#' @examples
#' nodes <- sg_make_nodes(50)
#'  nodes$batch <- c(
#' 	 rep(1000, 25),
#' 	 rep(3000, 25)
#' 	)
#' 
#' edges <- data.frame(
#'  id = 1:80,
#' 	 source = c(
#' 	  sample(1:25, 40, replace = TRUE),
#' 		sample(1:50, 40, replace = TRUE)
#' 	 ),
#' 	 target = c(
#' 	  sample(1:25, 40, replace = TRUE),
#' 		sample(1:50, 40, replace = TRUE)
#' 	 ),
#' 	 batch = c(
#' 	  rep(1000, 40),
#' 		rep(3000, 40)
#' 	 )
#' ) %>% 
#'  dplyr::mutate_all(as.character)
#' 
#' sigmajs() %>% 
#'   sg_force_start() %>% 
#'   sg_read_nodes(nodes, id, label, color, size, delay = batch) %>% 
#'   sg_read_edges(edges, id, source, target, delay = batch) %>% 
#' 	 sg_force_stop(4000) %>% 
#'   sg_read_exec() %>% 
#' 	 sg_button("read_exec", "Add nodes & edges")
#' 
#' @name read-static
#' @export
sg_read_nodes <- function(sg, data, ..., delay){
  
  if (missing(sg) || missing(data) || missing(delay))
    stop("must pass sg, data, and delay", call. = FALSE)

	delay <- deparse(substitute(delay))

  .test_sg(sg)

	nodes <- data %>% 
		.build_data(..., delay = delay) %>%
		.check_ids() %>%
		.check_x_y() %>%
		split(.[["delay"]]) %>% 
		purrr::map(.as_list)

  sg$x$read$data$nodes <- nodes
  return(sg)
}

#' @rdname read-static
#' @export
sg_read_edges <- function(sg, data, ..., delay){
  
  if (missing(sg) || missing(data) || missing(delay))
    stop("must pass sg, data, and delay", call. = FALSE)

  .test_sg(sg)

	delay <- deparse(substitute(delay))

	edges <- data %>% 
		.build_data(..., delay = delay) %>%
		.check_ids() %>%
		.check_x_y() %>%
		split(.[["delay"]]) %>% 
		purrr::map(.as_list)

  sg$x$read$data$edges <- edges
  return(sg)
}

#' @rdname read-static
#' @export
sg_read_exec <- function(sg, refresh = TRUE){
	.test_sg(sg)

	if(is.null(sg$x$read$data$edges))
		sg$x$read$data$edges <- list()

	if(is.null(sg$x$read$data$nodes))
		sg$x$read$data$nodes <- list()

	sg$x$read$data <- sg$x$read$data$nodes %>% 
		purrr::map2(sg$x$read$data$edges, .grp) %>% 
		unname()

	sg$x$read$refresh <- refresh

	return(sg)
}
