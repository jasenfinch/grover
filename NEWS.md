# grover 1.0.7

* Added `biocViews` field to the DESCRIPTION to ensure the [`rawrr](https://bioconductor.org/packages/release/bioc/html/rawrr.html) Bioconductor dependency is installed automatically.

* Fixed [`grover::converFile`](https://jasenfinch.github.io/grover/reference/convert.html) error when more than to options are supplied to the `args` parameter.

# grover 1.0.6

* [`grover::converFile`](https://jasenfinch.github.io/grover/reference/convert.html) creates the output directory if it doesn't already exist.

* Converted files now correctly zipped by [`grover::converFile`](https://jasenfinch.github.io/grover/reference/convert.html) to ensure they are readable by the [`mzR`](https://www.bioconductor.org/packages/release/bioc/html/mzR.html) package.

# grover 1.0.5

* File conversion methods [`grover::converFile`](https://jasenfinch.github.io/grover/reference/convert.html) and [`grover::convertDirectory`](https://jasenfinch.github.io/grover/reference/convert.html) now return the file path of the converted file.

* Zipping of converted files for reduced storage requirements can now be specified using the `zip` argument and is now the default of the conversion methods such as [`grover::converFile`](https://jasenfinch.github.io/grover/reference/convert.html).

* Added [`grover::version`](https://jasenfinch.github.io/grover/reference/version.html) to query the version number of a grover API.

* [`grover::groverAPI`](https://jasenfinch.github.io/grover/reference/groverAPI.html) now ensures that the specified `temp_dir` is created if not already extant.

# grover 1.0.4

* [`grover::conversionArgsPeakPick`](https://jasenfinch.github.io/grover/reference/conversionArgs.html) fix to ensure conversion argument is correctly passed to `msconverteR`.

# grover 1.0.3

* `rawR` dependency updated to [`rawrr`](https://github.com/fgcz/rawrr) with package name change.

* Fixed typo [`grover::runInfo`](https://jasenfinch.github.io/grover/reference/info.html) console message. 

* Request timeout limit can now be set for [`grover::runInfo`](https://jasenfinch.github.io/grover/reference/info.html).

* Fixed [`grover::runInfo`](https://jasenfinch.github.io/grover/reference/info.html) when attempting to retrieve file meta-information for a corrupt `.raw` file.

# grover 1.0.2

* `temp_dir` argument added to [`grover::groverAPI`](https://jasenfinch.github.io/grover/reference/groverAPI.html) to enable specification of a temporary directory for converted data storage.

* Fixed typo in [`grover::convertDirectory`](https://jasenfinch.github.io/grover/reference/convert.html) console message. 

# grover 1.0.1

* Added a `NEWS.md` file to track changes to the package.

* Fixed conversion argument helpers to work correctly with `msconverteR`.

* Converted files now returned correctly by the API.