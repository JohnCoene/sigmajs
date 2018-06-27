---
title: 'sigmajs:An R htmlwidget interface to the sigma.js visualization library'
authors:
  - affiliation: 1
    name: Jean-Philippe Coene
    orcid: 0000-0002-6637-4107
date: "2 May 2018"
tags:
  - network analysis
  - visualisation
bibliography: paper.bib
---

# Summary

The package `sigmajs` [@sigmajs] bridges the [sigma.js JavaScript](http://sigmajs.org/) 
library and R [@R2018] via the `htmlwidgets` package [@htmlwidgets]. The package also 
extends the original JavaScript library by providing additional functions, namely using 
the `igraph` package [@igraph] that enable the user to layout and cluster graphs. 
Finally `sigmajs` is also integrated with the `crosstalk` package [@crosstalk] which 
enables graphs to be wired to other `htmlwidgets` such as `plotly` [@plotly] and 
`leafelt` [@leaflet].

# Functionality

* Shiny [@shiny] proxies.
* Crosstalk integration.
* Buttons to trigger various animations.
* Capture graph interactions in R.

The R package `sigmajs` is available on [GitHub](https://github.com/JohnCoene/sigmajs).

# References