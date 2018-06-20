globalVariables(c("from", "to"))

.build_data <- function(data, ...){
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame
  return(base)
}

.as_list <- function(data){
  apply(data, 1, as.list) # json formatted list
}

.check_ids <- function(data){
  if(!"id" %in% names(data))
    stop("missing ids", call. = FALSE)
  else 
    data$id <- as.character(data$id)
  return(data)
}

.check_x_y <- function(data){
  if(!"x" %in% names(data))
    data$x <- runif(nrow(data), 1, 20)
  
  if(!"y" %in% names(data))
    data$y <- runif(nrow(data), 1, 20)
  return(data)
}

# returns TRUE if image used in nodes
.init_custom_shapes <- function(nodes) {
	if ("image" %in% names(nodes))
		TRUE
	else
		FALSE
}

.add_image <- function(sg, data) {
	for (i in 1:nrow(data)) {
		sg$x$data$nodes[[i]]$image <- list()
		for (j in 1:ncol(data)) {
			sg$x$data$nodes[[i]]$image[[names(data)[j]]] <- as.character(data[i, j])
		}
	}
	#sg$x$data$nodes <- jsonlite::toJSON(sg$x$data$nodes, auto_unbox = TRUE)
	sg
}

.data_2_df <- function(x){
  do.call("rbind.data.frame", lapply(x, as.data.frame))
}

.re_order <- function(x){
  n <- names(x)
  
  first <- n[n %in% c("source", "target")]
  last <- n[!n %in% c("source", "target")]
  
  x[, c(first, last)]
}

.rm_x_y <- function(x){
  x$x <- NULL
  x$y <- NULL
  return(x)
}