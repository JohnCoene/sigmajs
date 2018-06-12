library(shiny)
library(sigmajs)

ui <- fluidPage(
	actionButton("drop", "drop edges"),
	sliderInput("slider", "# edges to remove", value = 3, min = 1, max = 10),
	sigmajsOutput("sg")
)

server <- function(input, output) {
	nodes <- sg_make_nodes(100)
	edges <- sg_make_edges(nodes, 150)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_edges(edges, id, source, target) %>%
			sg_settings(defaultEdgeColor = "#000")
	})

	ids <- edges$id # all ids

	observeEvent(input$drop, {
		rm <- data.frame(ids = sample(ids, input$slider)) # sample 

		sigmajsProxy("sg") %>%
			sg_drop_edges_p(rm, ids)

		ids <<- ids[!ids %in% rm$ids] # remove ids already removed
		print(length(ids))
	})
}

shinyApp(ui, server)