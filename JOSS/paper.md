---
title: 'sigmajs: An R htmlwidget interface to the sigma.js visualization library'
authors:
  - affiliation: 1
    name: Jean-Philippe Coene
    orcid: 0000-0002-6637-4107
date: 2018-06-27
tags:
  - network analysis
  - visualisation
bibliography: paper.bib
affiliations:
  - index: 1
    name: Department of Public Engagement at the World Economic Forum
---

# Summary

With the rise in popularity of networks, it is important for R users to have access to a package that allows visualising the aforementioned networks in a highly configurable, interactive and dynamic manner. `sigmajs` is a fully-fledged wrapper for the [sigma.js JavaScript library](http://sigmajs.org/).

The sigma.js JavaScript library is described as follows on its [website](http://sigmajs.org/): 

> Sigma is a JavaScript library dedicated to graph drawing. It makes easy to publish networks on Web pages, and allows developers to integrate network exploration in rich Web applications.

The package `sigmajs` [@sigmajs] bridges the sigma.js JavaScript 
library and R [@R2018] via the `htmlwidgets` package [@htmlwidgets]. The package also 
extends the original JavaScript library by providing additional functions, namely using 
the `igraph` package [@igraph] to enable the user to layout and cluster graphs. 
Finally `sigmajs` is also integrated with the `crosstalk` package [@crosstalk] which 
lets graphs be wired to other `htmlwidgets` such as `plotly` [@plotly] and 
`leafelt` [@leaflet].

# Functionality

Graphs are initialised with `sigmajs()`, all other functions start with `sg_`, and its Shiny [@shiny] proxies end with `_p`. Functions can be piped, referring to the magrittr package [@magrittr] pipe operator (`%>%`), to build the desired graph.

* Shiny proxies.
* Crosstalk integration.
* Buttons to trigger various animations and events.
* Possibility to capture graph interactions in Shiny.

The R package `sigmajs` is available on [GitHub](https://github.com/JohnCoene/sigmajs) or 
[Bitbucket](https://bitbucket.org/JohnCoene/sigmajs), issues can be opened on 
[Github](https://github.com/JohnCoene/sigmajs/issues) only. All functions are documented in 
the package (`.Rd` files) as well as [online](http://sigmajs.john-coene.com/) with the R package
`pkgdown` [@pkgdown].

# References
