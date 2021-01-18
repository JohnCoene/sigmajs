#' Events
#'
#' React to user-interaction events on the server-side in Shiny.
#'
#' @inheritParams sg_nodes
#' @param events A vector or list of valid events (see section below).
#'
#' @details
#' The parameter \code{events} is either a simple vector with the valid names of
#' events (see below), e.g. \code{c("clickNode", "overNode")}.
#'
#' An alternative possibility for \code{events} is to pass a list of named lists,
#' where each named list has an entry "event" with the valid event name and
#' optionally an entry "priority" specifying the priority of the event, e.g.
#' \code{list(list(event = "clickNode"), list(event = "overNode", priority = "event"))}.
#'
#' A priority of mode "event" means that the event is dispatched every time, not
#' only when its returned value changes. Shiny's default priority "immediate"
#' (also used when no priority is specified) would only dispatch when e.g. the
#' clicked or hovered node is different from before. See
#' \href{https://shiny.rstudio.com/articles/communicating-with-js.html}{https://shiny.rstudio.com/articles/communicating-with-js.html}
#' for more information.
#'
#' \strong{Events}:
#' Valid event names to pass to \code{events}.
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
#'   \item{\code{overNode}}
#'   \item{\code{overNodes}}
#'   \item{\code{overEdge}}
#'   \item{\code{overEdges}}
#'   \item{\code{outNode}}
#'   \item{\code{outNodes}}
#'   \item{\code{outEdge}}
#'   \item{\code{outEdges}}
#' }
#' The corresponding Shiny events to observe have the same name, only written in
#' lowercase, words separated with underscores, and prefixed with the
#' \code{outputId} of the \code{sigmajsOutput()}. For example, when \code{outputId}
#' is "graph": the \code{clickNode} event in Shiny becomes \code{input$graph_click_node},
#' the \code{overNode} event in Shiny becomes \code{input$graph_over_node}, and
#' so on.
#'
#' @examples
#' library(shiny)
#'
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#'
#' ui <- fluidPage(
#'   sigmajsOutput("graph"),
#'   p("Click on a node"),
#'   verbatimTextOutput("clicked")
#' )
#'
#' server <- function(input, output){
#'   output$graph <- renderSigmajs({
#'     sigmajs() %>%
#'       sg_nodes(nodes, id, size, color) %>%
#'       sg_edges(edges, id, source, target) %>%
#'       sg_events("clickNode")
#'   })
#'
#'   # capture node clicked (only fires when a new node is clicked)
#'   output$clicked <- renderPrint({
#'     c(list(clickTime = Sys.time()), input$graph_click_node)
#'   })
#' }
#'
#' \dontrun{shinyApp(ui, server)}
#'
#' server2 <- function(input, output){
#'   output$graph <- renderSigmajs({
#'     sigmajs() %>%
#'       sg_nodes(nodes, id, size, color) %>%
#'       sg_edges(edges, id, source, target) %>%
#'       sg_events(list(list(event = "clickNode", priority = "event")))
#'   })
#'
#'   # capture node clicked (every time, also when clicking the same node again)
#'   output$clicked <- renderPrint({
#'     c(list(clickTime = Sys.time()), input$graph_click_node)
#'   })
#' }
#'
#' \dontrun{shinyApp(ui, server2)}
#'
#' @seealso
#' \href{https://github.com/jacomyal/sigma.js/wiki/Events-API}{official sigmajs documentation},
#' \href{https://shiny.rstudio.com/articles/communicating-with-js.html}{Shiny article about communicating with JavaScript}.
#'
#' @return An object of class \code{htmlwidget} which renders the visualisation on print.
#'
#' @export
sg_events <- function(sg, events){
  if (missing(events))
    stop("Must specify events, see events section in man page.")

  sg$x$events <- append(sg$x$events, as.list(events))
  return(sg)
}
