use 5.008006;
use inc::Module::Install 0.91;
name 'MooseX-AuthorizedMethods';
all_from 'lib/MooseX/AuthorizedMethods.pm';

requires 'Moose' => '0.90';

auto_install;
resources repository => 'http://github.com/ruoso/MooseX-AuthorizedMethods/';

WriteAll;

