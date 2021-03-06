use strict;
use warnings;
use Test::More;
use File::Temp;

use App::Hachero;

BEGIN {
    eval {require DBIx::Class::Schema::Loader};
    if ($@) {
        plan skip_all => 'no DBIx::Class::Schema::Loader found';
    } elsif ($ENV{TEST_HACHERO_DBIC}) {
        plan tests => 3;
        use_ok('App::Hachero::Plugin::Output::DBIC');
    } else {
        plan skip_all => 'set "TEST_HACHERO_DBIC" to run this test.';
    }
}

my $config = {
    plugins => [
        {
            module => 'Output::DBIC',
            config => {
                connect_info => [
                    'dbi:mysql:test',
                ],
            }
        },
    ]
};

my $app = App::Hachero->new({config => $config});
{
    local *STDOUT;
    my $file = File::Temp->new->filename;
    open STDOUT, '>', $file;
    $app->result({
        Hoo => {
            bar => 1,
            count => 10,
        }
    });
    $app->run_hook('output');
    close STDOUT;
    open my $fh, '<', $file;
    my $log = do {local $/; <$fh>};
    close $fh;
#    diag $log;
    like $log, qr/App::Hachero::Plugin::Output::DBIC \[error\]/;
    ok 1;
}
