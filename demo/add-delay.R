library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, actionButton("add", "add nodes & edges"))
	),
	sigmajsOutput("sg", height = "100vh")
)

server <- function(input, output) {
	ids <- as.character(1:100) # create 100 nodes
	n <- 150 # number of edges

	# create edges with random delay FIRST
	edges <- data.frame(
		id = 1:n,
		source = sample(ids, n, replace = TRUE),
		target = sample(ids, n, replace = TRUE),
		created_at = cumsum(ceiling(rnorm(n, 500, 50))),
		stringsAsFactors = FALSE
	)

	# get source and target
	src <- dplyr::select(edges, id = source, created_at)
	tgt <- dplyr::select(edges, id = target, created_at)

	# nodes appear at their first edge appearance
	nodes <- src %>%
		dplyr::bind_rows(tgt) %>% # bind edges source/target to have "nodes"
		dplyr::group_by(id) %>% # find minimum by id - when node should appear
		dplyr::summarise(
			appear_at = min(created_at) - 1 # Minus one millisecond to ensure node appears BEFORE any edge connecting to it
		) %>%
		dplyr::ungroup() %>%
		dplyr::mutate( # add labels, color and size
			label = sample(LETTERS, n(), replace = TRUE), 
			size = runif(n(), 1, 5),
			color = colorRampPalette(c("#B1E2A3", "#98D3A5", "#328983", "#1C5C70", "#24C96B"))(n())
		)

	# initialise "empty" visualisation
	output$sg <- renderSigmajs({
		sigmajs(type = "webgl") %>% # use webgl
			sg_force()
	})

	# add nodes and edges with delay
	observeEvent(input$add, {
		sigmajsProxy("sg") %>%
			sg_add_nodes_delay_p(nodes, appear_at, id, label, size, color, cumsum = FALSE, refresh = TRUE) %>%
			sg_add_edges_delay_p(edges, created_at, id, source, target, cumsum = FALSE, refresh = TRUE)
	})
}

shinyApp(ui, server)
