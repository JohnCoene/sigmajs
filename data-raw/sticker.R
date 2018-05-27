library(sigmajs)
library(igraph)
library(hexSticker)

COLORS <- c("#B1E2A3", "#98D3A5", "#328983", "#1C5C70", "#24C96B")

n <- 50
ring <- sample_k_regular(n, 5)
V(ring)$id <- 1:n
V(ring)$color <- sample(COLORS, n, replace = TRUE)

l <- layout_in_circle(ring)

sigmajs() %>%
    sg_from_igraph(ring, l)

imgurl <- "./data-raw/logo.png"
sticker(
    imgurl,
    package="sigmajs", 
    p_size=16,
    p_y = 1, 
    s_x=1, 
    s_y=1, 
    s_width= 0.6,
    s_height= 0.6,
    h_color = "#B1E2A3",
    p_color = "#1C5C70",
    h_fill = "#ffffff",
    url = "sigmajs.john-coene.com",
    u_size = 3,
    filename="man/figures/logo.png")    