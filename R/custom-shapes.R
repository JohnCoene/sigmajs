#' Custom shapes
#' 
#' Indicate a graph uses custom shapes
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#'
#' @export
sg_custom_shapes <- function(sg) {
	sg$x$customShapes <- TRUE
	sg
}