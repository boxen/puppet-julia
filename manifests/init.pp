# Public: Install the Julia programming language
#
# Usage:
#
#    include julia
class julia (
    $version = '0.3.10',
  ) {
  package { 'Julia':
    source   => "https://s3.amazonaws.com/julialang/bin/osx/x64/0.3/julia-${version}-osx10.7+.dmg",
    provider => 'appdmg'
  }
}
