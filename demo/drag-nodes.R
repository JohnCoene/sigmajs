library(shiny)
library(sigmajs)

ui <- fluidPage(
    actionButton("activate", "Activate"),
    actionButton("deactivate", "Deactivate"),
    sigmajsOutput("sg", height = "98vh")
)

server <- function(input, output){
    
    nodes <- sg_make_nodes(50)
    edges <- sg_make_edges(nodes, 100)

    output$sg <- renderSigmajs({
        sigmajs() %>%
            sg_nodes(nodes, id, size, color) %>%
            sg_edges(edges, id, source, target)
    })

    observeEvent(input$activate, {
        sigmajsProxy("sg") %>%
            sg_drag_nodes_start_p()
    })

    observeEvent(input$deactivate, {
        sigmajsProxy("sg") %>%
            sg_drag_nodes_kill_p()
    })
}

shinyApp(ui, server)