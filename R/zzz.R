.onAttach <- function(libname, pkgname) {
	shiny::registerInputHandler("sigmajsParse", function(data, ...) {
		jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
	}, force = TRUE)
}

.onLoad <- function(libname, pkgname) {
	shiny::registerInputHandler("sigmajsParse", function(data, ...) {
		jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
	}, force = TRUE)
}