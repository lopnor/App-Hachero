use strict;
use warnings;
use Test::Base;
use File::Temp;
use App::Hachero;
use App::Hachero::Result;
require Class::Component;

plan tests => (1 * blocks) + 1;

filters {
    config => [qw(yaml)],
    result => [qw(yaml)],
};

use_ok 'App::Hachero::Plugin::Output::CSV';

run {
    my $block = shift;
    my $app = App::Hachero->new({config => $block->config});
    $app->result({});
    for my $result (keys %{$block->result}) {
        my $r = App::Hachero::Result->new;
        for (@{$block->result->{$result}}) {
            $r->primary([keys %{$_}]) unless $r->primary;
            $r->push($_);
        }
        $app->result->{$result} = $r;
    }
    my $tmp = File::Temp->new;
    $tmp->close;
    local $| = 1;
    local *STDOUT;
    open STDOUT, '>', $tmp->filename;
    $app->run_hook('output');
    close STDOUT;
    open my $fh, '<', $tmp->filename;
    my $result = do {local $/; <$fh>};
    close $fh;
    is $result, $block->expected;
};
__END__
===
--- config
plugins:
    - module: Output::CSV
      config:
        output:
            - Hoge

--- result
Hoge:
    - key: hooo
    - key: hooo
    - key: bar
    - key: bar
    - key: hooo

--- expected
bar,2
hooo,3
