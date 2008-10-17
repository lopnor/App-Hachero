use inc::Module::Install;
use 5.008001;
use strict;
use warnings;

name 'App-Hachero';
all_from 'lib/App/Hachero.pm';

requires 'Class::Component';
requires 'Class::Accessor::Fast';
requires 'Class::Data::Inheritable';
requires 'DBIx::Class::Schema::Loader';
requires 'DateTime';
requires 'DateTime::TimeZone';
requires 'DateTime::Format::HTTP';
requires 'DateTime::Format::MySQL';
requires 'Digest::MD5';
requires 'File::Basename';
requires 'File::Find::Rule::Age';
requires 'File::Find::Rule';
requires 'File::Spec';
requires 'File::Temp';
requires 'File::stat';
requires 'HTTP::DetectUserAgent';
requires 'Module::Collect';
requires 'Net::FTP';
requires 'Regexp::Log::Common';
requires 'Regexp::Wildcards';
requires 'Template';
requires 'UNIVERSAL::require';
requires 'URI::QueryParam';
requires 'URI';
requires 'YAML';

build_requires 'Test::More';
build_requires 'Test::Base';

install_script 'hachero.pl';

tests 't/*.t t/*/*.t t/*/*/*.t';

WriteAll;

