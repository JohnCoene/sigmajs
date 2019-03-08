#' Buttons
#' 
#' Add buttons to your graph.
#' 
#' @inheritParams sg_nodes
#' @param event Event the button triggers, see valid events.
#' @param class Button \code{CSS} class, see note.
#' @param tag A Valid \link[htmltools]{tags} function.
#' @param id A valid CSS id.
#' @param position Position of button, \code{top} or \code{bottom}.
#' @param ... Content of the button, complient with \code{htmltools}.
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
#'   \item{\code{drop_nodes}}
#'   \item{\code{drop_edges}}
#'   \item{\code{animate}}
#'   \item{\code{export_svg}}
#'   \item{\code{export_img}}
#'   \item{\code{progress}}
#'   \item{\code{read_exec}}
#' }
#' 
#' @details You can pass multiple events as a vector, see examples. You can also pass multiple buttons.
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes)
#' 
#' # Button starts the layout and stops it after 3 seconds
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_force_start() %>% 
#'   sg_force_stop(3000) %>% 
#'   sg_button(c("force_start", "force_stop"), "start layout")
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
#'   sg_force_start() %>% 
#'   sg_force_stop(3000) %>% 
#'   sg_button(c("force_start", "force_stop"), "start layout") %>% 
#'   sg_button("add_nodes", "add nodes")
#' 
#' @note The default class (\code{btn btn-default}) works with Bootstrap 3 (the default framework for Shiny and R markdown).
#' 
#' @export
sg_button <- function(sg, event, ..., position = "top", class = "btn btn-default", tag = htmltools::tags$button, id = NULL){
  
  if(missing(sg) ||  missing(event))
    stop("missing sg or event")
  
  .test_sg(sg)
  
  for(ev in event)
    if(!ev %in% .valid_events()) stop(paste(ev, "is not a known event"), call. = FALSE)
  
  if("add_nodes_edges" %in% event)
    warning("add_nodes_edges is deprecated, in favour of c('add_nodes', 'add_edges')", call. = FALSE)
  
  if(is.null(class)) 
    class <- ""
  
  if(is.null(id))
    id <- .make_rand_id()
  
  btn <- list(
    id = id,
    event = event
  )
  
  sg$x$button <- append(sg$x$button, list(btn))
  sg$x$buttonevent <- append(sg$x$buttonevent, event)
  
  if(position == "top"){
    sg %>% 
      htmlwidgets::prependContent(tag(id = id, class = paste("sigmajsbtn", class), ...))
  } else {
    sg %>% 
      htmlwidgets::appendContent(tag(id = id, class = paste("sigmajsbtn", class), ...))
  }
}