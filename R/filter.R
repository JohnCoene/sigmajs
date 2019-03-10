#' FIlter
#' 
#' Filter nodes and/or edges.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param input A Shiny input.
#' @param var Variable to filter.
#' @param target Target of filter, \code{nodes}, \code{edges}, or \code{both}.
#' @param name Name of the filter, useful to undo the filter later on with \code{sg_filter_undo}.
#' @param node Node id to filter neighbours.
#' 
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_filter_gt_p} Filter greater than \code{var}.}
#'   \item{\code{sg_filter_lt_p} Filter less than \code{var}.}
#'   \item{\code{sg_filter_eq_p} Filter equal to \code{var}.}
#'   \item{\code{sg_filter_not_eq_p} Filter not equal to \code{var}.}
#'   \item{\code{sg_filter_undo_p} Undo filters, accepts vector of \code{name}s.}
#' }
#' 
#' @examples 
#' # demo("filter-nodes", package = "sigmajs")
#' 
#' @rdname filter
#' @export
sg_filter_gt_p <- function(proxy, input, var, target = c("nodes", "edges", "both"), name = NULL){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = match.arg(target),
    name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_gt_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_lt_p <- function(proxy, input, var, target = c("nodes", "edges", "both"), name = NULL){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = match.arg(target),
    name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_lt_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_eq_p <- function(proxy, input, var, target = c("nodes", "edges", "both"), name = NULL){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = match.arg(target),
    name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_eq_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_not_eq_p <- function(proxy, input, var, target = c("nodes", "edges", "both"), name = NULL){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = match.arg(target),
    name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_not_eq_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_undo_p <- function(proxy, name){
  
  if (missing(proxy) || missing(name))
    stop("must pass proxy and name", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id,
    name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_undo_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_neighbours_p <- function(proxy, node, name = NULL){
  if (missing(proxy) || missing(node))
    stop("must pass proxy and node id", call. = FALSE)
  
  .test_proxy(proxy)

  message <- list(
    id = proxy$id,
    node = node,
		name = name
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_neighbours_p", message)
  
  return(proxy)
}