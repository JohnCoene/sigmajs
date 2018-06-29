library(crosstalk)
library(testthat)

context("Other formats")

test_that("Gexf", {
  gexf <- system.file("examples/arctic.gexf", package = "sigmajs")
  sd <- SharedData$new(mtcars)
  
  sg <- sigmajs() %>% 
    sg_from_gexf(gexf, sd = sd)
  
  expect_true(sg$x$gexf)
  expect_error(sg_from_gexf())
  expect_error(sigmajs() %>% sg_from_gexf())
})

test_that("igraph", {
  data("lesmis_igraph")
  sd <- SharedData$new(mtcars)
  layout <- igraph::layout_with_fr(lesmis_igraph)
  
  sg <- sigmajs() %>%
    sg_from_igraph(lesmis_igraph, layout, sd = sd) %>%
    sg_settings(defaultNodeColor = "#000")
  
  expect_length(sg$x$data, 2)
  expect_error(sg_from_igraph())
  expect_error(sigmajs() %>% sg_from_igraph())
})
