# optparsegen

Generate ruby `optparse` code from usage text.

## Overview

This project generates valid `optparse` code from a given program's usage text.

Currently, optparsegen only supports [scopt](https://github.com/scopt/scopt) formatted usage text.


## Usage

```
Usage: optparsegen [options] <file>

optparsegen converts program usage text into equivalent ruby 'optparse'
code. It reads the text from the filename passed as the only argument
on the command line or from standard input.

Options:
    -f, --format=[FORMAT]            Input usage text format. Default: scopt
    -h, --help                       Show this message.
```