# sigmajs

[sigmajs](http://sigmajs.org/) for R.

With the rise in popularity of networks, it is important for R users to have access to a package that allows visualising the aforementioned networks in a highly configurable, interactive and dynamic manner.
`sigmajs` is [Shiny](https://shiny.rstudio.com/)-centric in order to best leverage the [original library](http://sigmajs.org/)'s great many methods.

All graphs must be initialised with the `sigmajs()` function, all proxies end in `_p`, functions are pipe-friendly (`%>%`).

# Install

```r
# install.packages("devtools")
devtools::install_github("JohnCoene/sigmajs")
```

# Examples

Most functions have corresponding `demo()`.

```r
library(sigmajs)

# generate data
nodes <- sg_make_nodes()
edges <- sg_make_edges(nodes)

# visualise
sigmajs() %>%
	sg_nodes(nodes, id, label, size, color) %>%
	sg_edges(edges, id, source, target) %>%
	sg_settings(defaultNodeColor = "#0011ff")

# from igraph 
data("lesmis_igraph")
 
sigmajs() %>%
	sg_from_igraph(lesmis_igraph) %>%
	sg_settings(defaultNodeColor = "#000")

# proxies demos
demo(package = "sigmajs")
```
