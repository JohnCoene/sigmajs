#' Drag nodes
#' 
#' Allow user to drag and drop nodes.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#'
#' @examples
#' # generate graph
#' nodes <- sg_make_nodes(20)
#' edges <- sg_make_edges(nodes, 35)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target) %>%
#'   sg_drag_nodes()
#'
#' \dontrun{
#' # proxies
#' demo("drag-nodes", package = "sigmajs")
#' }
#'
#' @rdname drag-nodes
#' @export
sg_drag_nodes <- function(sg) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

  .test_sg(sg)

    sg$x$dragNodes <- TRUE
    sg
}

#' @rdname drag-nodes
#' @export
sg_drag_nodes_start_p <- function(proxy) {

	if (missing(proxy))
		stop("missing proxy", call. = FALSE)

  .test_proxy(proxy)

	message <- list(id = proxy$id) # create message

	proxy$session$sendCustomMessage("sg_drag_nodes_start_p", message)
    proxy
}

#' @rdname drag-nodes
#' @export
sg_drag_nodes_kill_p <- function(proxy) {

	if (missing(proxy))
		stop("missing proxy", call. = FALSE)

  .test_proxy(proxy)

	message <- list(id = proxy$id) # create message

	proxy$session$sendCustomMessage("sg_drag_nodes_kill_p", message)
    proxy
}