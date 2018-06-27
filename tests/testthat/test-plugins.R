library(testthat)

context("Various plugins")

test_that("Drag nodes", {
  nodes <- sg_make_nodes(20)
  edges <- sg_make_edges(nodes, 35)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size) %>%
    sg_edges(edges, id, source, target) %>%
    sg_drag_nodes()
  
  expect_true(sg$x$dragNodes)
})

test_that("Export", {
  nodes <- sg_make_nodes(20)
  edges <- sg_make_edges(nodes, 35)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size) %>%
    sg_edges(edges, id, source, target) %>%
    sg_export()
  
  expect_length(sg$x$export, 7)
})