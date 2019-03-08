# sigmajs 0.1.3

* `igraph` object saved to speed up computations.
* Added `sg_scale_color` to scale color according to node size.
* `sg_noverlap_p` fixed.
* `sg_zoom_p` added.
* fixed many events callbacks.
* `sg_get_nodes_p` and `sg_get_edges_p` added to retrieve nodes and edges from draw graph.
* `sg_drop_edges_p` and `sg_drop_nodes_p` now function properly.
* The filter family of functions sees the addition of the `name` argument as well as `sg_filter_undo_p` to undo fitlers (by name).
* `sg_clear` added to clear the graph.
* `sg_change_*_p` family added to change nodes and edges attributes on the fly.
* Event improved.
* `sg_read_*_p` family of functions to easily add nodes and edges in bulk.
* `sg_read_delay_*_p` family of functions to easily add nodes and edges in bulk with a delay.

# sigmajs 0.1.2

* Add multiple buttons with `sg_button`.
* `sg_progress` * `sg_button` make use of `htmlwidgets` function to prepend or append elements rather than the previous hacky way; improved performances.
* Improved documentation.
* Works in RStudio viewer.

# sigmajs 0.1.1

* `sg_export` split into `sg_export_img` and `sg_export_svg`.
* Small bugfix where crosstalk `key` and `group` was not initialised in correct FUN. 
* Added support for button to trigger nodes and edges dynamic addition.
* `sg_get_layout` returns nodes with coordinates rather than just the coordinates.
* Graphs open in browser by default + warning is sent to console when using RStudio.
* Added ability to trigger multiple events from the button.
* Fixed bug in cluster and layout function where igraph would error on duplicate vertex name.
* `sg_neighbours` now takes nodes and edges color as argument.

# sigmajs 0.1.0

* [crosstalk](https://rstudio.github.io/crosstalk/) integration.

# sigmajs 0.0.3

* `sg_layout` added - layout graph using `igraph` package.
* `sg_get_layout` added - helper to extract `x` and `y` coordinates, mainly for animations.
* `sg_cluster` added - color nodes by cluster.
* `sg_get_cluster` added - helper to get nodes color by cluster.
* `sg_button` added - Add buttons to trigger events in static documents.
* `sg_export` and `sg_export_p` added - To export the graph.
* `sg_progress` added - show dynamic text.
* `sg_neighbours` (& `sg_neighbors`) added - highlight neighbours on click.
* `sg_filter_gt_p` and `sg_filter_lt_p` added - filter nodes, edges or both.

# sigmajs 0.0.2

[shiny demo](http://shiny.john-coene.com/sigmajs/) added.

Functions added:

* `sg_force_stop` - stops the forceAtlas2 layout after a given delay.
* `sg_force_start` added, same as `sg_force`.
* `sg_add_nodes`, `sg_add_edges` - Add nodes or edges to a static graph.
* `drop_nodes_delay_p`, `drop_edges_delay_p` Proxy to drop nodes or edges with a delay.
* `drop_nodes_delay`, `drop_edges_delay` Drop nodes or edges with a delay.

# sigmajs 0.0.1

Initial version including all plugins and Shiny proxies.
