
# Hypercast - Fast, generic, automatic type casting (conversion) framework

`(cast 'bit-vector 5) -> #b101000000000000000000000`

Highlights:

+ **Better alternative to cl:coerce**: Define the set of atomic converters. The semantics for the primary exported function, `cast`, is the same as `cl:coerce`.
    + `cast` accepts all target types supported by `coerce` in ANSI
+ **Minimal dispatching overhead**: Implemented with `inline-generic-function`, so it is **as fast as** the case of using compiler-macros (no dynamic dispatch as long as the second argument is a constant) and **as powerful as** CLOS generic functions.
+ **Automatic Conversion**: When no implementation of direct conversion is available, it tries to convert the value to the desired type by finding the optimal conversion sequence using dijkstra search. Conversion sequence is found as a path in the directed graph defined by the set of atomic converters. Edge cost is heuristically encoded in the `cost` generic function.
    + Currently the path finding in the type space is done in runtime, but I plan to move it to the compile time in the near future.

This library aims at consolidating and connecting several libraries related to data conversion:

+ bit-smasher
+ JSON-related libs
+ BDDs
+ octets

In terms of implementing each atomic converter, this library could be viewed as a *parasitic* library in that it may carry codes from various existing libraries, or just call the APIs of those libraries.

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


