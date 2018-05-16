library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, actionButton("add", "add edges"))
	),
	sigmajsOutput("sg", height = "100vh")
)

server <- function(input, output) {
	ids <- as.character(1:100)

	nodes <- data.frame(
		id = ids,
		label = sample(LETTERS, 100, replace = TRUE),
		size = runif(100, 1, 5),
		color = colorRampPalette(c("#26469D", "#2A9D8F", "#E9C46A", "#E76F51"))(100),
		stringsAsFactors = FALSE
	)

	n <- 200 # number of edges
	edges <- data.frame(
		id = 1:n,
		source = sample(ids, n, replace = TRUE),
		target = sample(ids, n, replace = TRUE),
		delay = ceiling(rnorm(n, 500, 50)),
		stringsAsFactors = FALSE
	)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size, color) %>%
			sg_settings(
				defaultNodeColor = "#0011ff",
				nodesPowRatio = 1
			) %>%
			sg_force() 
	})

	observeEvent(input$add, {
		sigmajsProxy("sg") %>%
			sg_add_edges_delay_p(edges, delay, id, source, target)
	})
}

shinyApp(ui, server)
