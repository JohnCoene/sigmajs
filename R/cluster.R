#' Cluster
#' 
#' Color nodes by cluster.
#' 
#' @inheritParams sg_nodes
#' @param colors Palette to color the nodes.
#' @param directed Whether or not to create a directed graph, passed to \code{\link[igraph]{graph_from_data_frame}}.
#' @param algo An \code{igraph} clustering function.
#' @param quiet Set to \code{TRUE} to print the number of clusters to the console.
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 17)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout() %>% 
#'   sg_cluster() 
#' 
#' @export
sg_cluster <- function(sg, colors = c("#B1E2A3", "#98D3A5", "#328983", "#1C5C70", "#24C96B"),
                       directed = TRUE, algo = igraph::cluster_walktrap, quiet = !interactive(), 
                       ...){
  
  # build graph
  nodes <- .data_2_df(sg$x$data$nodes)
  edges <- .data_2_df(sg$x$data$edges) 
  edges <- .re_order(edges)
  g <- igraph::graph_from_data_frame(edges, directed = directed, nodes)
  
  # get communities
  communities <- algo(g, ...)
  membership <- igraph::as_membership(communities)
  
  # build color table
  grps <- unique(membership$membership)
  n_grps <- length(grps)
  
  if(!isTRUE(quiet))
    cat("Found #", n_grps, "clusters\n")
  
  colors <- colorRampPalette(colors)(n_grps)
  colors <- data.frame(
    grp = as.character(grps),
    color = colors,
    stringsAsFactors = FALSE
  )
  
  # merge coms & grps
  nodes$grp <- as.character(membership$membership)
  nodes$color <- NULL
  nodes <- dplyr::inner_join(colors, nodes, by = "grp")
  
  nodes <- apply(nodes, 1, as.list)
  
  sg$x$data$nodes <- nodes
  sg
}