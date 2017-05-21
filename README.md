# WrapGen

WrapGen generates Swifty wrappers for C enums. It has a built-in recognizer for
libclang-style enums.

# Usage

```
WrapGen --file /path/to/C/file.h --symbol CXNameOfEnumInLibClang --name IntendedNameOfEnumInSwift --type [enum|options|structs]
```


tensorflow c_api [c_api](https://github.com/johndpope/WrapGen/blob/genbind/c_api.h) 
current output - [output](https://gist.github.com/johndpope/c0b169b782117a39790959f528ae2d45) 




I'd recommend playing around with the flags for a bit to see what you want to
generate.

# Author

Harlan Haskins ([@harlanhaskins](https://github.com/harlanhaskins))

# License

WrapGen is released under the MIT license, a copy of which is available in this
repo.



