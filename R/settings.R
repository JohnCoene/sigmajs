#' Settings
#' 
#' Graph settings.
#' 
#' @inheritParams sg_nodes
#' @param ... Any parameter, see \href{https://github.com/jacomyal/sigma.js/wiki/Settings}{official documentation}.
#' 
#' @examples 
#' ids <- as.character(1:10)
#'
#' nodes <- data.frame(
#'   id = ids,
#'   label = LETTERS[1:10],
#'   x = runif(10, 1, 20),
#'   y = runif(10, 1, 20),
#'   size = runif(10, 1, 5),
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
#'   sg_nodes(nodes, id, label, size, x, y) %>%
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force() %>% 
#'   sg_settings(
#'     defaultNodeColor = "#0011ff"
#'   )
#' 
#' @export
sg_settings <- function(sg, ...){
  sg$x$settings <- list(...)
  sg
}