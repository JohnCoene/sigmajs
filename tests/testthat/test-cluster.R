library(testthat)

context("Cluster")

test_that("clusters", {
  
  nodes <- sg_make_nodes() 
  edges <- sg_make_edges(nodes)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size) %>% 
    sg_edges(edges, id, source, target) %>% 
    sg_layout() %>% 
    sg_cluster(quiet = FALSE)
  
  expect_error(sg_nodes(nodes, id, size))
  expect_error(sg_edges(nodes, id, size))
  
  clustered <- sg_get_cluster(nodes, edges)
  
  expect_error(sg_get_cluster())
  
  expect_s3_class(clustered, "data.frame")
})
