#' Add a camera
#'
#' Add a camera to your graph.
#'
#' @param sg An object of class \code{sigmajs}as intatiated by \code{\link{sigmajs}}.
#' @param elementId Id of graph that initialised the camera.
#' @param initialise Whether to initialise the camera.
#'
#' @note Cameras should only be initialised once.
#'
#' @examples
#' \dontrun{
#' demo("add-camera", package = "sigmajs")
#' }
#' 
#' @noRd
#' @keywords internal
sg_camera <- function(sg, elementId = NULL, initialise = FALSE) {
  if (missing(elementId) && !isTRUE(initialise))
    stop("must pass element id if not initialising the camera", call. = FALSE)
  
  if (missing(sg))
    stop("missing sg", call. = FALSE)
  
  if (!inherits(sg, "sigmajs"))
    stop("sg must be of class sigmajs", call. = FALSE)
  
  sg$x$camera <- list(
    init = initialise,
    id = elementId
  )
  
  sg
}