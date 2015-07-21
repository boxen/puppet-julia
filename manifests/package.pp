# Install an Atom package.
#
# Examples
#
#   julia::package { 'Gadfly': }
define julia::package (
  $ensure = 'latest'
) {
  require julia

  ensure_resource('package', $name, {
    ensure   => $ensure,
    provider => 'julia',
    require  => Class['julia'],
  })
}
