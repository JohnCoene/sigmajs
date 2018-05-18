library(shiny)
library(sigmajs)

nodes <- sg_make_nodes(20)
edges <- sg_make_edges(nodes)

images <- c('img1.png', 'img2.png', 'img3.png', 'img4.png')
images <- paste0("img/", images)

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