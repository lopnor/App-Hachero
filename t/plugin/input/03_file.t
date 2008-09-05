use strict;
use warnings;
use Test::More tests => 4;
use App::Hachero;
use IO::All;

BEGIN {
    use_ok('App::Hachero::Plugin::Input::File');
}

my $config = {
    global => {work_path => 't/work'},
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

for (@expected) {
    $app->run_hook('input');
    is $app->currentline, $_;
}

END {
    unlink glob File::Spec->catfile($app->work_path,'*'),
}
