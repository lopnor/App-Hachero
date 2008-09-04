#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use File::Spec::Functions;
use lib catfile($FindBin::Bin, 'lib');
use App::Hachero;
use Getopt::Long;

my $confname = 'config.yaml';
my $version = 0;
GetOptions(
    'config=s'  => \$confname,
    'version'   => \$version,
) or die "Usage: $0 -c config.yaml";

if ($version) {
    print "App::Hachero/$App::Hachero::VERSION\n";
    exit;
}

App::Hachero->new({config => $confname})->run;

