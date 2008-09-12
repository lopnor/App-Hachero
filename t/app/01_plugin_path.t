use strict;
use warnings;
use Test::More tests => 2;
use File::Spec;
use App::Hachero;

my $path = File::Spec->catfile(qw(t data plugin));

my $config = {
    global => {
        plugin_path => [
            $path,
        ],
    },
    plugins => [
        {module => 'Test::Foo'},
    ],
};

my $app = App::Hachero->new({config => $config});

ok $app;
$app->run_hook('input');
is $app->currentline, 'ok';
