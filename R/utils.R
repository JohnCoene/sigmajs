.build_data <- function(data, ...){
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame
  base
}

.as_list(data){
  apply(data, 1, as.list)
}
