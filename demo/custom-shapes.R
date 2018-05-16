library(shiny)
library(sigmajs)

ui <- fluidPage(
	sigmajsOutput("sg")
)

server <- function(input, output) {
	ids <- as.character(1:10)

	nodes <- data.frame(
	id = ids,
	label = LETTERS[1:10],
	stringsAsFactors = FALSE,
	size = rep(5, 10),
	type = "circle",
	x = runif(10, 1, 10),
	y = runif(10, 1, 10)
)

	nodes <- apply(nodes, 1, as.list)

	url <- "www/img.jpg"

	for (i in 1:length(nodes)) {
		nodes[[i]]$image <- list(url = url)
	}

	edges <- data.frame(
		id = 1:15,
		source = sample(ids, 15, replace = TRUE),
		target = sample(ids, 15, replace = TRUE),
		stringsAsFactors = FALSE
	)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_nodes2(nodes) %>%
			sg_edges(edges, source, target, id) %>%
			sg_custom_shapes()
	})
}

shinyApp(ui, server)