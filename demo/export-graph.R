library(shiny)
library(sigmajs)

ui <- fluidPage(
  actionButton("export", "export graph to SVG"),
  sigmajsOutput("sg")
)

server <- function(input, output){
  nodes <- sg_make_nodes(25)
  edges <- sg_make_edges(nodes, 35)
  
  output$sg <- renderSigmajs({
    sigmajs() %>%
      sg_nodes(nodes, id, label, size, color) %>%
      sg_edges(edges, id, source, target)
  })
  
  observeEvent(input$export, {
    sigmajsProxy("sg") %>% 
      sg_export_p()
  })
}

shinyApp(ui, server)
