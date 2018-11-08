#' Text
#' 
#' Add text to your graph.
#' 
#' @inheritParams sg_nodes
#' @param data Data.frame holding \code{delay} and \code{text}.
#' @param delay Delay, in milliseconds at which text should appear.
#' @param text Text to appear on graph.
#' @param tag A Valid \link[htmltools]{tags} function.
#' @param id A valid CSS id.
#' @param position Position of button, \code{top} or \code{bottom}.
#' @param ... Content of the button, complient with \code{htmltools}.
#' @param cumsum Whether to compute the cumulative sum on the \code{delay}.
#' 
#' @details The \code{element} is passed to \href{https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement}{Document.createElement()}
#' and therefore takes any valid \code{tagName}, including, but not limited to; \code{p}, \code{h1}, \code{div}.
#' 
#' @examples 
#' # initial nodes
#' nodes <- sg_make_nodes()
#' 
#' # additional nodes
#' nodes2 <- sg_make_nodes()
#' nodes2$id <- as.character(seq(11, 20))
#' 
#' # add delay
#' nodes2$delay <- runif(nrow(nodes2), 500, 1000)
#' nodes2$text <- seq.Date(Sys.Date(), Sys.Date() + 9, "days")
#' 
#' sigmajs() %>%
#'   sg_nodes(nodes, id, label, size, color) %>%
#'   sg_add_nodes(nodes2, delay, id, label, size, color) %>% 
#'   sg_progress(nodes2, delay, text, element = "h3") %>%
#'   sg_button(c("add_nodes", "progress"), "add") 
#' 
#' @export
sg_progress <- function(sg, data, delay, text, ..., position = "top", id = NULL,
                        tag = htmltools::span, cumsum = TRUE){
  
  if(missing(data) || missing(delay) || missing(text))
    stop("missing data, delay or text")
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  text <- eval(substitute(text), data) # subset ids
  data <- data.frame(delay = delay_col, text = text)
  
  if(is.null(id))
    id <- .make_rand_id()
  
  sg$x$progressBar <- list(
    id = id,
    position = position,
    data = apply(data, 1, as.list)
  )
  
  if(position == "top")
    htmlwidgets::prependContent(sg, tag(id = id, ...))
  else
    htmlwidgets::appendContent(sg, tag(id = id, ...))
}