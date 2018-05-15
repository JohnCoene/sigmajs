#' Add force
#' 
#' Implementation of \href{http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0098679}{forceAtlas2}.
#' 
#' @inheritParams sg_nodes
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param ... Any parameter, see \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.layout.forceAtlas2}{official documentation}.
#' 
#'
#' @section Functions:
#' \itemize{
#'	\item{\code{sg_force} starts the forceAtlas2 layout}
#'	\item{\code{sg_force_restart_p} proxy to re-starts the forceAtlas2 layout, the options you pass to this function are applied on restart. If forceAtlas2 has not started yet it is launched.}
#'	\item{\code{sg_force_start_p proxy to start forceAtlas2.}
#'	\item{\code{sg_force_stop_p proxy to stop forceAtlas2.}
#'	\item{\code{sg_force_config_p proxy to set configurations of forceAtlas2.}
#' }
#' 
#' @examples
#' ids <- as.character(1:10)
#'
#' nodes <- data.frame(
#'   id = ids,
#'   label = LETTERS[1:10],
#'   size = runif(10, 1, 5),
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
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force()
#' 
#' @rdname force
#' @export
sg_force <- function(sg, ...){
    sg$x$force <- list(...)
    sg
}

#' @rdname force
#' @export
sg_force_restart_p <- function(proxy, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, data = list(...))

	proxy$session$sendCustomMessage("sg_force_restart_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_start_p <- function(proxy, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, data = list(...))

	proxy$session$sendCustomMessage("sg_force_start_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_stop_p <- function(proxy) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_force_stop_p", message)

	return(proxy)
}

#' @rdname force
#' @export
sg_force_config_p <- function(proxy, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, data = list(...))

	proxy$session$sendCustomMessage("sg_force_config_p", message)

	return(proxy)
}