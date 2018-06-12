library(shiny)
library(sigmajs)

ui <- fluidPage(
	actionButton("drop", "drop stuff"),
	sliderInput("sliderEdges", "# edges to remove", value = 6, min = 1, max = 10),
	sliderInput("sliderNodes", "# nodes to remove", value = 2, min = 1, max = 10),
	sigmajsOutput("sg")
)

server <- function(input, output) {
	nodes <- sg_make_nodes(100)
	edges <- sg_make_edges(nodes, 150)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_edges(edges, id, source, target) %>%
			sg_settings(defaultEdgeColor = "#000") %>%
			sg_force()
	})

	# all ids
	edge_ids <- edges$id
	node_ids <- nodes$id

	observeEvent(input$drop, {

		# sample
		edge_ids_rm <- data.frame(ids = sample(edge_ids, input$sliderEdges))
		node_ids_rm <- data.frame(ids = sample(node_ids, input$sliderNodes))

		sigmajsProxy("sg") %>%
			sg_drop_edges_p(edge_ids_rm, ids) %>%
			sg_drop_nodes_p(node_ids_rm, ids)

		# remove ids already removed
		edge_ids <<- edge_ids[!edge_ids %in% edge_ids_rm$ids]
		node_ids <<- node_ids[!node_ids %in% node_ids_rm$ids]

	})
}

shinyApp(ui, server)
