#' Text
#' 
#' Add text to your graph.
#' 
#' @inheritParams sg_nodes
#' @param data Data.frame holding \code{delay} and \code{text}.
#' @param delay Delay, in milliseconds at which text should appear.
#' @param text Text to appear on graph.
#' @param position Text position on graph.
#' @param cumsum Whether to compute the cumulative sum on the \code{delay}.
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
#'   sg_button("add", "add_nodes") %>% 
#'   sg_progress(nodes2, delay, text)
#' 
#' @export
sg_progress <- function(sg, data, delay, text, position = "right", cumsum = TRUE){
  
  if(missing(data) || missing(delay) || missing(text))
    stop("missing data, delay or text")
  
  delay_col <- eval(substitute(delay), data) # subset delay
  if (isTRUE(cumsum))
    delay_col <- cumsum(delay_col) # cumul for setTimeout
  
  text <- eval(substitute(text), data) # subset ids
  data <- data.frame(delay = delay_col, text = text)
  
  sg$x$progressBar <- list(
    position = position,
    data = apply(data, 1, as.list)
  )
  
  sg
}