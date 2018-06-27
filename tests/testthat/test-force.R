library(testthat)

context("Force")

test_that("All force", {
  nodes <- sg_make_nodes(50)
  edges <- sg_make_edges(nodes, 100)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size) %>%
    sg_edges(edges, id, source, target) %>% 
    sg_force() %>% 
    sg_force_stop() 
  
  expect_length(sg$x$force, 0)
  expect_equal(sg$x$forceStopDelay, 5000)
  
  expect_error(sg_force())
  expect_error(sg_force_stop())
})