storage_env <- new.env(hash = TRUE)

.onAttach <- function(libname, pkgname) {
  shiny::registerInputHandler("sigmajsParseJS", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
}

.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("sigmajsParseJS", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
}
