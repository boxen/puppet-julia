# Julia for Boxen

Installs the [Julia programming language](http://julialang.org/)

A great module has a working travis build

[![Build Status](https://travis-ci.org/JustinTulloss/puppet-julia.png?branch=master)](https://travis-ci.org/JustinTulloss/puppet-julia)

## Usage

```puppet
include julia
```

## Specifying a version

```puppet
class { 'julia': version => '0.3.0-prerelease' }
```
