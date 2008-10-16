use strict;
use warnings;
use Test::More tests => 5;
use App::Hachero;
use App::Hachero::Plugin::Analyze::AccessCount;
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
my $res = App::Hachero::Result::AccessCount->new;
my $dt = '2008-10-17 04:03:15';
my $primary = 'AccessCount';
my $secondary = md5_hex($dt);
$res->push({datetime => $dt});
$app->result({$primary => $res});
$app->run_hook('output_line');
close STDOUT;

my $contents < io $out;
my ($key,$value) = split(/\t/,$contents);

is $key, "$primary-$secondary";
my $VAR1;
eval $value;
isa_ok $VAR1, 'App::Hachero::Result::AccessCount';
my ($data) = $VAR1->values;
isa_ok $data, 'App::Hachero::Result::Data';
is_deeply $data->hashref, {datetime => $dt, count => 1};
