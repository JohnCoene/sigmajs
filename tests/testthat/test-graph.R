library(testthat)
library(crosstalk)

context("Testing graph")

test_that("nodes & edges", {
  nodes <- sg_make_nodes()
  edges <- sg_make_edges(nodes)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size)
  
  expect_equal(length(sg$x$data), 1)
  
  sg <- sg %>% 
    sg_edges(edges, id, source, target)
  
  expect_equal(length(sg$x$data), 2)
  
  sd <- SharedData$new(nodes)
  
  sg <- sigmajs() %>% 
    sg_nodes(sd, id, size)
})

test_that("delay", {
  
  set.seed(19880525)
  
  # initial nodes
  nodes <- sg_make_nodes()
  
  # additional nodes
  nodes2 <- sg_make_nodes()
  nodes2$id <- as.character(seq(11, 20))
  
  # add delay
  nodes2$delay <- runif(nrow(nodes2), 500, 1000)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color)
  
  expect_gt(length(sg$x$addNodesDelay), 0)
  
  sg <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color, cumsum = TRUE)
  
  expect_equal(
    unlist(unname(sg$x$addNodesDelay[[1]][5])), 
    " 566.004")
  
  edges <- sg_make_edges(nodes, 25)
  edges$delay <- runif(nrow(edges), 100, 2000)
  
  sg <- sg %>% 
    sg_add_edges(edges, delay, id, source, target, cumsum = FALSE)
  
  expect_gt(length(sg$x$addNodesDelay) + length(sg$x$addEdgesDelay), 1)
})

test_that("function bis", {
  
  nodes <- sg_make_nodes()
  edges <- sg_make_edges(nodes)
  
  sg <- sigmajs() %>% 
    sg_nodes2(nodes) %>% 
    sg_edges2(edges)
  
  expect_error(sg_nodes2())
  expect_error(sg_edges2())
  expect_error(sigmajs() %>% sg_nodes2())
  expect_error(sigmajs() %>% sg_edges2())
})

test_that("Add funs", {
  
  set.seed(19880525)
  
  nodes <- sg_make_nodes()
  
  # additional nodes
  nodes2 <- sg_make_nodes()
  nodes2$id <- as.character(seq(11, 20))
  
  # add delay
  nodes2$delay <- runif(nrow(nodes2), 500, 1000)
  
  sg1 <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color, cumsum = TRUE)
  
  expect_length(sg1$x$addNodesDelay, 10)
  
  edges <- sg_make_edges(nodes, 25)
  edges$delay <- runif(nrow(edges), 100, 2000)
  
  sg2 <- sigmajs() %>%
    sg_nodes(nodes, id, label, size, color) %>% 
    sg_add_edges(edges, delay, id, source, target, cumsum = TRUE) 
  
  expect_length(sg2$x$addEdgesDelay, 2)
  
  nodesd <- SharedData$new(nodes, key = nodes$id)
  
  sg3 <- sigmajs() %>%
    sg_nodes(nodesd, id, label, size, color) %>%
    sg_add_nodes(nodes2, delay, id, label, size, color, cumsum = TRUE)
  
  expect_length(sg3$x$addNodesDelay, 10)
  
  expect_error(sg_add_nodes())
  expect_error(mtcars %>% sg_add_nodes())
  expect_error(sg_add_edges())
  expect_error(mtcars %>% sg_add_edges())
})

test_that("Drop funs", {
  
  set.seed(19880525)
  
  nodes <- sg_make_nodes(50)
  edges <- sg_make_edges(nodes)
  
  # nodes & edges to drop
  nodes2 <- nodes[sample(nrow(nodes), 50), ]
  nodes2$delay <- runif(nrow(nodes2), 1000, 3000)
  
  edges2 <- edges[sample(nrow(edges), 50), ]
  edges2$delay <- runif(nrow(edges2), 1000, 3000)
  
  sg <- sigmajs() %>% 
    sg_nodes(nodes, id, size, color) %>% 
    sg_drop_nodes(nodes2, id, delay, cumsum = FALSE) %>% 
    sg_drop_edges(edges2, id, delay)
  
  expect_length(sg$x$dropNodesDelay, 50)
  expect_length(sg$x$dropEdgesDelay, 2)
  
})
  