#' Change
#'
#' Change nodes and edges attributes on the fly
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param data \code{data.frame} holding \code{delay} column.
#' @param attribute Name of attribute to change.
#' @param value Column containing value.
#' @param rate Rate at chich to refresh takes \code{once} refreshes once after all \code{values} have been changed, 
#'  and \code{iteration} which refreshes at every iteration.
#' @param refresh Whether to refresh the graph after the change is made.
#' 
#' @examples
#' 
#' library(shiny)
#' 
#' nodes <- sg_make_nodes()
#' nodes$new_color <- "red"
#' edges <- sg_make_edges(nodes)
#' 
#' ui <- fluidPage(
#'   actionButton("start", "Change color"), 
#'   sigmajsOutput("sg")
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
#'       sg_change_nodes_p(nodes, new_color, "color")
#'   })
#' 
#' }
#' 
#'  if(interactive()) shinyApp(ui, server) # run
#' 
#' @rdname change
#' @export
sg_change_nodes_p <- function(proxy, data, value, attribute, rate = c("once", "iteration"), refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	if(missing(data) || missing(value) || missing(attribute))
		stop("missing data, value, or attribute", call. = FALSE)

	rate <- match.arg(rate)

	val <- eval(substitute(value), data) 

	message <- list(id = proxy$id, message = list(rate = rate, value = val, attribute = attribute, refresh = refresh)) # create message

	proxy$session$sendCustomMessage("sg_change_nodes_p", message)

	return(proxy)

}

#' @rdname change
#' @export
sg_change_edges_p <- function(proxy, data, value, attribute, rate = c("once", "iteration"), refresh = TRUE) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	if(missing(data) || missing(value) || missing(attribute))
		stop("missing data, value, or attribute", call. = FALSE)

	rate <- match.arg(rate)

	val <- eval(substitute(value), data) 

	message <- list(id = proxy$id, message = list(rate = rate, value = val, attribute = attribute, refresh = refresh)) # create message

	proxy$session$sendCustomMessage("sg_change_edges_p", message)

	return(proxy)

}
