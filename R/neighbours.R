#' Highlight neighbours
#' 
#' Highlight node neighbours on click.
#' 
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param nodes,edges Color of nodes and edges
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 17)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size, color) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout() %>% 
#'   sg_neighbours()
#'
#' @rdname neighbours
#' @export
sg_neighbours <- function(sg, nodes = "#eee", edges = "#eee"){
  
  if(missing(sg))
    stop("must pass sg", call. = FALSE)
  
  if(!inherits(sg, "sigmajs"))
    stop("sg must be sigmajs object", call. = FALSE)
  
  sg$x$neighbours <- list(
    nodes = nodes,
    edges = edges
  )
  sg
}

#' @rdname neighbours
#' @export
sg_neighbors <- sg_neighbours