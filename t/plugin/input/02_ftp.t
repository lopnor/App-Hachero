use strict;
use warnings;
use Test::More tests => 2;
use App::Hachero;


BEGIN {
    use_ok('App::Hachero::Plugin::Input::FTP');
}

SKIP: {
    my $config = {
        plugins => [
            {
                module => 'Input::FTP',
                config => {
                    host => 'ftp.riken.jp',
                    username => 'anonymous',
                    file => '/lang/CPAN/README',
                }
            }
        ],
    };
    my $app = App::Hachero->new({config => $config});
#    $app->run_hook('fetch');
    $app->run_hook('input');
    ok $app->currentline;
}

1;