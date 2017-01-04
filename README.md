# optparsegen

[![Build Status](https://travis-ci.org/tyler-sommer/optparsegen.svg?branch=master)](https://travis-ci.org/tyler-sommer/optparsegen)

Generate ruby `optparse` code from usage text.


## Overview

This project generates valid `optparse` code from a given program's usage text.

> Currently, optparsegen only supports [scopt](https://github.com/scopt/scopt) formatted usage text.


## Installation

This project is published as a [ruby gem](https://rubygems.org/gems/optparsegen).

The simplest way to install it is with `gem install`.

```bash
gem install optparsegen
```


## Usage

optparsegen will read from standard input unless a filename is passed as an argument. Generated code is printed to standard output.

Typical usage looks like:

```bash
java -jar some-scopt-using.jar --help | optparsegen > optparse.rb
```


### Options

```
Usage: optparsegen [options] <file>

optparsegen converts program usage text into equivalent ruby 'optparse'
code. It reads the text from the filename passed as the only argument
on the command line or from standard input.

Example:
  java -jar some-scopt-using.jar --help | optparsegen > optparse.rb

Options:
    -f, --format=[FORMAT]            Input usage text format. Default: scopt
    -h, --help                       Show this message.
```