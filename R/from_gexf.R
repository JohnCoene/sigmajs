#' Graph from GEXF file
#'
#' Create a sigmajs graph from a GEXF file.
#'
#' @inheritParams sg_nodes
#' @param file Path to GEXF file.
#'
#' @examples
#' gexf <- system.file("examples/arctic.gexf", package = "sigmajs")
#' 
#' sigmajs() %>% 
#'   sg_from_gexf(gexf) 
#'
#' @export
sg_from_gexf <- function(sg, file) {

	if (missing(sg))
		stop("missing sg", call. = FALSE)

	if (!inherits(sg, "sigmajs"))
		stop("sg must be of class sigmajs", call. = FALSE)

  read <- suppressWarnings(readLines(file))
	data <- paste(read, collapse = "\n")

	sg$x$data <- data
	sg$x$gexf <- TRUE # indicate coming from GEXF file

	sg
}