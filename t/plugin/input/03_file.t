use strict;
use warnings;
use Test::More tests => 3;
use App::Hachero;
use IO::All;

BEGIN {
    use_ok('App::Hachero::Plugin::Input::File');
}

my $config = {
    global => {
        work_path => 't/work',
        log => {level => 'error'},
    },
    plugins => [
        {
            module => 'Input::File',
        }
    ],
};

my $app = App::Hachero->new({config => $config});
ok $app;
$app->initialize;

my @expected = qw(
    abc
    def
);
for (@expected) {
    $_ > io(File::Spec->catfile($app->work_path,$_));
}

my @result;
for (@expected) {
    $app->run_hook('input');
    push @result, $app->currentline;
}
is_deeply [sort @result], \@expected;

END {
    unlink glob File::Spec->catfile($app->work_path,'*'),
}
