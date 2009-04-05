use strict;
use warnings;
use Test::More;
use App::Hachero;
use File::Spec;

BEGIN {
    eval {require 'Net::FTP'};
    if ($!) {
        plan skip_all => 'no Net::FTP found';
    } elsif ($ENV{HACHERO_TEST_FTP}) {
        plan tests => 2;
        use_ok('App::Hachero::Plugin::Fetch::FTP');
    } else {
        plan skip_all => 'set "TEST_HACHERO_FTP" to run this test.';
    }
}

my $config = {
    plugins => [
        {
            module => 'Fetch::FTP',
            config => {
                host => 'ftp.riken.jp',
                username => 'anonymous',
                file => '/pub/Linux/centos/5.2/os/i386/RELEASE-NOTES-*',
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

my $work_path = File::Spec->catfile( qw( t work ) );
my @dlfiles = map { $_ =~ s/$work_path\///; $_  } glob("$work_path/RELEASE-NOTES-*");
is_deeply \@dlfiles, [
    'RELEASE-NOTES-cs',
    'RELEASE-NOTES-cs.html',
    'RELEASE-NOTES-de',
    'RELEASE-NOTES-de.html',
    'RELEASE-NOTES-en',
    'RELEASE-NOTES-en.html',
    'RELEASE-NOTES-en_US',
    'RELEASE-NOTES-en_US.html',
    'RELEASE-NOTES-es',
    'RELEASE-NOTES-es.html',
    'RELEASE-NOTES-fr',
    'RELEASE-NOTES-fr.html',
    'RELEASE-NOTES-ja',
    'RELEASE-NOTES-ja.html',
    'RELEASE-NOTES-nl',
    'RELEASE-NOTES-nl.html',
    'RELEASE-NOTES-pt_BR',
    'RELEASE-NOTES-pt_BR.html',
    'RELEASE-NOTES-ro',
    'RELEASE-NOTES-ro.html',
];


END {
    my $work_path = File::Spec->catfile( qw( t work ) );
    my @dlfiles = glob("$work_path/*");
    unlink @dlfiles;
}

1;
