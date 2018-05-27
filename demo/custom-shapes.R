library(shiny)
library(sigmajs)

nodes <- sg_make_nodes(20)
edges <- sg_make_edges(nodes)

images <- c(
	'https://avatars0.githubusercontent.com/u/163582?s=400&v=4',
	'https://avatars1.githubusercontent.com/u/4196?s=400&v=4',
	'https://avatars3.githubusercontent.com/u/129551?s=400&v=4'
)

ui <- fluidPage(
	sigmajsOutput("sg", height = "100vh")
)

# add images
nodes$url <- sample(images, nrow(nodes), replace = TRUE)
nodes$scale <- 1.3
nodes$clip <- 0.85
nodes$type <- "circle"

server <- function(input, output) {

	# visualise
	output$sg <- renderSigmajs({
		sigmajs(type = "canvas") %>%
			sg_nodes(nodes, id, label, size, color, type) %>%
			sg_add_images(nodes, url, scale, clip) %>%
			sg_edges(edges, id, source, target) %>%
			sg_settings(defaultNodeColor = "#0011ff", minNodeSize = 8, maxNodeSize = 16)
	})
}

shinyApp(ui, server)