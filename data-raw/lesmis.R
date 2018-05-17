# source https://github.com/MADStudioNU/lesmiserables-character-network

options(stringsAsFactors = FALSE)

# read data
edges <- read.csv("./data-raw/jean-complete-edge.csv", encoding = "UTF-8")
nodes <- read.csv("./data-raw/jean-complete-node.csv", encoding = "UTF-8")

names(nodes) <- tolower(names(nodes))
names(edges) <- tolower(names(edges))
nodes$description <- NULL
edges$type <- NULL

# create as igraph
lesmis_igraph <- igraph::graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
igraph::V(lesmis_igraph)$id <- igraph::V(lesmis_igraph)$name

lesmis_edges <- edges
lesmis_nodes <- nodes

# save
devtools::use_data(
	lesmis_nodes, lesmis_edges, lesmis_igraph, overwrite = TRUE
)