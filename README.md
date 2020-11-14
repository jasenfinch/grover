
# grover

<!-- badges: start -->
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build status](https://github.com/jasenfinch/grover/workflows/R-CMD-check/badge.svg)](https://github.com/jasenfinch/grover/actions)
[![Codecov test coverage](https://codecov.io/gh/jasenfinch/grover/branch/master/graph/badge.svg)](https://codecov.io/gh/jasenfinch/grover?branch=master)
<!-- badges: end -->

### Overview

The `grover` package provides a web-based API framework for remote access to a mass spectrometry `.raw` data repository, implemented using the [`plumber`](https://www.rplumber.io/) R package
API functionality includes:

* **File information** retrieval including file size and creation dates.
* File **transfer**.
* Raw mass spectrometry data file **conversion** to `.mzML` format.
* Retrieval of **sample information** from `.raw` file headers.

The package functionality is platform independent with file conversion and sample information retrieval functionality available through use of the [`msconvereR`](https://github.com/wilsontom/msconverteR) and [`rawR`](https://github.com/fgcz/rawR) R packages.

### Installation

This package requires the `rawR` package.
Details of how to install the latest version can be found [here](https://github.com/fgcz/rawR/releases).

The `grover` package can be installed from GitHub using the following:

```
remotes::install_github('jasenfinch/grover',build_vignettes = TRUE)
```

### Learn more

The package documentation can be browsed online at <https://jasenfinch.github.io/grover/>. 

If this is your first time using `grover` see the [Introduction to grover](https://jasenfinch.github.io/grover/articles/introduction.html) vignette for information on how to get started.

If you believe you've found a bug in `grover`, please file a bug (and, if
possible, a [reproducible example](https://reprex.tidyverse.org)) at
<https://github.com/jasenfinch/grover/issues>.

