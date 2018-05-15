library(shiny)
library(sigmajs)

ui <- fluidPage(
	actionButton("add", "add edge"),
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
			sg_force(worker = TRUE) %>%
			sg_settings(
				defaultNodeColor = "#0011ff"
			)
	})

	i <- nrow(edges)

	observeEvent(input$add, {

	i <<- i+ 1

		df <- data.frame(
			id = i,
			source = sample(ids, 1),
			target = sample(ids, 1)
		)

		sigmajsProxy("sg") %>%
			sg_add_edge_p(df, id, source, target)
	})
}

shinyApp(ui, server)
