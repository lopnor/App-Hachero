use strict;
use Test::More tests => 2;
use File::Temp;
use App::Hachero;

BEGIN { 
    use_ok 'App::Hachero::Plugin::Input::Stdin';
}

{
    my $line = 'hoge';
    my ($fh, $log) = File::Temp::tempfile;
    print $fh $line;
    close $fh;

    my $config = {
        plugins => [
            { module => 'Input::Stdin' },
        ],
    };

    local *STDIN;
    open STDIN, '<', $log;
    my $app = App::Hachero->new({config => $config});
    $app->run_hook('input');
    is $app->currentline, $line;
}
