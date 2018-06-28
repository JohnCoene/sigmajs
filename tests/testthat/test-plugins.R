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
    sg_edges(edges, id, source, target) 
  
  svg <- sg %>%
    sg_export_svg()
  
  expect_length(svg$x$exportSVG, 7)
  
  img <- sg %>% 
    sg_export_img()
  
  expect_length(img$x$exportIMG, 5)
})