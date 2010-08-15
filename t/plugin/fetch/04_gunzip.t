#!perl
use strict;
use warnings;
use Test::More;
use File::Basename;
use App::Hachero;
use File::Copy;
use File::Temp;
use File::Spec::Functions;
BEGIN {
    eval {require File::Find::Rule; require IO::Uncompress::Gunzip;};
    if ($@) {
        plan skip_all => 'File::Find::Rule or IO::Uncompress::Gunzip not found';
    } else {
        plan tests => 2;
    }
}

my $work_path = File::Temp::tempdir(CLEANUP => 1, DIR => 't');
my $gzfile = catfile(qw( t data test.gzip ));
copy($gzfile, catfile($work_path, 'test.gz'));

my $config = {
    plugins => [
        {
            module => 'Fetch::Gunzip',
        }
    ],
    global => {
        work_path => $work_path,
    }
};
            
my $app = App::Hachero->new({config => $config});
$app->initialize;
ok $app->run_hook('fetch');

is_deeply [ map {basename($_)} glob("$work_path/*") ], ['test'];
