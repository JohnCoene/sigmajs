library(shiny)
library(sigmajs)

ui <- fluidPage(
    actionButton("drop", "drop nodes & edges"),
    sigmajsOutput("sg")
)

server <- function(input, output) {

    # initial plot
    nodes <- sg_make_nodes(75)
    edges <- sg_make_edges(nodes)

    # delay fro DROP
    nodes$delay <- runif(nrow(nodes), 1000, 5000)
    edges$delay <- runif(nrow(edges), 1000, 5000)

    # nodes & edges to drop
    n_drop <- nodes[sample(nrow(nodes), 50), ]
    e_drop <- edges[sample(nrow(edges), 100), ]

    output$sg <- renderSigmajs({
        sigmajs() %>%
            sg_force_start() %>%
            sg_nodes(nodes, id, size, color) %>%
            sg_edges(edges, id, source, target)
    })

    observeEvent(input$drop, {
        sigmajsProxy("sg") %>%
            sg_drop_nodes_delay_p(n_drop, id, delay) %>%
            sg_drop_edges_delay_p(e_drop, id, delay)
    })

}

shinyApp(ui, server)