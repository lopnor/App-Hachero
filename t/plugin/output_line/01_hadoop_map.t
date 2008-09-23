use strict;
use warnings;
use Test::More tests => 3;
use App::Hachero;
use App::Hachero::Result;
use URI;
use File::Temp;
use IO::All;
use Digest::MD5 qw(md5_hex);

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

my $fh = File::Temp->new;
close $fh;
my $out = $fh->filename;

local *STDOUT;
open STDOUT, '>', $out;

my $app = App::Hachero->new({config => $config});
my $res = App::Hachero::Result->new;
$res->primary(['a']);
$res->push({a => 1});
my $primary = 'foo';
my $secondary = md5_hex(1);
$app->result({$primary => $res});
$app->run_hook('output_line');
close STDOUT;

my $contents < io $out;
my ($key,$value) = split(/\t/,$contents);

is $key, "$primary-$secondary";
my $VAR1;
eval $value;
is_deeply $VAR1, {a => 1, count => 1};
