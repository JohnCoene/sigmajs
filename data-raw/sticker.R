library(sigmajs)
library(igraph)
library(hexSticker)

COLORS <- c('#D8482D','#B30000','#BB100A','#FEF0D9','#B70805','#D44028','#CC301E','#ED7047','#DC5032','#F1784C','#F58051','#BF180F','#D03823','#C72819','#FCA072','#FC8F5C','#E5603D','#E05837')

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
    h_color = "#c9423f",
    p_color = "#c9423f",
    h_fill = "#ffffff",
    url = "sigmajs.john-coene.com",
    u_size = 3,
    filename="man/figures/logo.png")    