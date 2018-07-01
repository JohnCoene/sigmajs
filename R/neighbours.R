#' Neighbours
#' 
#' Highlight node neighbours on click.
#' 
#' @inheritParams sg_nodes
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
sg_neighbours <- function(sg){
  
  if(missing(sg))
    stop("must pass sg", call. = FALSE)
  
  if(!inherits(sg, "sigmajs"))
    stop("sg must be sigmajs object", call. = FALSE)
  
  sg$x$neighbours <- TRUE
  sg
}

#' @rdname neighbours
#' @export
sg_neighbors <- sg_neighbours