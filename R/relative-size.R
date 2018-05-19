#' Relative node sizes
#'
#' Change nodes size depending to their degree (number of relationships)
#'
#' @inheritParams sg_nodes
#' @param initial Initial node size.
#'
#' @examples
#' nodes <- sg_make_nodes(50)
#' edges <- sg_make_edges(nodes, 100)
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label) %>% # no need to pass size
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_relative_size()
#'
#' @export
sg_relative_size <- function(sg, initial = 1) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$relativeSize <- initial
	sg
}