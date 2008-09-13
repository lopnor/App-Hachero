use strict;
use warnings;
use Test::More tests => 2;
use App::Hachero;
use URI;
use File::Temp;
use IO::All;

BEGIN {
    use_ok 'App::Hachero::Plugin::OutputLine::HadoopMap';
}

my $config = {
    plugins => [
        {
            module => 'OutputLine::HadoopMap',
        },
    ]
};

my $out = File::Temp->new->filename;

local *STDOUT;
open STDOUT, '>', $out;

my $app = App::Hachero->new({config => $config});
$app->result({
        foo => {
            bar => {a => 1, b => 2},
        }
    });

$app->run_hook('output_line');
close STDOUT;

my $contents < io $out;

is $contents, qq(foo-bar\t{"a":1,"b":2}\n);
