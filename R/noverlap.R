#' No overlap
#'
#' This plugin runs an algorithm which distributes nodes in the network, ensuring that they do not overlap and providing a margin where specified.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param start Whether to start running the noverlap layout.
#' @param ... any option to pass to the plugin, see \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.layout.noverlap}{official documentation}.
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
#'   type = "curvedArrow",
#'   stringsAsFactors = FALSE
#' )
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size) %>%
#'   sg_edges(edges, id, source, target) %>%
#'   sg_settings(defaultNodeColor = "#0011ff") %>%
#'   sg_force() %>%
#'   sg_noverlap()
#'
#' @rdname noverlap
#' @export
sg_noverlap <- function(sg, start = TRUE, ...) {
	sg$x$noverlap <- list(...)
	sg$x$noverlapStart <- start
	sg
}

#' @rdname noverlap
#' @export
sg_noverlap_p <- function(proxy) {
	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	message <- list(id = proxy$id) # create message

	proxy$session$sendCustomMessage("sg_noverlap_start_p", message)

	return(proxy)
}
