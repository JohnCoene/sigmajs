library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, sliderInput("n", "number of edges", value = 2, min = 2, max = 20, step = 1)),
		column(3, actionButton("add", "add edges"))
	),
	fluidRow(
		column(12, sigmajsOutput("sg", height = "99vh"))
	)
)

server <- function(input, output) {
	ids <- as.character(1:100)

	nodes <- data.frame(
		id = ids,
		label = sample(LETTERS, 100, replace = TRUE),
		stringsAsFactors = FALSE
	)

	edges <- data.frame(
		id = 1:nrow(nodes),
		source = sample(ids, 20, replace = TRUE),
		target = sample(ids, 20, replace = TRUE),
		stringsAsFactors = FALSE
	)

	# minimum id
	min <- 102
	reactive_data <- reactive({

		id <- seq(min, (min + input$n - 1))
		source <- sample(ids, input$n, replace = TRUE)
		target <- sample(ids, input$n, replace = TRUE)

		min <<- min + input$n + 3 # increment minimum id

		data.frame(
			id = as.character(id),
			source = source,
			target = target
		)
	})

	output$sg <- renderSigmajs({
		sigmajs(type = "webgl") %>%
			sg_nodes(nodes, id, label) %>%
			sg_edges(edges, id, source, target) %>% 
			sg_settings(defaultNodeColor = "#0011ff")
	})

	observeEvent(input$add, {
		sigmajsProxy("sg") %>%
			sg_force_kill_p() %>% 
			sg_add_edges_p(reactive_data(), id, source, target) %>%
			sg_force_start_p()
	})
}

shinyApp(ui, server)