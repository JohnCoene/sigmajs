library(shiny)
library(sigmajs)  

ui <- fluidPage(
  sliderInput("filterNodes", "Filter nodes", value = 0, min = 0, max = 5),
  sigmajsOutput("sg", height = "90vh")
)

server <- function(input, output, session) {
 
  nodes <- sg_make_nodes(100)
  edges <- sg_make_edges(nodes, 200)
   
  output$sg <- renderSigmajs({
    sigmajs() %>% 
      sg_nodes(nodes, id, size, color) %>% 
      sg_edges(edges, id, source, target) %>% 
      sg_layout()
  })
  
  observeEvent(input$filterNodes, {
    sigmajsProxy("sg") %>% 
      sg_filter_gt_p(input$filterNodes, "size")
  })
}

shinyApp(ui, server)
