sigmajs_render <- function(sg){
  assign("igraph", NULL, envir = storage_env)
  return(sg)
}

#' Initialise
#'
#' Initialise a graph.
#' 
#' @param width,height Dimensions of graph.
#' @param elementId Id of elment.
#' @param kill Whether to kill the graph, set to \code{FALSE} 
#' if using \code{\link{sigmajsProxy}}, else set to \code{TRUE}. Only useful in Shiny.
#' @param type Renderer type, one of \code{canvas}, \code{webgl} or \code{svg}.
#' 
#' @examples 
#' nodes <- sg_make_nodes()
#' edges <- sg_make_edges(nodes)
#'
#' sigmajs("svg") %>%
#'   sg_nodes(nodes, id, label, size, color) %>%
#'   sg_edges(edges, id, source, target) 
#'
#' @import htmlwidgets
#' @importFrom stats runif
#' @importFrom htmltools tags
#' 
#' @note Keep \code{width} at \code{100\%} for a responsive visualisation.
#' 
#' @seealso \code{\link{sg_kill}}.
#' 
#' @return An object of class \code{htmlwidget} which renders the visualisation on print.
#' 
#' @export
sigmajs <- function(type = NULL, width = "100%", kill = FALSE, height = NULL, elementId = NULL) {
  
  assign("igraph", NULL, envir = storage_env)

  if(!is.null(type))
    cat("Argument `type` is no longer in use.\n")

  # forward options using x
  x = list(
    events = list(),
    kill = kill,
    data = list(),
		type = type,
		button = list(),
		buttonevent = list(),
		crosstalk = list(
		  crosstalk_key = NULL,
		  crosstalk_group = NULL
		)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sigmajs',
    x,
    width = width,
    height = height,
    package = 'sigmajs',
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      browser.fill = TRUE,
      viewer.fill = TRUE,
      padding = 20
    ),
    preRenderHook = sigmajs_render,
    dependencies = crosstalk::crosstalkLibs()
  )
}

#' Shiny bindings for sigmajs
#'
#' Output and render functions for using sigmajs within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId,id output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a sigmajs
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#' @param session A valid shiny session.
#'
#' @name sigmajs-shiny
#'
#' @export
sigmajsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'sigmajs', width, height, package = 'sigmajs')
}

#' @rdname sigmajs-shiny
#' @export
renderSigmajs <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, sigmajsOutput, env, quoted = TRUE)
}

#' @rdname sigmajs-shiny
#' @export
sigmajsProxy <- function(id, session = shiny::getDefaultReactiveDomain()) {

	proxy <- list(id = id, session = session)
	class(proxy) <- "sigmajsProxy"

	return(proxy)
}
