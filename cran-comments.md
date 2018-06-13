## Test environments
* local OS X install, R 3.4.2
* ubuntu 12.04 (on travis-ci), R 3.4.2
* win-builder (devel and release)

## R CMD check results

0 errors | 1 warnings | 1 note

* This is a new release.
* Conversion of 'README.md' failed:
pandoc.exe: Could not fetch /man/figures/logo.png
/man/figures/logo.png: openBinaryFile: does not exist (No such file or directory)

--------------

Unsure about the reason behind `logo.png` *warning*, file exists at indicated path (`/man/figures/logo.png`).

