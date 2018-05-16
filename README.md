# sigmajs

sigma js for R

### Done

* Add `edges` & `nodes`
* Pass `settings`
* All graph API done
* All of `forceAtlas2` plugin + its proxies
* `refresh` proxy

# Install

```r
devtools::install_github("JohnCoene/sigmajs")
```

# Examples

```r
library(sigmajs)

ids <- as.character(1:10)

nodes <- data.frame(
	id = ids,
	label = LETTERS[1:10],
	size = runif(10, 1, 5),
	stringsAsFactors = FALSE
)

edges <- data.frame(
	id = 1:15,
	source = sample(ids, 15, replace = TRUE),
	target = sample(ids, 15, replace = TRUE),
	stringsAsFactors = FALSE
)

sigmajs() %>%
	sg_nodes(nodes, id, label, size) %>%
	sg_edges(edges, id, source, target) %>%
	sg_settings(
		defaultNodeColor = "#0011ff"
	)

# proxies
demo(package = "sigmajs")
```