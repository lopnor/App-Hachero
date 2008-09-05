use strict;
use warnings;
use inc::Module::Install;

name 'App-Hachero';
all_from 'lib/App/Hachero.pm';

requires 'Class::Component';
requires 'Class::Accessor::Fast';
requires 'DateTime::Format::HTTP';
requires 'URI';
requires 'File::Temp';
requires 'File::Basename';
requires 'Net::FTP';
requires 'YAML';
requires 'DBIx::Class::Schema::Loader';
requires 'DateTime::Format::MySQL';
requires 'Regexp::Wildcards';
requires 'Regexp::Log::Common';
requires 'File::Spec';
requires 'File::Find::Rule';
requires 'UNIVERSAL::require';

build_requires 'Test::More';
build_requires 'Test::Base';

tests 't/*.t t/*/*.t t/*/*/*.t';

WriteAll;

