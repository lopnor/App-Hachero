use strict;
use warnings;
use Test::More tests => 2;
use App::Hachero;
use File::Spec;

BEGIN {
    use_ok('App::Hachero::Plugin::Fetch::FTP');
}

my $config = {
    plugins => [
        {
            module => 'Fetch::FTP',
            config => {
                host => 'ftp.riken.jp',
                username => 'anonymous',
                file => '/lang/CPAN/README',
            }
        }
    ],
    global => {
        work_path => 't/work',
    },
};
my $app = App::Hachero->new({config => $config});
$app->initialize;
$app->run_hook('fetch');

my $log = File::Spec->catfile( qw( t work README ) );
ok -e $log;

END {
    my $log = File::Spec->catfile( qw( t work README ) );
    unlink $log;
}

1;
