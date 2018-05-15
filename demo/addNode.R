library(shiny)
library(sigmajs)

ui <- fluidPage(
	actionButton("add", "add nodes"),
	sigmajsOutput("sg")
)

server <- function(input, output) {
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

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_edges(edges, id, source, target) %>%
			sg_force() %>%
			sg_settings(
				defaultNodeColor = "#0011ff"
			)
	})

	i <- 16

	observeEvent(input$add, {
		i <<- i + 1

		df <- data.frame(
			id = i,
			size = runif(1, 1, 5),
			label = sample(LETTERS, 1)
		)

		sigmajsProxy("sg") %>%
			sg_add_node_p(df, id, label, size)
	})
}

shinyApp(ui, server)
