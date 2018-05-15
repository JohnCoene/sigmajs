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

	proxy$session$sendCustomMessage("sg_add_edge_p", message)

	return(proxy)
}