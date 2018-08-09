#' Layouts
#' 
#' Layout your graph.
#' 
#' @inheritParams sg_nodes
#' @param nodes,edges Nodes and edges as prepared for sigmajs.
#' @param directed Whether or not to create a directed graph, passed to \code{\link[igraph]{graph_from_data_frame}}.
#' @param layout An \code{igraph} layout function.
#' @param ... Any other parameter to pass to \code{layout} function.
#' 
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_layout} layout your graph.}
#'   \item{\code{sg_get_layout} helper to get graph's \code{x} and \code{y} positions.}
#' }
#' 
#' @examples 
#' nodes <- sg_make_nodes(250) # 250 nodes
#' edges <- sg_make_edges(nodes, n = 500)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size, color) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout()
#' 
#' nodes_coords <- sg_get_layout(nodes, edges)
#' 
#' @return \code{sg_get_layout} returns nodes with \code{x} and \code{y} coordinates.
#' 
#' @rdname layout
#' @export
sg_layout <- function(sg, directed = TRUE, layout = igraph::layout_nicely, ...){
  
  if (missing(sg))
    stop("missing sg", call. = FALSE)
  
  if (!inherits(sg, "sigmajs"))
    stop("sg must be of class sigmajs", call. = FALSE)
  
  nodes <- .data_2_df(sg$x$data$nodes)
  edges <- .data_2_df(sg$x$data$edges) 
  
  # clean
  nodes <- .rm_x_y(nodes)
  
  nodes <- sg_get_layout(nodes, edges, directed, layout, ...)
  
  nodes <- apply(nodes, 1, as.list)
  
  sg$x$data$nodes <- nodes
  sg
}

#' @rdname layout
#' @export
sg_get_layout <- function(nodes, edges, directed = TRUE, layout = igraph::layout_nicely, ...){
  
  if (missing(nodes) || missing(edges))
    stop("missing nodes or edges", call. = FALSE)
  
  # clean
  edges <- .re_order(edges)
  nodes <- .rm_x_y(nodes)
  nodes <- .re_order_nodes(nodes)
  
  g <- .build_igraph(edges, directed = directed, nodes)
  
  l <- layout(g, ...)
  l <- as.data.frame(l) %>% 
    dplyr::select_("x" = "V1", "y" = "V2")
  
  nodes <- dplyr::bind_cols(nodes, l)
  
  return(nodes)
}