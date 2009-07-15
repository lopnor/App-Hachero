#!perl
use strict;
use warnings;
use Test::More tests => 2;
use App::Hachero;
use File::Temp;
use File::Spec::Functions;

my $work_path = File::Temp::tempdir(CLEANUP => 1, DIR => 't');
my $gzfile = catfile(qw( t data test.gz ));
system('cp', $gzfile, $work_path);

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

is_deeply [map {s/^$work_path\///;$_} glob("$work_path/*")], ['test'];

