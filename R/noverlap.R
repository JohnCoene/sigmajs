#' No overlap
#'
#' This plugin runs an algorithm which distributes nodes in the network, ensuring that they do not overlap and providing a margin where specified.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param nodeMargin The additional minimum space to apply around each and every node.
#' @param ... any option to pass to the plugin, see \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.layout.noverlap}{official documentation}.
#'
#' @examples
#' nodes <- sg_make_nodes(500)
#' edges <- sg_make_edges(nodes)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, size, color) %>%
#'   sg_edges(edges, id, source, target) %>%
#'   sg_layout() %>% 
#'   sg_noverlap()
#'
#' @rdname noverlap
#' @export
sg_noverlap <- function(sg, ...) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$noverlap <- list(...)
	sg
}

#' @rdname noverlap
#' @export
sg_noverlap_p <- function(proxy, nodeMargin = 5, ...) {
	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id, config = list(nodeMargin = nodeMargin, ...)) # create message

	proxy$session$sendCustomMessage("sg_noverlap_p", message)

	return(proxy)
}
