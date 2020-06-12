# sigmajs

[![Travis-CI Build Status](https://travis-ci.org/JohnCoene/sigmajs.svg?branch=master)](https://travis-ci.org/JohnCoene/sigmajs) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/JohnCoene/sigmajs?branch=master&svg=true)](https://ci.appveyor.com/project/JohnCoene/sigmajs) [![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable) [![bitbucket](https://img.shields.io/bitbucket/pipelines/JohnCoene/sigmajs.svg)](https://bitbucket.org/JohnCoene/sigmajs) [![CRAN status](https://www.r-pkg.org/badges/version/sigmajs)](https://cran.r-project.org/package=sigmajs) 
[![CircleCI](https://img.shields.io/circleci/project/github/JohnCoene/sigmajs.svg)](https://github.com/JohnCoene/sigmajs) [![Coverage status](https://coveralls.io/repos/github/JohnCoene/sigmajs/badge.svg)](https://coveralls.io/r/JohnCoene/sigmajs?branch=master) [![Coverage status](https://codecov.io/gh/JohnCoene/sigmajs/branch/master/graph/badge.svg)](https://codecov.io/github/JohnCoene/sigmajs?branch=master) [![DOI](http://joss.theoj.org/papers/10.21105/joss.00814/status.svg)](https://doi.org/10.21105/joss.00814) [![twinetverse](https://img.shields.io/badge/twinetverse-0.0.2-yellow.svg)](http://twinetverse.john-coene.com/)
[![CRAN log](http://cranlogs.r-pkg.org/badges/grand-total/sigmajs)](http://cranlogs.r-pkg.org/badges/sigmajs) [![R build status](https://github.com/JohnCoene/sigmajs/workflows/R-CMD-check/badge.svg)](https://github.com/JohnCoene/sigmajs/actions)

<img src="./man/figures/logo.png" height="150" align="right" />

[sigmajs](http://sigmajs.org/) for R.

* [Install](#install)
* [Examples](#examples)
* [Website](http://sigmajs.john-coene.com/)
* [Shiny Demo](http://shiny.john-coene.com/sigmajs/)

With the rise in popularity of networks, it is important for R users to have access to a package that allows visualising the aforementioned networks in a highly configurable, interactive and dynamic manner. `sigmajs` is a fully-fledged wrapper for the [sigma.js JavaScript library](http://sigmajs.org/).

The sigma.js JavaScript library is described as follows on its [website](http://sigmajs.org/): 

> Sigma is a JavaScript library dedicated to graph drawing. It makes easy to publish networks on Web pages, and allows developers to integrate network exploration in rich Web applications

# Install

The stable version from CRAN.

```r
install.packages("sigmajs")
```

The development version from Github of Bitbucket.

```r
# install.packages("devtools")
devtools::install_github("JohnCoene/sigmajs") # github
devtools::install_bitbucket("JohnCoene/sigmajs") # bitbucket
```

# Examples

Most functions have corresponding `demo()`, see [documentation](http://sigmajs.john-coene.com/) and [shiny demo](http://shiny.john-coene.com/sigmajs/).

```r
library(sigmajs)

# generate data
nodes <- sg_make_nodes()
edges <- sg_make_edges(nodes)

# visualise
sigmajs() %>%
	sg_nodes(nodes, id, label, size, color) %>%
	sg_edges(edges, id, source, target)

# from igraph 
data("lesmis_igraph")
 
layout <- igraph::layout_with_fr(lesmis_igraph)

sigmajs() %>%
	sg_from_igraph(lesmis_igraph, layout)

# from GEXF
gexf <- system.file("examples/arctic.gexf", package = "sigmajs")

sigmajs() %>% 
	sg_from_gexf(gexf) 

# proxies demos
demo(package = "sigmajs")
```

![](https://raw.githubusercontent.com/JohnCoene/sigmajs/master/pkgdown/delay.gif)

## Contributing

See the [contrinuting guidelines](https://github.com/JohnCoene/sigmajs/blob/master/CONTRIBUTING.md) if you encounter any issue. Please note that this project is released with a [Contributor Code of Conduct](https://github.com/JohnCoene/sigmajs/blob/master/CONDUCT.md). By participating in this project you agree to abide by its terms.
