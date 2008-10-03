use strict;
use Test::More tests => 2;
use File::Temp;
use App::Hachero;

BEGIN { 
    use_ok 'App::Hachero::Plugin::Input::Stdin';
}

{
    my $line = 'hoge';
    my $fh = File::Temp->new;
    print $fh $line;
    close $fh;
    my $log = $fh->filename;

    my $config = {
        plugins => [
            { module => 'Input::Stdin' },
        ],
    };

    local *STDIN;
    open STDIN, '<', $log;
    my $app = App::Hachero->new({config => $config});
    $app->run_hook('input');
    close STDIN;
    is $app->currentline, $line;
}
