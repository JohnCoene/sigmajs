#' Create from igraph
#'
#' Create a \code{sigmajs} from an \code{igraph} object.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param igraph An object of class \code{igraph}.
#' @param layout A matrix of coordinates.
#' @param sd A \link[crosstalk]{SharedData} of nodes.
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
sg_from_igraph <- function(sg, igraph, layout = NULL, sd = NULL) {

  if (missing(sg))
    stop("missing sg", call. = FALSE)
  
  .test_sg(sg)

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
		nodes$id <- nodes$name

	# add layout
	if (is.null(layout))
		layout <- igraph::layout_nicely(igraph)

	# add x and y (required by sigmajs)
	layout <- as.data.frame(layout)
	names(layout) <- c("x", "y")

	# force layout character
	layout$x <- as.character(layout$x)
	layout$y <- as.character(layout$y)

	nodes <- dplyr::bind_cols(nodes, layout)

	if(!"size" %in% names(nodes))
		nodes$size <- 1

	sg$x$data <- append(sg$x$data, list(nodes = .as_list(nodes), edges = .as_list(edges)))
	
	if(!is.null(sd)){
	  if (crosstalk::is.SharedData(sd)) {
	    sg$x$crosstalk$crosstalk_key <- sd$key()
	    sg$x$crosstalk$crosstalk_group <- sd$groupName()
	  } 
	} 

	return(sg)
}