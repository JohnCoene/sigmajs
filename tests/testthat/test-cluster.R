library(testthat)

context("Cluster")

test_that("clusters", {
  
  nodes <- sg_make_nodes() 
  edges <- sg_make_edges(nodes, 17)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size) %>% 
    sg_edges(edges, id, source, target) %>% 
    sg_layout() %>% 
    sg_cluster()
  
  clustered <- sg_get_cluster(nodes, edges)
})
