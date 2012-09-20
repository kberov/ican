# This is the default configuration file for the Ican application.
# You can change it by changing $ENV{MOJO_CONFIG}.
# To check the current value of $ENV{MOJO_CONFIG} and other:
# cd path/to/your/app
# >$ script/ican eval 'say map {$_=~/MOJO/ && "$_ => $ENV{$_}$/"}  keys %ENV'
my $config = {};

#These paths will be prepended to $app->static->paths.
#Default: ["$ENV{MOJO_HOME}/public"]
$config->{static_paths} = [];

#These paths will be prepended to $app->renderer->paths.
#Default: ["$ENV{MOJO_HOME}/templates"]
$config->{renderer_paths} = [];

#These namespaces will be prepended to $app->plugin->namespaces.
#Default: ['Mojolicious::Plugin']
$config->{plugins_namespaces} = ['Ican::Plugin'];

$config->{plugins} = {

  # Documentation browser under "/perldoc"
  PODRenderer => 1,
};

# $config->{routes}, $config->{login_required_routes}
# The order key in a route definition is important!
# If you set a bigger number a more general definition may match
# just because it was before your specific route.
# So set more speciffic routes order with smaller numbers
# so they can match before the more general ones.
$config->{routes} = {

  #bare default
  '/' => {
    order => 111111,
    via   => ['get'],
    to    => 'example#welcome'
  }
};
$config->{login_required_routes} = {};


return $config;
