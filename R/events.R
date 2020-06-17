#' Events
#' 
#' Get events server-side.
#' 
#' @inheritParams sg_nodes
#' @param events A vector of valid events (see section below).
#' 
#' @details Events:
#' Valid events to pass to \code{events}.
#' \itemize{
#'   \item{\code{clickNode}}
#'   \item{\code{clickNodes}}
#'   \item{\code{clickEdge}}
#'   \item{\code{clickEdges}}
#'   \item{\code{clickStage}}
#'   \item{\code{doubleClickStage}}
#'   \item{\code{rightClickStage}}
#'   \item{\code{doubleClickNode}}
#'   \item{\code{doubleClickNodes}}  
#'   \item{\code{doubleClickEdge}}
#'   \item{\code{doubleClickEdges}}
#'   \item{\code{rightClickNode}}
#'   \item{\code{rightClickNodes}}
#'   \item{\code{rightClickEdge}}
#'   \item{\code{rightClickEdges}}
#'   \item{\code{hoverNode}}
#'   \item{\code{hoverNodes}}
#'   \item{\code{hoverEdge}}
#'   \item{\code{hoverEdges}}
#'   \item{\code{outNode}}
#'   \item{\code{outNodes}}
#'   \item{\code{outEdge}}
#'   \item{\code{outEdges}}
#' }
#' 
#' @examples 
#' library(shiny)
#' 
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#' 
#' ui <- fluidPage(
#'   sigmajsOutput("sg"),
#'   p("Click on a node"),
#'   verbatimTextOutput("clicked")
#' ) 
#' 
#' server <- function(input, output){
#'   output$sg <- renderSigmajs({
#'     sigmajs() %>%
#'       sg_nodes(nodes, id, size, color) %>%
#'       sg_edges(edges, id, source, target) %>% 
#'       sg_events("clickNode")
#'   })
#' 
#' # capture node clicked
#' output$clicked <- renderPrint({
#'     input$sg_click_node
#'   })
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @seealso \href{https://github.com/jacomyal/sigma.js/wiki/Events-API}{official documentation}.
#' 
#' @return An object of class \code{htmlwidget} which renders the visualisation on print.
#' 
#' @export 
sg_events <- function(sg, events){
  if(missing(events))
    stop("Must specify events, see events section in man page.")

  sg$x$events <- append(sg$x$events, as.list(events))
  return(sg)
}
