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