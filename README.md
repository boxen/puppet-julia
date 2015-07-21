# Julia for Boxen

Installs the [Julia programming language](http://julialang.org/)

[![Build Status](https://travis-ci.org/JustinTulloss/puppet-julia.png?branch=master)](https://travis-ci.org/JustinTulloss/puppet-julia)

## Usage

```puppet
include julia

# install the Gadfly package
julia::package { 'Gadfly': }
```

## Specifying a version

```puppet
class { 'julia': version => '0.3.0-prerelease' }
```
