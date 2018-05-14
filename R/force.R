#' Add force
#' 
#' @examples
#' ids <- as.character(1:10)
#'
#' nodes <- data.frame(
#'   id = ids,
#'   label = LETTERS[1:10],
#'   x = runif(10, 1, 20),
#'   y = runif(10, 1, 20),
#'   stringsAsFactors = FALSE
#' )
#'
#' edges <- data.frame(
#'   id = 1:15,
#'   source = sample(ids, 15, replace = TRUE),
#'   target = sample(ids, 15, replace = TRUE),
#'   stringsAsFactors = FALSE
#' )
#'
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, x, y) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force()
#' 
#' @export
sg_force <- function(sg, worker = TRUE, barnes.hut = FALSE){
    sg$x$force <- list(
        worker = worker,
        barnesHutOptimize = barnes.hut
    )
    sg
}