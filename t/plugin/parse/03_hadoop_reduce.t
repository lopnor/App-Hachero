use strict;
use warnings;
use Test::More tests => 3;
use App::Hachero;

BEGIN {
    use_ok 'App::Hachero::Plugin::Parse::HadoopReduce';
}

my $config = {
    plugins => [
        { module => 'Parse::HadoopReduce' }
    ]
};

my $app = App::Hachero->new({config => $config});

$app->currentline(qq(hoo-bar\t{"a":1,"count":3}\n));
$app->run_hook('parse');
is_deeply $app->result->{hoo}->{bar}, {a => 1, count => 3};
$app->currentline(qq(hoo-bar\t{"a":1,"count":7}\n));
$app->run_hook('parse');
is_deeply $app->result->{hoo}->{bar}, {a => 1, count => 10};
