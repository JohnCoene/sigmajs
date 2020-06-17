#' Cluster
#' 
#' Color nodes by cluster.
#' 
#' @inheritParams sg_nodes
#' @param nodes,edges Nodes and edges as prepared for sigmajs.
#' @param colors Palette to color the nodes.
#' @param directed Whether or not to create a directed graph, passed to \code{\link[igraph]{graph_from_data_frame}}.
#' @param algo An \code{igraph} clustering function.
#' @param quiet Set to \code{TRUE} to print the number of clusters to the console.
#' @param save_igraph Whether to save the \code{igraph} object used internally.
#' @param ... Any parameter to pass to \code{algo}.
#' 
#' @details The package uses \code{igraph} internally for a lot of computations the \code{save_igraph} 
#' allows saving the object to speed up subsequent computations.
#' 
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_cluster} Color nodes by cluster.}
#'   \item{\code{sg_get_cluster} helper to get graph's nodes color by cluster.}
#' }
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 15)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_layout() %>% 
#'   sg_cluster() 
#'   
#' clustered <- sg_get_cluster(nodes, edges)
#' 
#' @return \code{sg_get_cluster} returns nodes with \code{color} variable while 
#' \code{sg_cluster} returns an object of class \code{htmlwidget} which renders 
#' the visualisation on print.
#' 
#' @rdname cluster
#' @export
sg_cluster <- function(sg, colors = c("#B1E2A3", "#98D3A5", "#328983", "#1C5C70", "#24C96B"),
                       directed = TRUE, algo = igraph::cluster_walktrap, quiet = !interactive(), 
                       save_igraph = TRUE, ...){
  
  if (missing(sg))
    stop("missing sg", call. = FALSE)
  
  .test_sg(sg)
  
  # build graph
  nodes <- .data_2_df(sg$x$data$nodes)
  edges <- .data_2_df(sg$x$data$edges) 
  nodes <- sg_get_cluster(nodes, edges, colors, directed, algo, quiet, save_igraph, ...)
  
  nodes <- apply(nodes, 1, as.list)
  
  sg$x$data$nodes <- nodes
  sg
}

#' @rdname cluster
#' @export
sg_get_cluster <- function(nodes, edges, colors = c("#B1E2A3", "#98D3A5", "#328983", "#1C5C70", "#24C96B"),
                       directed = TRUE, algo = igraph::cluster_walktrap, quiet = !interactive(), 
                       save_igraph = TRUE, ...){
  
  if (missing(nodes) || missing(edges))
    stop("missing nodes or edges", call. = FALSE)
  
  edges <- .re_order(edges)
  nodes <- .re_order_nodes(nodes)
  g <- .build_igraph(edges, directed = directed, nodes, save = save_igraph)
  
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
  
  return(nodes)
}