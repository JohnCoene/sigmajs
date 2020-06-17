## Test environments
* local OS X install, R 4.0.1
* ubuntu 14.04 (on travis-ci), R 4.0.0
* devtools win-builder (devel and release)
* rhub `check_for_cran`

## R CMD check results

0 errors | 0 warnings | 1 note

Package was archived on CRAN

> Please do not start your description field in the DESCRIPTION file with phrases like 'This is a R package', 'This package', the package name, the package title or similar.

The description never started with such sentences. It is a wrapper to a JavaScript library of the same name, it therefore should appear in the description, it was always there in single quotes.

> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation. Please write about the structure of the output (class) and also what the output means. (If a function does not return a value, please document that too, e.g. \value{No return value, called for side effects} or similar)

I have added \value to every function of the package.

> Please make sure that you do not change the user's options, par or working directory. If you really have to do so, please ensure with an *immediate* call of on.exit() that the settings are reset when the function is exited, similar to this:
> ...
> oldoptions <- options(width = 999)   # code line i
> on.exit(options(oldoptions))          # code line i+1
> ...
> #options call in function
> ...
> If you're not familiar with the function, please check ?on.exit. This
> function makes it possible to restore options before exiting a function
> even if the function breaks. Therefore it needs to be called immediately
> after the option change within a function.

The package no longer uses `options`.

> You also seem to be a copyright holder [cph].
> Please add this information to the Authors@R field.

> Please fix and resubmit, and document what was changed in the submission
> comments.

I added "cph" as role.
