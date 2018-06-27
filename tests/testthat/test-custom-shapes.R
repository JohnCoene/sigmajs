library(testthat)

context("Custom Shapes")

test_that("All custom shapes", {
  nodes <- sg_make_nodes()
  edges <- sg_make_edges(nodes)
  
  IMG <- c(
    'https://avatars0.githubusercontent.com/u/163582?s=400&v=4',
    'https://avatars1.githubusercontent.com/u/4196?s=400&v=4',
    'https://avatars3.githubusercontent.com/u/129551?s=400&v=4'
  )
  SHAPES <- c("circle", "square", "diamond")
  
  nodes$url <- sample(IMG, nrow(nodes), replace = TRUE) # add images
  nodes$type <- sample(SHAPES, nrow(nodes), replace = TRUE) # custom shapes
  nodes$scale <- 1.3
  nodes$clip <- 0.85
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, color, size, type) %>%
    sg_edges(edges, id, source, target) %>%
    sg_layout() 
  
  expect_length(sg$x$data, 2)
  expect_length(sg$x$data$nodes[[1]], 6) # x and y
  
  sg <- sg %>% 
    sg_add_images(nodes, url, scale, clip) %>%
    sg_settings(defaultNodeColor = "#0011ff", minNodeSize = 8, maxNodeSize = 16) 
  
  expect_length(sg$x$data$nodes[[1]], 7) # x and y
})