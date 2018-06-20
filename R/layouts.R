#' Layouts
#' 
#' Layout your graph.
#' 
#' @inheritParams sg_nodes
#' @param directed Whether or not to create a directed graph, passed to \code{\link[igraph]{graph_from_data_frame}}.
#' @param layout an \code{igraph} layout function.
#' 
#' @examples 
#' nodes <- sg_make_nodes(250) # 250 nodes
#' edges <- sg_make_edges(nodes, n = 500)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size, color) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout(FALSE)
#' 
#' @export
sg_layout <- function(sg, directed = TRUE, layout = igraph::layout_nicely){
  
  nodes <- .data_2_df(sg$x$data$nodes)
  edges <- .data_2_df(sg$x$data$edges) 
  
  # clean
  nodes <- .rm_x_y(nodes)
  edges <- .re_order(edges)
  
  g <- igraph::graph_from_data_frame(edges, directed = directed, nodes)
  
  l <- layout(g)
  l <- as.data.frame(l) %>% 
    dplyr::select_("x" = "V1", "y" = "V2")
  
  nodes <- cbind.data.frame(nodes, l)
  nodes <- apply(nodes, 1, as.list)
  
  sg$x$data$nodes <- nodes
  sg
}