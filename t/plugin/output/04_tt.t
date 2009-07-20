use strict;
use warnings;
use Test::Base;
use App::Hachero;
use App::Hachero::Result;
use File::Spec;
use File::Temp;

BEGIN {
    eval {require Template};
    if ($@) {
        plan skip_all => 'no Template found';
    }
}

plan tests => (1 * blocks) + 1;
use_ok 'App::Hachero::Plugin::Output::TT';

filters {
    result => [qw(yaml)],
    template => [qw(chomp)],
};

my $template = File::Temp->new(
    SUFFIX => '.tt',
);
close $template;
my $out = File::Temp->new(
    SUFFIX => '.out',
);
close $out;

my $config = {
    plugins => [
        {
            module => 'Output::TT',
            config => {
                template => $template->filename,
                out => $out->filename,
            }
        },
    ],
};
my $app = App::Hachero->new({config => $config});

run {
    my $block = shift;
    $app->result({});
    for my $result (keys %{$block->result}) {
        my $r = App::Hachero::Result->new;
        for (@{$block->result->{$result}}) {
            $r->primary([keys %{$_}]) unless $r->primary;
            $r->push($_);
        }
        $app->result->{$result} = $r;
    }
    open my $fh_tt, '>', $template or die;
    print $fh_tt $block->template;
    close $fh_tt;
    $app->run_hook('output');
    open my $fh_out, '<', $out;
    my $output = do {local $/; <$fh_out>};
    close $fh_out;
    is $output, $block->expected;
    unlink $template;
    unlink $out;
}

__END__
===
--- result
Hoge:
    - key: hooo
    - key: hooo
    - key: bar
    - key: bar
    - key: hooo
--- template
[% FOR r IN result -%]
[% r.key %]
[% FOR i IN r.value.values -%]
[% FOR k IN i.keys -%]
[% k %]: [% i.value(k) %]
[% END -%]
[% END -%]
[% END -%]
--- expected
Hoge
key: bar
count: 2
key: hooo
count: 3

