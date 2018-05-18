#' Animate 
#' 
#' Animate graph components.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param mapping Variables to map animation to.
#' @param delay Delay in milliseconds before animation is triggered.
#'
#' @examples
#' # generate graph
#' nodes <- sg_make_nodes(20)
#' edges <- sg_make_edges(nodes, 30)
#' 
#' # add transition
#' n <- nrow(nodes)
#' nodes$to_x <- runif(n, 5, 10)
#' nodes$to_y <- runif(n, 5, 10)
#' nodes$to_size <- runif(n, 5, 10)
#' 
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size, color, to_x, to_y, to_size) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_animate(mapping = list(x = "to_x", y = "to_y", size = "to_size"))
#' 
#' @rdname animation
#' @export
sg_animate <- function(sg, mapping, delay = 5000) {

	if (missing(sg) || missing(mapping))
		stop("missing sg or mapping", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$animateLoop <- FALSE
	sg$x$animateMapping <- mapping
	sg$x$animateDelay <- delay

	sg
}