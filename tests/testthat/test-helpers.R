library(testthat)

context("Test helpers")

test_that("make nodes and edges", {
  
  n = 20
  
  nodes <- sg_make_nodes(n, colors = c("#FF0000", "#00FF00"))
  edges <- sg_make_edges(nodes, n * 2)
  
  expect_equal(nrow(nodes), n)
  expect_equal(nrow(edges), n * 2)
  expect_error(sg_make_edges())
})
