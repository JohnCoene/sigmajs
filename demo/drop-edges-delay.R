library(shiny)
library(sigmajs)

ui <- fluidPage(
  actionButton("drop", "drop edges"),
  sigmajsOutput("sg")
)

server <- function(input, output, session) {
  
  nodes <- sg_make_nodes(100)
  edges <- sg_make_edges(nodes, 150)
  
  output$sg <- renderSigmajs({
    sigmajs() %>% 
      sg_force() %>%
      sg_nodes(nodes, id, color, size) %>% 
      sg_edges(edges, id, source, target)
  })
  
  drop <- edges[sample(nrow(edges), 100),]
  drop$delay <- runif(nrow(drop), 500, 1000)
  
  observeEvent(input$drop,{
    sigmajsProxy("sg") %>% 
      sg_drop_edges_delay_p(drop, id, delay)
  })
  
}

shinyApp(ui, server)