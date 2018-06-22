library(shiny)
library(sigmajs)

ui <- fluidPage(
    fluidRow(
        column(
            6, sigmajsOutput("sg1") 
        ),
        column(
            6, sigmajsOutput("sg2")
        )
    )
)

server <- function(input, output) {
    nodes <- sg_make_nodes()
    edges <- sg_make_edges(nodes)

    output$sg1 <- renderSigmajs({
        sigmajs() %>%
            sg_nodes(nodes, id, size, color) %>%
            sg_edges(edges, id, source, target) %>%
            sg_camera(initialise = TRUE) 
    })

    output$sg2 <- renderSigmajs({
        sigmajs() %>%
            sg_nodes(nodes, id, size, color) %>%
            sg_edges(edges, id, source, target) %>%
            sg_camera("sg1", initialise = FALSE)
    })
}

shinyApp(ui, server)