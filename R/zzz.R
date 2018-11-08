storage_env <- new.env(hash = TRUE)

.onAttach <- function(libname, pkgname) {
	shiny::registerInputHandler("sigmajsParseJS", function(data, ...) {
		jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
	}, force = TRUE)
  options(SIGMAJS_STORAGE = FALSE)
  
  packageStartupMessage(
    "Welcome to sigmajs\n\n",
    "Docs: sigmajs.john-coene.com"
  )
}

.onLoad <- function(libname, pkgname) {
  options(SIGMAJS_STORAGE = FALSE)
	shiny::registerInputHandler("sigmajsParseJS", function(data, ...) {
		jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
	}, force = TRUE)
	options(SIGMAJS_STORAGE = FALSE)
}