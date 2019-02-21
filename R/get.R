#' Get nodes
#'
#' Retrieve nodes and edges from the widget.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#'
#' @examples
#' library(shiny)
#' 
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#' 
#' ui <- fluidPage(
#'   actionButton("start", "Trigger layout"), # add the button
#'   sigmajsOutput("sg"),
#'   verbatimTextOutput("txt")
#' ) 
#' 
#' server <- function(input, output){
#' 
#'   output$sg <- renderSigmajs({
#'     sigmajs() %>%
#'       sg_nodes(nodes, id, size, color) %>%
#'       sg_edges(edges, id, source, target)
#'   })
#' 
#'   observeEvent(input$start, {
#'     sigmajsProxy("sg") %>% # use sigmajsProxy!
#'       sg_get_nodes_p()
#'   })
#' 
#'   output$txt <- renderPrint({
#'     input$sg_nodes
#'   })
#' 
#' }
#' if(interactive()) shinyApp(ui, server) # run
#' 
#' @rdname get_graph
#' @export
sg_get_nodes_p <- function(proxy) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_get_nodes_p", message)
  return(proxy)
}

#' @rdname get_graph
#' @export
sg_get_edges_p <- function(proxy) {

  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id)

	proxy$session$sendCustomMessage("sg_get_edges_p", message)
  return(proxy)
}
