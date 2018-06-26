library(testthat)

context("Animate")

test_that("test all animate", {
  
  # generate graph
  nodes <- sg_make_nodes(20)
  edges <- sg_make_edges(nodes, 30)
  
  # add transition
  n <- nrow(nodes)
  nodes$to_x <- runif(n, 5, 10)
  nodes$to_y <- runif(n, 5, 10)
  nodes$to_size <- runif(n, 5, 10)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color, to_x, to_y, to_size) %>%
    sg_edges(edges, id, source, target) %>% 
    sg_animate(mapping = list(x = "to_x", y = "to_y", size = "to_size"),
               options = list(something = "x"))
  
  expect_equal(length(sg$x$animateOptions), 1)
})