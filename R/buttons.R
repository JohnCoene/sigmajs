#' Buttons
#' 
#' Add buttons to your graph.
#' 
#' @inheritParams sg_nodes
#' @param label Button label.
#' @param event Event the button triggers, see valid events.
#' @param class Button \code{CSS} class, see note.
#' 
#' @section Events:
#' \itemize{
#'   \item{\code{force_start}}
#'   \item{\code{force_stop}}
#'   \item{\code{noverlap}}
#'   \item{\code{drag_nodes}}
#'   \item{\code{relative_size}}
#'   \item{\code{add_nodes}}
#'   \item{\code{add_edges}}
#'   \item{\code{add_nodes_edges}}
#'   \item{\code{drop_nodes}}
#'   \item{\code{drop_edges}}
#'   \item{\code{animate}}
#'   \item{\code{export_svg}}
#'   \item{\code{export_img}}
#' }
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 17)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force_start() %>% 
#'   sg_button("start layout", "force_start")
#'   
#' # additional nodes
#' nodes2 <- sg_make_nodes()
#' nodes2$id <- as.character(seq(11, 20))
#' 
#' # add delay
#' nodes2$delay <- runif(nrow(nodes2), 500, 1000)
#' 
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size, color) %>%
#'   sg_add_nodes(nodes2, delay, id, label, size, color) %>% 
#'   sg_button("add nodes", "add_nodes")
#' 
#' @note The default class (\code{btn btn-default}) works with Bootstrap 3, the default framework for Shiny and R markdown.
#' 
#' @export
sg_button <- function(sg, label, event, class = "btn btn-default"){
  
  if(missing(sg) || missing(label) || missing(event))
    stop("missing sg or label or event")
  
  .test_sg(sg)
  
  if(!event %in% .valid_events())
    stop("incorrect event", call. = FALSE)
  
  btn <- list(
    label = label,
    event = event
  )
  
  if(!is.null(class)) btn$className <- class
  
  sg$x$button <- btn
  sg
}