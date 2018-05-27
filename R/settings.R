#' Settings
#' 
#' Graph settings.
#' 
#' @inheritParams sg_nodes
#' @param ... Any parameter, see \href{https://github.com/jacomyal/sigma.js/wiki/Settings}{official documentation}.
#' 
#' @examples 
#' nodes <- sg_make_nodes()
#'
#' edges <- sg_make_edges(nodes, 50)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force() %>% 
#'   sg_settings(
#'     defaultNodeColor = "#0011ff"
#'   )
#' 
#' @export
sg_settings <- function(sg, ...) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

  sg$x$settings <- list(...)
  sg
}

#' Refresh instance
#'
#' Refresh your instance.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#'
#' @details It is often required to refresh the instance when using proxies.
#'
#' @export
sg_refresh_p <- function(proxy) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_refresh_p", message)

	return(proxy)
}