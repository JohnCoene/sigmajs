library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(2, selectInput('node', "", selected = 3, choices = 1:20)),
		column(2, actionButton("delete", "Delete node"))
	),
	fluidRow(
		sigmajsOutput("sg", height = "100vh")
	)
)

server <- function(input, output) {

	ids <- as.character(seq(1, 20))

	nodes <- data.frame(
		id = ids,
		label = LETTERS[1:20],
		stringsAsFactors = FALSE,
		size = runif(20, 1, 4)
	)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_settings(
				defaultNodeColor = "#0011ff"
			) 
	})

	observeEvent(input$delete, {
		sigmajsProxy("sg") %>%
			sg_drop_node_p(as.character(input$node), refresh = FALSE) %>%
			sg_refresh_p()
	})
}

shinyApp(ui, server)