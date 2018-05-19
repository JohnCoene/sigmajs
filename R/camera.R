#' Add a camera
#'
#' Add a camera to your graph.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param name Name of camera.
#' @param initialise Whether to initialise the camera.
#'
#' @note Cameras should only be initialised once, hence the argument.
#'
#' @examples
#' \dontrun{
#' demo("add-camera", package = "sigmajs")
#' }
#' 
#' @export
sg_camera <- function(sg, name, initialise = TRUE) {
	if (missing(name))
		stop("missing name", call. = FALSE)

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

	sg$x$initialiseCamera <- initialise
	sg$x$cameraName <- name

	sg
}