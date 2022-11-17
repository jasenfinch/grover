
# grover

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/jasenfinch/grover/workflows/R-CMD-check/badge.svg)](https://github.com/jasenfinch/grover/actions)
[![Codecov test coverage](https://codecov.io/gh/jasenfinch/grover/branch/master/graph/badge.svg)](https://codecov.io/gh/jasenfinch/grover?branch=master)
[![license](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg)](https://github.com/jasenfinch/grover/blob/master/DESCRIPTION)
[![GitHub release](https://img.shields.io/github/release/jasenfinch/grover.svg)](https://GitHub.com/jasenfinch/grover/releases/)
<!-- badges: end -->

### Overview

The `grover` package provides a web-based API framework for remote access to a mass spectrometry `.raw` data repository, implemented using the [`plumber`](https://www.rplumber.io/) R package.
API functionality includes:

* **File information** retrieval including file size and creation dates.
* File **transfer**.
* Raw mass spectrometry data file **conversion** to `.mzML` format.
* Retrieval of **sample information** from `.raw` file headers.

The package functionality is platform independent with file conversion and sample information retrieval functionality available through use of the [`msconverteR`](https://github.com/wilsontom/msconverteR) and [`rawrr`](https://github.com/fgcz/rawrr) R packages.

### Installation

The `grover` package can be installed from GitHub using the following:

```
remotes::install_github('jasenfinch/grover')
```

### Learn more

The package documentation can be browsed online at <https://jasenfinch.github.io/grover/>. 

If this is your first time using `grover` see the [Introduction to grover](https://jasenfinch.github.io/grover/articles/introduction.html) vignette for information on how to get started.

If you believe you've found a bug in `grover`, please file a bug (and, if
possible, a [reproducible example](https://reprex.tidyverse.org)) at
<https://github.com/jasenfinch/grover/issues>.

