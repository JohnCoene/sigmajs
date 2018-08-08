#' Add forceAtlas2
#' 
#' Implementation of \href{http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0098679}{forceAtlas2}.
#' 
#' @inheritParams sg_nodes
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param delay Milliseconds after which the layout algorithm should stop running.
#' @param data \code{data.frame} holding \code{delay} column.
#' @param cumsum Whether to compute the cumulative sum of the delay.
#' @param ... Any parameter, see \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.layout.forceAtlas2}{official documentation}.
#' @param refresh Whether to refresh the graph after node is dropped, required to take effect.
#' 
#'
#' @section Functions:
#' \itemize{
#'	\item{\code{sg_force}, \code{sg_force_start} starts the forceAtlas2 layout}
#'	\item{\code{sg_force_stop} stops the forceAtlas2 layout after a \code{delay} milliseconds}
#'	\item{\code{sg_force_restart_p} proxy to re-starts (\code{kill} then \code{start}) the forceAtlas2 layout, the options you pass to this function are applied on restart. If forceAtlas2 has not started yet it is launched.}
#'	\item{\code{sg_force_start_p} proxy to start forceAtlas2.}
#'	\item{\code{sg_force_stop_p} proxy to stop forceAtlas2.}
#'	\item{\code{sg_force_kill_p} proxy to ompletely stops the layout and terminates the assiociated worker. You can still restart it later, but a new worker will have to initialize.}
#'	\item{\code{sg_force_config_p} proxy to set configurations of forceAtlas2.}
#'	\item{\code{sg_force_restart} Restarts (kills then starts) forceAtlas2 at given delay.}
#' }
#' 
#' @details The delay helps for build dynamic visualisations where nodes and edges do not appear all at the same time.
#' How the delay works depends on the \code{cumsum} parameter. if \code{TRUE} the function computes the cumulative sum
#' of the delay to effectively add each row one after the other: delay is thus applied at each row (number of seconds to wait
#' before the row is added *since the previous row*). If \code{FALSE} this is the number of milliseconds to wait before the node or
#' edge is added to the visualisation; \code{delay} is used as passed to the function.
#' 
#' @examples
#' nodes <- sg_make_nodes(50)
#' edges <- sg_make_edges(nodes, 100)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force() %>% 
#'   sg_force_stop() # stop force after 5 seconds
#' 
#' @seealso \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.layout.noverlap}{official documentation}
#'
#' @rdname force
#' @export
sg_force <- function(sg, ...) {
	
	if (missing(sg))
		stop("missing sg", call. = FALSE)
  
  .test_sg(sg)

  sg$x$force <- list(...)
  sg
}

#' @rdname force
#' @export
sg_force_start <- sg_force

#' @rdname force
#' @export
sg_force_stop <- function(sg, delay = 5000) {
	
	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$forceStopDelay <- delay
  	sg
}

#' @rdname force
#' @export
sg_force_restart_p <- function(proxy, ..., refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, data = list(...), refresh = refresh)

	proxy$session$sendCustomMessage("sg_force_restart_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_restart <- function(sg, data, delay, cumsum = TRUE) {
  
  if (missing(data) || missing(delay) || missing(sg))
    stop("must pass sg, data and delay", call. = FALSE)
  
  .test_sg(sg)
  
  delay_col <- eval(substitute(delay), data) 
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) 
  
  delay_table <- dplyr::tibble(sigmajsdelay = delay_col)
  
  # build data
  delay <- .build_data(data) %>%
    dplyr::bind_cols(delay_table) %>% 
    dplyr::arrange(sigmajsdelay) %>% 
    .as_list()
  
  sg$x$forceRestartDelay <- append(sg$x$forceRestartDelay, delay)
  sg
} 

#' @rdname force
#' @export
sg_force_start_p <- function(proxy, ..., refresh = TRUE) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, data = list(...), refresh = refresh)

	proxy$session$sendCustomMessage("sg_force_start_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_stop_p <- function(proxy) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_force_stop_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_kill_p <- function(proxy) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_force_kill_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_config_p <- function(proxy, ...) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, data = list(...))

	proxy$session$sendCustomMessage("sg_force_config_p", message)

	return(proxy)
}