#' Graph from GEXF file
#'
#' Create a sigmajs graph from a GEXF file.
#'
#' @inheritParams sg_nodes
#' @param file Path to GEXF file.
#' @param sd A \link[crosstalk]{SharedData} of nodes.
#'
#' @examples
#' \dontrun{
#' gexf <- "https://gephi.org/gexf/data/yeast.gexf"
#' 
#' sigmajs() %>% 
#'   sg_from_gexf(gexf) 
#' }
#' @export
sg_from_gexf <- function(sg, file, sd = NULL) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)
  
  .test_sg(sg)
  
  if(missing(file))
    stop("missing file", call. = FALSE)
  
  if(!is.null(sd)){
    if (crosstalk::is.SharedData(sd)) {
      # crosstalk settings
      sg$x$crosstalk$crosstalk_key <- sd$key()
      sg$x$crosstalk$crosstalk_group <- sd$groupName()
    } 
  } 

  read <- suppressWarnings(readLines(file))
	data <- paste(read, collapse = "\n")

	sg$x$data <- data
	sg$x$gexf <- TRUE # indicate coming from GEXF file
	
	sg
}