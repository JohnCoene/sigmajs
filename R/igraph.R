#' Create from igraph
#'
#' Create a \code{sigmajs} from an \code{igraph} object.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param igraph An object of class \code{igraph}
#' @param layout A matrix of coordinates.
#'
#' @examples
#' \dontrun{
#' data("lesmis_igraph")
#' 
#' layout <- igraph::layout_with_fr(lesmis_igraph)
#'
#' sigmajs() %>%
#'		sg_from_igraph(lesmis_igraph, layout) %>%
#'		sg_settings(defaultNodeColor = "#000")
#' }
#'
#' @export
sg_from_igraph <- function(sg, igraph, layout = NULL) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	if (missing(igraph))
		stop("must pass igraph", call. = FALSE)

	if (!inherits(igraph, "igraph"))
		stop("igraph is not of class igraph", call. = FALSE)

	# extract data frames
	g <- igraph::as_data_frame(igraph, what = 'both')
	edges <- g$edges
	nodes <- g$vertices

	# rename and enforce character
	n <- nrow(edges)
	edges <- dplyr::mutate(
		edges,
		id = as.character(seq(1, n)), # start from 1
		from = as.character(from),
		to = as.character(to)
	)
	names(edges)[1:2] <- c("source", "target")

	# check if nodes exist
	if (ncol(nodes) == 0)
		nodes <- dplyr::tibble(id = seq(1, nrow(nodes)))

	# enforce character
	if ("id" %in% names(nodes))
		nodes$id <- as.character(nodes$id)
	else
		nodes$id <- as.character(1:nrow(nodes))

	# add layout
	if (is.null(layout))
		layout <- igraph::layout_nicely(igraph)

	# add x and y (required by sigmajs)
	layout <- as.data.frame(layout)
	names(layout) <- c("x", "y")
	nodes <- dplyr::bind_cols(nodes, layout)

	sg$x$data <- append(sg$x$data, list(nodes = .as_list(nodes), edges = .as_list(edges)))

	return(sg)
}