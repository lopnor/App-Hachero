use strict;
use warnings;
use Test::More;
use App::Hachero;

BEGIN {
    if ($ENV{HACHERO_TEST_FTP}) {
        plan tests => 2;
        use_ok('App::Hachero::Plugin::Input::FTP');
    } else {
        plan skip_all => 'set "TEST_HACHERO_FTP" to run this test.';
        exit 0;
    }
}

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
$app->run_hook('input');
ok $app->currentline;

1;
