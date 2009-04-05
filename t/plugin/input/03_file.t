use strict;
use warnings;
use Test::More;
use App::Hachero;

BEGIN {
    eval {require 'File::Find::Rule'; require 'File::Find::Rule::Age';};
    if ($@) {
        plan skip_all => 'File::Find::Rule or File::Find::Rule::Age not found. So skip this test';
    } else {
        plan tests => 3;
        use_ok('App::Hachero::Plugin::Input::File');
    }
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
    my $out = File::Spec->catfile($app->work_path,$_);
    open my $fh, '>', $out;
    print $fh $_;
    close $fh;
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
