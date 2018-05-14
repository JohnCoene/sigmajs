#' Initialise
#'
#' Initialise a graph.
#' 
#' @param width,height Dimensions of graph.
#' @param elementId Id of elment.
#'
#' @import htmlwidgets
#' @importFrom stats runif
#'
#' @export
sigmajs <- function(width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = list(),
    settings = list()
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sigmajs',
    x,
    width = width,
    height = height,
    package = 'sigmajs',
    elementId = elementId
  )
}

#' Shiny bindings for sigmajs
#'
#' Output and render functions for using sigmajs within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a sigmajs
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
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
