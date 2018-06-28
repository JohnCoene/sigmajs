library(shiny)
library(sigmajs)

ui <- fluidPage(
  actionButton("export", "export graph to SVG"),
  actionButton("exportIMG", "export graph to image"),
  selectInput("format", label = "image format", choices = c("png", "jpg", "gif", "tiff")),
  sigmajsOutput("sg")
)

server <- function(input, output){
  nodes <- sg_make_nodes(25)
  edges <- sg_make_edges(nodes, 35)
  
  output$sg <- renderSigmajs({
    sigmajs() %>%
      sg_nodes(nodes, id, label, size, color) %>%
      sg_edges(edges, id, source, target) %>% 
      sg_layout()
  })
  
  observeEvent(input$export, {
    sigmajsProxy("sg") %>% 
      sg_export_svg_p()
  })
  
  observeEvent(input$exportIMG, {
    sigmajsProxy("sg") %>% 
      sg_export_img_p(format = input$format, file = paste0("graph.", input$format))
  })
}

shinyApp(ui, server)
