library(testthat)

context("Testing buttons")

test_that("Buttons", {

  nodes <- sg_make_nodes() 
  edges <- sg_make_edges(nodes, 17)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size) %>% 
    sg_edges(edges, id, source, target) %>% 
    sg_force_start() %>% 
    sg_button("force_start", "start layout", class = "btn btn-primary")
  
  expect_gt(length(sg$x$button), 0)
  
  expect_error(sg_button())
  expect_error(
    sigmajs() %>% 
      sg_button()
  )
  
  expect_error(
    sigmajs() %>% 
      sg_button("name", "error")
  )
})
