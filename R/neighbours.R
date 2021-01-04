#' Highlight neighbours
#' 
#' Highlight node neighbours on click.
#' 
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param nodes,edges Color of nodes and edges
#' @param on The sigmajs event on which to trigger the neighbours highlighting.
#'   'clickNode' (default) means when a node is clicked on. 'overNode' means
#'   when mouse is hovering on a node.
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 20)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size, color) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout() %>% 
#'   sg_neighbours()
#' 
#' @return A modified version of the \code{sg} object.
#'
#' @rdname neighbours
#' @export
sg_neighbours <- function(sg, nodes = "#eee", edges = "#eee", on = c("clickNode", "overNode")){
  
  if(missing(sg))
    stop("must pass sg", call. = FALSE)
  
  if(!inherits(sg, "sigmajs"))
    stop("sg must be sigmajs object", call. = FALSE)
  
  on <- match.arg(on)

  sg$x$neighbours <- list(
    nodes = nodes,
    edges = edges,
    on = on
  )
  sg
}

#' @rdname neighbours
#' @export
sg_neighbors <- sg_neighbours

#' @rdname neighbours
#' @export
sg_neighbours_p <- function(proxy, nodes = "#eee", edges = "#eee", on = c("clickNode", "overNode")){

  .test_proxy(proxy)
  on <- match.arg(on)
  message <- list(id = proxy$id, nodes = nodes, edges = edges, on = on)

	proxy$session$sendCustomMessage("sg_neighbours_p", message)
	return(proxy)
}

#' @rdname neighbours
#' @export
sg_neighbors_p <- sg_neighbours_p
