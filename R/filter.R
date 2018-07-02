#' FIlter
#' 
#' Filter nodes and/or edges.
#' 
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param input A Shiny input.
#' @param var Variable to filter.
#' @param target Target of filter, \code{nodes}, \code{edges}, or \code{both}.
#' 
#' @section Functions:
#' \itemize{
#'   \item{\code{sg_filter_gt_p} Filter greater than \code{var}.}
#'   \item{\code{sg_filter_lt_p} Filter less than \code{var}.}
#' }
#' 
#' @examples 
#' # demo("filter-nodes", package = "sigmajs")
#' 
#' @rdname filter
#' @export
sg_filter_gt_p <- function(proxy, input, var, target = "nodes"){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = target
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_gt_p", message)
  
  return(proxy)
}

#' @rdname filter
#' @export
sg_filter_lt_p <- function(proxy, input, var, target = "nodes"){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  message <- list(
    id = proxy$id, 
    input = input, 
    var = var,
    target = target
  ) 
  
  proxy$session$sendCustomMessage("sg_filter_lt_p", message)
  
  return(proxy)
}