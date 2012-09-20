package Ican;
use Mojo::Base 'Mojolicious';
use File::Basename 'dirname';
use Cwd;
use File::Spec::Functions qw(catdir);

#Default mode needs to be defined
$ENV{MOJO_MODE} ||= 'development';

# Switch to installable home directory
$ENV{MOJO_APP} ||= __PACKAGE__;
$ENV{MOJO_HOME} ||= catdir(Cwd::abs_path(dirname(__FILE__)), $ENV{MOJO_APP});
$ENV{MOJO_CONFIG}
  ||= catdir($ENV{MOJO_HOME}, 'config', $ENV{MOJO_MODE},
  Mojo::Util::decamelize($ENV{MOJO_APP}))
  . '.pl';

our $VERSION = '0.01';

# This method will run once at server start
sub startup {
  my $app = shift;
  $app->bootstrap();

  #Load Plugins
  $app->load_plugins();

  # Routes
  $app->load_routes();

  #Additional Content-TypeS (formats)
  $app->add_types();

  #Hooks

}

#Bootstrap
sub bootstrap {
  my ($app) = @_;
  $app->plugin('Config');

  # Prepend "public" directories from config file
  @{$app->config('static_paths')}
    and unshift(@{$app->static->paths || []}, @{$app->config('static_paths')});
  $app->debug(@{$app->static->paths});

  # Prepend "templates" directories from config file
  @{$app->config('renderer_paths') || []}
    and unshift(@{$app->renderer->paths}, @{$app->config('renderer_paths')});

  # Prepend "plugins" namespaces from config file
  @{$app->config('plugins_namespaces') || []}
    and unshift(@{$app->plugins->namespaces}, @{$app->config('plugins_namespaces')});
}

#load plugins from config file
sub load_plugins {
  my ($app) = @_;
  my $plugins = $app->config('plugins') || {};

  foreach my $plugin (keys %$plugins) {
    if (ref($plugins->{$plugin}) eq 'HASH') {
      $app->plugin($plugin => $plugins->{$plugin});
    }
    elsif ($plugins->{$plugin} =~ /^(1|y|true|on)/ix) {
      $app->plugin($plugin);
    }
  }
  return;
}

#load routes, described in config
sub load_routes {
  my ($app, $app_routes, $config_routes) = @_;
  $app_routes ||= $app->routes;

  # Normal route to controller
  #$app_routes->get('/')->to('example#welcome');

  $config_routes ||= $app->config('routes') || {};

  foreach my $route (
    sort {
      ($config_routes->{$a}{order} || 11111) <=> ($config_routes->{$b}{order} || 11111)
    }
    keys %$config_routes
    )
  {
    next unless $config_routes->{$route}{to};
    my %qrs;
    if (scalar %{$config_routes->{$route}{qrs} || {}}) {
      foreach my $k (keys %{$config_routes->{$route}{qrs}}) {
        $qrs{$k} = qr/$config_routes->{$route}{qrs}{$k}/x;
      }
    }

    my $way = $app_routes->route($route, %qrs);

    #TODO: support other routes descriptions beside 'via'
    if ($config_routes->{$route}{via}) {
      $way->via(@{$config_routes->{$route}{via}});
    }
    $way->to($config_routes->{$route}{to});
  }
  return;
}

sub add_types {
  my ($app) = @_;
  my $types = $app->types;
  my $config_types = $app->config('types') || {};
  foreach my $k (keys %$config_types) {
    $types->type($k => $config_types->{$k});
  }
  return;
}

sub debug { shift->log->debug(@_) }

1;
