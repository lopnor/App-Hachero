use strict;
use Test::More tests => 2;
use IO::All;
use File::Spec;
use App::Hachero;

BEGIN { 
    use_ok 'App::Hachero::Plugin::Input::Stdin';
}

{
    my $log = File::Spec->catfile( qw( t sample sample.log ) );
    my $line < io $log;
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
