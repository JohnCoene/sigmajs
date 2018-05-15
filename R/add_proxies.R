#' Add node
#'
#' Proxy to dynamically add a node.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param nodes A \code{data.frame} of nodes.
#' @param ... any column.
#' 
#' @examples
#' \dontrun{
#' library(shiny)
#' 
#' ui <- fluidPage(
#' 	actionButton("add node"),
#' 	sigmajsOutput("sg")
#' )
#' 
#' server <- function(input, output) {
#'  nodes <- data.frame(
#'    id = ids,
#'    label = LETTERS[1:10],
#'    x = runif(10, 1, 20),
#'    y = runif(10, 1, 20),
#'    size = runif(10, 1, 5),
#'    stringsAsFactors = FALSE
#'  )
#'
#'  edges <- data.frame(
#'    id = 1:15,
#'    source = sample(ids, 15, replace = TRUE),
#'    target = sample(ids, 15, replace = TRUE),
#'    stringsAsFactors = FALSE
#'  )

#'  output$sg <- renderSigmajs({
#'    sigmajs() %>%
#'      sg_nodes(nodes, id, label) %>%
#'      sg_edges(edges, id, source, target)
#'  })
#' }
#' 
#' shinyApp(ui, server)
#' }
#'
#' @rdname add
#' @export
sg_add_node_p <- function(proxy, nodes, ...) {

	if (!"sigmajsProxy" %in% class(proxy))
		stop("must pass sigmajsProxy object", call. = FALSE)

	nodes <- .build_data(nodes, ...) %>%
		.check_ids() %>%
		.check_x_y() %>%
		.as_list()

	message <- list(id = proxy$id, data = nodes)

	proxy$session$sendCustomMessage("sg_add_node_p", message)

	return(proxy)
}