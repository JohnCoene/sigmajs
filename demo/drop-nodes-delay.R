library(shiny)
library(sigmajs)

ui <- fluidPage(
  actionButton("drop", "drop nodes"),
  sigmajsOutput("sg")
)

server <- function(input, output, session) {
  
  nodes <- sg_make_nodes(100)
  
  output$sg <- renderSigmajs({
    sigmajs() %>% 
      sg_nodes(nodes, id, color, size)
  })
  
  drop <- nodes[sample(nrow(nodes), 50),]
  drop$delay <- runif(nrow(drop), 500, 1000)
  
  observeEvent(input$drop,{
    sigmajsProxy("sg") %>% 
      sg_drop_nodes_delay_p(drop, id, delay)
  })
  
}

shinyApp(ui, server)