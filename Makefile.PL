use 5.008001;
use inc::Module::Install;
use strict;
use warnings;

name 'App-Hachero';
all_from 'lib/App/Hachero.pm';

requires 'Class::Component';
requires 'Class::Accessor::Fast';
requires 'Class::Data::Inheritable';
requires 'DateTime';
requires 'DateTime::TimeZone';
requires 'DateTime::Format::HTTP';
requires 'DateTime::Format::MySQL';
requires 'Digest::MD5';
requires 'File::Basename';
requires 'File::Spec';
requires 'File::Temp';
requires 'File::stat';
requires 'Module::Collect' => '0.05';
requires 'Regexp::Log::Common';
requires 'UNIVERSAL::require';
requires 'URI::QueryParam';
requires 'URI';
requires 'YAML';
requires 'Text::CSV_XS';

feature 'Plugin::Input::FTP',
    -default => 0,
    'Net::FTP';

feature 'Plugin::Input::File',
    -default => 0,
    'File::Find::Rule::Age',
    'File::Find::Rule';

feature 'Plugin::Fetch::FTP',
    -default => 0,
    'Net::FTP',
    'Regexp::Wildcards';

feature 'Plugin::Fetch::S3',
    -default => 0,
    'Net::Amazon::S3';

feature 'Plugin::Fetch::Gunzip',
    -default => 0,
    'IO::Uncompress::Gunzip',
    'File::Find::Rule';

feature 'Plugin::Classify::UserAgent',
    -default => 0,
    'HTTP::DetectUserAgent';

feature 'Plugin::Output::TT',
    -default => 0,
    'Template';

feature 'Plugin::Output::DBIC',
    -default => 0,
    'DBIx::Class::Schema::Loader';

feature 'Plugin::Summarize::Scraper',
    -default => 0,
    'Web::Scraper';

build_requires 'Test::More' => '0.88';
build_requires 'Test::MockModule';

install_script 'hachero.pl';

tests 't/*.t t/*/*.t t/*/*/*.t';

auto_install(
    do_once => 1
);
use_test_base;
auto_include;
auto_set_repository;
WriteAll;

