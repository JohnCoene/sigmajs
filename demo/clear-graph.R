library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(2, actionButton("clear", "Clear graph")),
		column(2, actionButton("kill", "Kill graph"))
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

	observeEvent(input$clear, {
		sigmajsProxy("sg") %>%
			sg_clear_p()
	})
}

shinyApp(ui, server)