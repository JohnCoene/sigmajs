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
	n <- 200 # number of edges

	# create edges with random delay FIRST
	edges <- data.frame(
		id = 1:n,
		source = sample(ids, n, replace = TRUE),
		target = sample(ids, n, replace = TRUE),
		created_at = cumsum(ceiling(rnorm(n, 500, 50))),
		stringsAsFactors = FALSE
	)

	# nodes appear at their first edge appearance
	src <- dplyr::select(edges, id = source, created_at)
	tgt <- dplyr::select(edges, id = target, created_at)

	nodes <- src %>%
		dplyr::bind_rows(tgt) %>% # bind edges source/target
		dplyr::group_by(id) %>% 
		dplyr::summarise(
			appear_at = min(created_at) - 1 # Minus one millisecond to ensure node appears BEFORE any edge connecting to it
		) %>%
		dplyr::ungroup() %>%
		dplyr::mutate(
			label = sample(LETTERS, n(), replace = TRUE), # add labels and size
			size = runif(n(), 1, 5)
		)

	output$sg <- renderSigmajs({
		sigmajs() %>%
			sg_settings(
				defaultNodeColor = "#0011ff",
				nodesPowRatio = 1
			) %>%
			sg_force()
	})

	observeEvent(input$add, {
		sigmajsProxy("sg") %>%
			sg_add_nodes_delay_p(nodes, appear_at, id, label, size, cumsum = FALSE) %>%
			sg_add_edges_delay_p(edges, created_at, id, source, target, cumsum = FALSE) 
	})
}

shinyApp(ui, server)
