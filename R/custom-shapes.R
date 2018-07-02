#' Custom shapes
#' 
#' Indicate a graph uses custom shapes
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#'
#' @export
sg_custom_shapes <- function(sg) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

  .test_sg(sg)

	sg$x$customShapes <- TRUE
	sg
}

#' Add images to nodes
#'
#' Add images to nodes with the \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.renderers.customShapes}{Custom Shapes plugin}.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param data Data.frame containing columns.
#' @param url URL of image.
#' @param ... Any other column.
#'
#' @seealso \href{https://github.com/jacomyal/sigma.js/tree/master/plugins/sigma.renderers.customShapes}{Official documentation}
#' 
#' @examples
#' \dontrun{
#' demo("custom-shapes", package = "sigmajs")
#' }
#'
#' @export
sg_add_images <- function(sg, data, url, ...) {

	if (missing(sg) || missing(url) || missing(data))
		stop("missing sg, url or data", call. = FALSE)

  .test_sg(sg)

	if (!length(sg$x$data$nodes))
		stop("missing nodes", call. = FALSE)

	if (length(sg$x$data$nodes) != nrow(data))
		stop("data must have as many rows as nodes", call. = FALSE)

	data <- .build_data(data, url, ...)

	sg <- .add_image(sg, data)

	sg %>%
		sg_custom_shapes()
}