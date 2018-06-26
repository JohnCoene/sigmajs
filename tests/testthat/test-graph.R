library(testthat)

context("Testing graph")

test_that("nodes & edges", {
  nodes <- sg_make_nodes()
  edges <- sg_make_edges(nodes)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size)
  
  expect_equal(length(sg$x$data), 1)
  
  sg <- sg %>% 
    sg_edges(edges, id, source, target)
  
  expect_equal(length(sg$x$data), 2)
})

test_that("delay", {
  
  set.seed(19880525)
  
  # initial nodes
  nodes <- sg_make_nodes()
  
  # additional nodes
  nodes2 <- sg_make_nodes()
  nodes2$id <- as.character(seq(11, 20))
  
  # add delay
  nodes2$delay <- runif(nrow(nodes2), 500, 1000)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color)
  
  expect_gt(length(sg$x$addNodesDelay), 0)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color, cumsum = TRUE)
  
  expect_equal(
    unlist(unname(sg$x$addNodesDelay[[1]][5])), 
    " 566.004")
  
  edges <- sg_make_edges(nodes, 25)
  edges$delay <- runif(nrow(edges), 100, 2000)
  
  sg <- sg %>% 
    sg_add_edges(edges, delay, id, source, target, cumsum = FALSE)
  
  expect_gt(length(sg$x$addNodesDelay) + length(sg$x$addEdgesDelay), 1)
})