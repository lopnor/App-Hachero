use strict;
use warnings;
use inc::Module::Install;

name 'App-Hachero';
all_from 'lib/App/Hachero.pm';

requires 'Class::Component';
requires 'Class::Accessor::Fast';
requires 'Regexp::Log::BWS';

tests 't/*.t t/*/*.t t/*/*/*.t';

WriteAll;

