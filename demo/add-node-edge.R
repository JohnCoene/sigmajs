library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, actionButton("add", "add node & edge")),
		column(3, actionButton("stop", "stop force")),
		column(2, actionButton("start", "start force")),
		column(2, actionButton("restart", "re-start force")),
		column(2, actionButton("kill", "kill force"))
	),
	p(
		"Running forceAtlas2 will not apply to newly added nodes and edges, you will need to 1) add nodes and edges, 2) kill the forceAtlas2 and 3) start forceAtlas2."
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
			sg_settings(
				defaultNodeColor = "#0011ff"
			)
	})

	i <- nrow(edges)
	j <- nrow(nodes)

	observeEvent(input$add, {

		i <<- i + 1
		j <<- j + 1

		edges <- data.frame(
			id = i,
			source = sample(1:j, 1),
			target = sample(1:j, 1)
		)

		nodes <- data.frame(
			id = i,
			size = runif(1, 1, 5),
			label = sample(LETTERS, 1)
		)

		sigmajsProxy("sg") %>%
			sg_add_edge_p(edges, id, source, target) %>%
			sg_add_node_p(nodes, id, label, size)
	})

	observeEvent(input$start, {
		sigmajsProxy("sg") %>%
				sg_force_start_p(worker = TRUE)
	})

	observeEvent(input$stop, {
	sigmajsProxy("sg") %>%
				sg_force_stop_p()
	})

	observeEvent(input$kill, {
		sigmajsProxy("sg") %>%
					sg_force_kill_p()
	})

	observeEvent(input$restart, {
		sigmajsProxy("sg") %>%
					sg_force_restart_p(worker = TRUE)
	})
}

shinyApp(ui, server)
