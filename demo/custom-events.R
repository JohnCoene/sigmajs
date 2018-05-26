library(shiny)
library(sigmajs)

ui <- fluidPage(
    h1("Click or hover a node"),
    fluidRow(
        column(12, sigmajsOutput("sg"))
    ),
    fluidRow(
        column(3, h4("Node clicked"), verbatimTextOutput("nodeClicked")),
        column(3, h4("Node hovered"), verbatimTextOutput("nodeHovered")),
        column(6, p("There are plenty more events to capture, all official events are available:"),
            a(href = "https://github.com/jacomyal/sigma.js/wiki/Events-API", "official documentation"),
            h4("Background clicked"), verbatimTextOutput("bgClicked")
        )
    )
)

server <- function(input, output) {
    nodes <- sg_make_nodes(25)
    edges <- sg_make_edges(nodes, 35)

    output$sg <- renderSigmajs({
        sigmajs() %>%
            sg_nodes(nodes, id, label, size, color) %>%
            sg_edges(edges, id, source, target)
    })

    output$nodeClicked <- renderPrint({
        input$sg_click_node
    })

    output$nodeHovered <- renderPrint({
        input$sg_over_node
    })

    output$bgClicked <- renderPrint({
        input$sg_right_click_stage
    })
}

shinyApp(ui, server)