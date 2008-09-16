use strict;
use warnings;
use Test::More tests => 3;
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
my ($key,$value) = split(/\t/,$contents);

is $key, 'foo-bar';
my $VAR1;
eval $value;
is_deeply $VAR1, {a => 1, b => 2};
