
# Hypercast - Fast, generic, automatic type casting (conversion) framework

This library may be considered as a *parasitic* library in that it may carry codes from various existing libraries. Currently:

+ ironcrad


## Usage

`(cast 'bit-vector 5) -> #b101000000000000000000000`

## Dependencies
This library is at least tested on implementation listed below:

+ SBCL 1.3.5 on X86-64 Linux 3.13.0-87-generic (author's environment)

Also, it depends on the following libraries:

+ iterate by ** :
    Jonathan Amsterdam's iterator/gatherer/accumulator facility
+ alexandria by ** :
    Alexandria is a collection of portable public domain utilities.
+ inlined-generic-function by *Masataro Asai* :
    MOP implementation of the fast inlinable generic functions dispatched in compile-time

## Installation

## Author

* Masataro Asai (guicho2.71828@gmail.com)

## Copyright

Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)

# License

Licensed under the LLGPL License.


