use strict;
use warnings;
use Test::More tests => 2;
use App::Hachero;
use File::Temp;
use IO::All;

BEGIN {
    use_ok 'App::Hachero::Plugin::Output::HadoopReduce';
}

my $config = {
    plugins => [
        { module => 'Output::HadoopReduce' },
    ],
};

my $fh = File::Temp->new;
close $fh;
my $out = $fh->filename;
local *STDOUT;
open STDOUT, '>', $out;


my $app = App::Hachero->new({config => $config});
$app->result({
        foo => {
            bar => {a => 1, b => 2},
        }
    });
$app->run_hook('output');
close STDOUT;

my $contents < io $out;
is $contents, qq(foo\t1\t2\n);
