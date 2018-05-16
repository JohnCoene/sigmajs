library(shiny)
library(sigmajs)

ui <- fluidPage(
	fluidRow(
		column(3, sliderInput("n", "number of nodes", value = 5, min = 2, max = 20, step = 1)),
		column(3, actionButton("add", "add nodes"))
	),
	fluidRow(
		column(12, sigmajsOutput("sg", height = "99vh"))
	)
)

server <- function(input, output) {
	ids <- as.character(1:10)

	nodes <- data.frame(
		id = ids,
		label = LETTERS[1:10],
		size = runif(10, 1, 5),
		stringsAsFactors = FALSE
	)

	# minimum id
	min <- 11
	reactive_data <- reactive({
		
		ids <- seq(min, (min + input$n - 1))
		labels <- sample(LETTERS, input$n, replace = TRUE)
		sizes <- runif(input$n, 1, 5)

		min <<- min + input$n + 3 # increment minimum id

		data.frame(
			id = as.character(ids),
			label = labels,
			size = sizes
		)
	})

	output$sg <- renderSigmajs({
		sigmajs(type = "webgl") %>%
			sg_nodes(nodes, id, label, size) %>%
			sg_settings(defaultNodeColor = "#0011ff")
	})

	observeEvent(input$add, {
		sigmajsProxy("sg") %>%
			sg_add_nodes_p(reactive_data(), id, label, size)
	})
}

shinyApp(ui, server)