library(testthat)

context("Testing remaining functions")

test_that("test init", {
  nodes <- sg_make_nodes()
  expect_error(sg_make_edges())
  edges <- sg_make_edges(nodes, 20)
  
  sg <- sigmajs() %>% 
    sg_settings(nodeDefaultColor = "blue")
  
  expect_length(sg$x$settings, 1)
  
  expect_error(sg_export_img())
  expect_error(sg_export_svg())
  expect_error(sg_layout())
  expect_error(sg_get_layout())
  expect_error(sg_layout(mtcars))
})