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
#' @param format Format of image, takes \code{png}, \code{jpg}, \code{gif} or \code{tiff}.
#' @param background Background color of image.
#' @param data Whether additional data (node ids for instance) should be included in the svg file.
#' 
#' @examples 
#' nodes <- sg_make_nodes() 
#' edges <- sg_make_edges(nodes, 17)
#' 
#' sigmajs() %>% 
#'   sg_nodes(nodes, id, size) %>% 
#'   sg_edges(edges, id, source, target) %>% 
#'   sg_export_svg() %>% 
#'   sg_button("download", "export_svg")
#' 
#' # demo("export-graph", package = "sigmajs")
#' 
#' @rdname export
#' @export
sg_export_svg <- function(sg, download = TRUE, file = "graph.svg", size = 1000,
                      width = 1000, height = 1000, labels = FALSE, data = FALSE){
  
  if(missing(sg))
    stop("must pass sg", call. = FALSE)
  
  .test_sg(sg)
  
  sg$x$exportSVG <- list(
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
sg_export_img <- function(sg, download = TRUE, file = "graph.png", background = "white",
                          format = "png", labels = FALSE){
  
  if(missing(sg))
    stop("must pass sg", call. = FALSE)
  
  .test_sg(sg)
  
  sg$x$exportIMG <- list(
    format = format,
    download = download, 
    filename = file, 
    background = background,
    labels = labels
  )
  
  sg
}

#' @rdname export
#' @export
sg_export_img_p <- function(proxy, download = TRUE, file = "graph.png", background = "white",
                          format = "png", labels = FALSE){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  df <- list(
    format = format,
    download = download, 
    filename = file, 
    background = background,
    labels = labels
  )
  
  message <- list(id = proxy$id, data = df) # create message
  
  proxy$session$sendCustomMessage("sg_export_img_p", message)
  
  return(proxy)
}

#' @rdname export
#' @export
sg_export_svg_p <- function(proxy, download = TRUE, file = "graph.svg", size = 1000,
                      width = 1000, height = 1000, labels = FALSE, data = FALSE){
  
  if (missing(proxy))
    stop("must pass proxy", call. = FALSE)
  
  .test_proxy(proxy)
  
  # build data
  df <- list(
    download = download, 
    filename = file, 
    size = 1000,
    width = width,
    height = height,
    labels = labels,
    data = data
  )
  
  message <- list(id = proxy$id, data = df) # create message
  
  proxy$session$sendCustomMessage("sg_export_svg_p", message)
  
  return(proxy)
}
