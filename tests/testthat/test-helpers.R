library(testthat)

context("Test helpers")

test_that("make nodes and edges", {
  
  n <- 20

  nodes <- sg_make_nodes(n, colors = c("#FF0000", "#00FF00"))
  edges <- sg_make_edges(nodes)
  
  expect_equal(nrow(nodes), n)
  expect_equal(nrow(edges), n)
  expect_error(sg_make_edges())
  expect_warning(sg_make_edges(nodes, 1))
})
