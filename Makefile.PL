use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME             => 'Ican',
  AUTHOR           => q{Красимир Беров <berov@cpan.org>},
  VERSION_FROM     => 'lib/Ican.pm',
  MIN_PERL_VERSION => '5.10.1',
  LICENSE          => 'artistic_2',
  PREREQ_PM => {'Mojolicious' => '3.34'},
  META_MERGE   => {
    requires  => {perl => '5.010001'},
    resources => {
      homepage    => 'http://i-can.eu',
      license     => 'http://www.opensource.org/licenses/artistic-license-2.0',
      repository  => 'https://github.com/kberov/ican',
      bugtracker  => 'https://github.com/kberov/ican/issues'
    },
    no_index => {directory => ['t',
    #'templates','public'
    ]}
  },
  test      => {TESTS => 't/*.t'}
);
