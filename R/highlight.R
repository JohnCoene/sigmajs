#' Zoom
#'
#' Dynamically Zoom a node.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param id Node id to zoom to.
#' @param duration Duration of animation.
#' @param ratio The zoom ratio of the graph and its items.
#'
#' @export
sg_zoom_p <- function(proxy, id, ratio = .5, duration = 1000) {

  if (missing(proxy) || missing(id))
    stop("must pass proxy and id", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, node = id, duration = duration, ratio = ratio)

	proxy$session$sendCustomMessage("sg_zoom_p", message)

	return(proxy)
}
