use strict;
use warnings;
use Test::More tests => 7;
use File::Spec;
use File::Temp;
use App::Hachero;

my $path = File::Spec->catfile(qw(t data plugin));

my $fh = File::Temp->new;
close $fh;
my $map = $fh->filename;

{
    my $config = {
        global => {
            plugin_path => [
            $path,
            ],
        },
        plugins => [
            {module => 'Analyze::Bar'},
            {module => 'OutputLine::HadoopMap'},
        ],
    };
    my $app = App::Hachero->new({config => $config});

    ok $app;
    $app->run_hook('analyze');
    local *STDOUT;
    open STDOUT, '>', $map;
    $app->run_hook('output_line');
    close STDOUT;
    open my $fh, '<', $map;
    my $content = do {local $/, <$fh>};
    close $fh;
    ok $content;
}

{
    my $config = {
        global => {
            plugin_path => [
                $path,
            ],
        },
        plugins => [
            {module => 'Input::Stdin'},
            {module => 'Parse::HadoopReduce'},
            { module => 'Output::Baz' },
        ],
    };
    local *STDIN;
    open STDIN, '<', $map;
    my $app = App::Hachero->new({config => $config});
    $app->run_hook('input');
    close STDIN;
    ok $app->currentline;
    $app->run_hook('parse');
    my $result = $app->result->{Bar};
    isa_ok $result, 'App::Hachero::Plugin::Analyze::Bar::Result';
    my ($value) = $result->values;
    isa_ok $value, 'App::Hachero::Result::Data';
    is_deeply $value->hashref, {baz => 'hoge', count => 1};
    my $tmp = File::Temp->new;
    close $tmp;
    my $out = $tmp->filename;
    local *STDOUT;
    open STDOUT, '>', $out;
    $app->run_hook('output');
    close STDOUT;
    open my $fh, '<', $out;
    my $content = do {local $/; <$fh>};
    close $fh;
    is $content, <<END;
Bar
---
baz: hoge
count: 1
END
}
