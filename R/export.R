#' Export
#' 
#' Export graph to SVG.
#' 
#' @inheritParams sg_nodes
#' @param proxy An object of class \code{sigmajsProxy} as returned by \code{\link{sigmajsProxy}}.
#' @param download set to \code{TRUE} to download.
#' @param file Name of file.
#' @param size Size of the SVG in pixels.
#' @param width,height Width and height of the SVG in pixels.
#' @param labels Whether the labels should be included in the svg file.
#' @param data Whether additional data (node ids for instance) should be included in the svg file.
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 17)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_export() %>% 
#'   sg_button("download", "export")
#' 
#' # demo("export-graph", package = "sigmajs")
#' 
#' @rdname export
#' @export
sg_export <- function(sg, download = TRUE, file = "graph.svg", size = 1000,
                      width = 1000, height = 1000, labels = FALSE, data = FALSE){
  sg$x$export <- list(
    download = download, 
    filename = file, 
    size = 1000,
    width = width,
    height = height,
    labels = labels,
    data = data
  )
  
  sg
}

#' @rdname export
#' @export
sg_export_p <- function(proxy, download = TRUE, file = "graph.svg", size = 1000,
                      width = 1000, height = 1000, labels = FALSE, data = FALSE){
  
  if (!"sigmajsProxy" %in% class(proxy))
    stop("must pass sigmajsProxy object", call. = FALSE)
  
  # build data
  data <- list(
    download = download, 
    filename = file, 
    size = 1000,
    width = width,
    height = height,
    labels = labels,
    data = data
  )
  
  message <- list(id = proxy$id, data = data) # create message
  
  proxy$session$sendCustomMessage("sg_export_p", message)
  
  return(proxy)
}