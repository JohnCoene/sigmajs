library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, actionButton("add", "add nodes"))
	),
	sigmajsOutput("sg", height = "100vh")
)

server <- function(input, output) {
	ids <- as.character(1:10)

	nodes <- data.frame(
		id = ids,
		label = LETTERS[1:10],
		size = runif(10, 1, 5),
		stringsAsFactors = FALSE
	)

	nodes2 <- data.frame(
		id = 11:50,
		label = sample(LETTERS, 40, replace = TRUE),
		size = runif(40, 1, 5),
		delay = ceiling(rnorm(40, 5000, 1000)),
		stringsAsFactors = FALSE
	)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_settings(
				defaultNodeColor = "#0011ff"
			)
	})

	observeEvent(input$add, {

		sigmajsProxy("sg") %>%
			sg_add_nodes_delay_p(nodes2, delay, id, label, size)
	})
}

shinyApp(ui, server)
