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