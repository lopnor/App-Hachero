use strict;
use warnings;
use Test::More tests => 3;
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
        {module => 'Analyze::Bar'},
    ],
};

my $app = App::Hachero->new({config => $config});

ok $app;
$app->run_hook('input');
is $app->currentline, 'ok';
$app->run_hook('analyze');
my $result = $app->result->{Bar};
isa_ok $result, 'App::Hachero::Plugin::Analyze::Bar::Result';

