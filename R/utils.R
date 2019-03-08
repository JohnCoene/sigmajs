globalVariables(c("from", "to", "."))

.build_data <- function(data, ...){
  data %>% 
    dplyr::select(...)
}

.as_list <- function(data){
  apply(data, 1, as.list) %>%  # json formatted list
    unname() # in case of row.names
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

.add_image <- function(sg, data) {
  .rename <- function(x){
    x[x == ""] <- "image"
    x
  }
  
  imgs <- apply(data, 1, function(x) list(as.list(x))) %>% 
    purrr::set_names(rep("image", length(.)))
  
  imgs <- purrr::map2(sg$x$data$nodes, imgs, append)
  
  n <- purrr::map(imgs, names) %>% 
    purrr::map(.rename)
  
  imgs <- purrr::map2(imgs, n, purrr::set_names)
  
  sg$x$data$nodes <- imgs
	sg
}

.data_2_df <- function(x){
  if(is.null(x))
    stop("must have both edges and nodes to compute layout")
  
  do.call("rbind.data.frame", lapply(x, as.data.frame, stringsAsFactors = FALSE))
}

.re_order <- function(x){
  n <- names(x)
  
  cols <- c("source", "target")
  
  first <- n[n %in% cols]
  last <- n[!n %in% cols]
  
  x[, c(first, last)]
}

.re_order_nodes <- function(x){
  n <- names(x)
  
  id <- c("id")
  
  first <- n[n %in% id]
  last <- n[!n %in% id]
  
  x[, c(first, last)]
}

.rm_x_y <- function(x){
  x$x <- NULL
  x$y <- NULL
  return(x)
}

.valid_events <- function(){
  c("force_start", "force_stop", "noverlap", 
    "drag_nodes", "relative_size", "add_nodes", 
    "add_edges", "drop_nodes", "drop_edges", 
    "animate", "export_svg", "export_img",
    "add_nodes_edges", "progress", "read_exec")
}


.test_sg <- function(sg){
  if(!inherits(sg, "sigmajs"))
    stop("sg must be of class sigmajs", call. = FALSE)
}

.test_proxy <- function(p){
  if (!inherits(p, "sigmajsProxy"))
    stop("proxy must be of class sigmajsProxy", call. = FALSE)
}

.get_graph <- function(){
  graph <- tryCatch(
    get("igraph", envir = storage_env),
    error = function(e) NULL
  )
}

.build_igraph <- function(edges, directed = FALSE, nodes, save = TRUE){
  
  g <- .get_graph()
  
  if(is.null(g)){
    g <- igraph::graph_from_data_frame(edges, directed, nodes)
    
    if(isTRUE(save))
      assign("igraph", g, envir = storage_env)
  } 
  
  return(g)
  
}

.make_rand_id <- function(){
  paste0(sample(LETTERS, 5), 1:9, collapse = "")
}

.grp <- function(x, y){
  list(
    nodes = x,
    edges = y
  )
}