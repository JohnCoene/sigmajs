library(testthat)

context("Testing remaining functions")

test_that("test init", {
  nodes <- sg_make_nodes()
  expect_error(sg_make_edges())
  edges <- sg_make_edges(nodes, 20)
  
  sg <- sigmajs() %>% 
    sg_settings(nodeDefaultColor = "blue") %>% 
    sg_neighbours() %>% 
    sg_noverlap() %>% 
    sg_relative_size()
  
  expect_length(sg$x$settings, 1)
  expect_length(sg$x$neighbours, 2)
  expect_length(sg$x$noverlap, 0)
  expect_equal(sg$x$relativeSize, 1)
  
  expect_error(sg_export_img())
  expect_error(sg_export_svg())
  expect_error(sg_layout())
  expect_error(sg_get_layout())
  expect_error(sg_layout(mtcars))
  expect_error(sg_neighbors())
  expect_error(sg_neighbours())
  expect_error(mtcars %>% sg_neighbors())
  expect_error(mtcars %>% sg_neighbours())
  expect_error(sg_noverlap())
  expect_error(mtcars %>% sg_noverlap())
  expect_error(sg_relative_size())
  expect_error(mtcars %>% sg_relative_size())
  expect_error(sg_cluster())
  expect_error(mycars %>% sg_cluster())
})