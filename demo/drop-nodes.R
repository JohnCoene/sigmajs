library(shiny)
library(sigmajs)

ui <- fluidPage(
	actionButton("drop", "drop nodes"),
	sliderInput("slider", "# nodes to remove", value = 3, min = 1, max = 10),
	sigmajsOutput("sg")
)

server <- function(input, output) {
	nodes <- sg_make_nodes(100)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, color, size) 
	})

	ids <- nodes$id # all ids

	observeEvent(input$drop, {
		rm <- data.frame(ids = sample(ids, input$slider)) # sample 
		
		sigmajsProxy("sg") %>%
			sg_drop_nodes_p(rm, ids)

		ids <<- ids[!ids %in% rm$ids] # remove ids already removed
		print(length(ids))
	})
}

shinyApp(ui, server)
