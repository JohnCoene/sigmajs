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
#' @return An object of class \code{htmlwidget} which renders the visualisation on print.
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

#' Zoom
#'
#' Dynamically Zoom a node.
#'
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param id Node id to zoom to.
#' @param duration Duration of animation.
#' @param ratio The zoom ratio of the graph and its items.
#'
#' @export
sg_zoom_p <- function(proxy, id, ratio = .5, duration = 1000) {

  if (missing(proxy) || missing(id))
    stop("must pass proxy and id", call. = FALSE)
  
  .test_proxy(proxy)

	message <- list(id = proxy$id, node = id, duration = duration, ratio = ratio)

	proxy$session$sendCustomMessage("sg_zoom_p", message)

	return(proxy)
}