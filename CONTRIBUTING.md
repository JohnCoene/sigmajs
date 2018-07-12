# Contributing to sigmajs

## Support

If you have a question on how to use the package please first explore the [online documentation website](http://sigmajs.john-coene.com/), you may also want to check if your question has already been asked and answered on [stackoverflow](https://stackoverflow.com/) before filing an issue. In the latter case please read the section below before doing so.

## Filing an issue

You are free to open an [issue](https://github.com/JohnCoene/sigmajs/issues) if you encounter a problem with the package, where possible, illustrate the said problem with a [reproducible example](https://www.tidyverse.org/help/#reprex).

## Pull request

Use pull requests (PR) to contribute.

*  Your contribution(s) should follow the [tidyverse style guide](http://style.tidyverse.org/), in particular _exported_ functions. Follow the package naming convention, namely if you are integrating a function from the 
*  sigmajs uses [roxygen2](https://cran.r-project.org/package=roxygen2), with
[Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/markdown.html),
for documentation. Do not manually edit or create `.Rd` files (in the `man` directory), use [roxygen2](https://cran.r-project.org/package=roxygen2) instead.
*  sigmajs uses [testthat](https://cran.r-project.org/package=testthat); test your functions where possible. Coverage is tracked on both [Codecov](https://codecov.io/gh/JohnCoene/sigmajs) and [Coveralls](https://coveralls.io/github/JohnCoene/sigmajs).
*  If your changes or additions affect users please add a bullet point to the `NEWS.md` with a concise description.
* The package is continually integrated with [travis](https://travis-ci.org/JohnCoene/sigmajs) (Linux) and [appveryor](https://ci.appveyor.com/project/JohnCoene/sigmajs) (Windows), ensure the build passes on the aforementioned platforms.

## Code of Conduct

Please note by contributing you agree to the [Code of Conduct](https://github.com/JohnCoene/sigmajs/blob/master/CONDUCT.md).
