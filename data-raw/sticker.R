library(sigmajs)
library(igraph)
library(hexSticker)

n <- 50
ring <- sample_k_regular(n, 5)
V(ring)$id <- 1:n
V(ring)$color <- "#c9423f"

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
    h_color = "#c9423f",
    p_color = "#c9423f",
    h_fill = "#ffffff",
    filename="man/figures/logo.png")