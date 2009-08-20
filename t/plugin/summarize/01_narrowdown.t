use strict;
use warnings;
use Test::Base;
use App::Hachero;
use App::Hachero::Result::PrimaryPerInstance;

plan tests => 1 * blocks;

filters {
    config => [qw(yaml)],
    result => [qw(yaml create_result)],
    expected => [qw(yaml)],
};

sub create_result {
    my ($hash) = @_;
    my $res = {};
    while (my ($key, $value) = each %{$hash}) {
        my $r = App::Hachero::Result::PrimaryPerInstance->new;
        for (@{$value}) {
            $r->primary([ keys %{$_} ]) unless $r->primary;
            $r->push($_); 
        }
        $res->{$key} = $r;
    }
    $_ = $res;
}

my $app = App::Hachero->new(
    { config => { plugins => [ { module => 'Summarize::NarrowDown' } ] } }
);

run {
    my $block = shift;
    $app->conf->{plugins}->[0]->{config} = $block->config;
    $app->run_hook('initialize');
    $app->result($block->result);
    $app->run_hook('summarize');
    is_deeply [ $app->result->{$block->config->{to_result_key}}->values ], $block->expected;
};

__END__
===
--- config
from_result_key: URI
to_result_key: ranking
primary:
    - path
limit: 3

--- result
URI:
    - path: '/some/path/1'
      query: foo
    - path: '/some/path/1'
      query: foo+bar
    - path: '/some/path/2'
      query: foo+bar+baz
    - path: '/some/path/2'
      query: foo+bar+baz
    - path: '/some/path/2'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo+bar
    - path: '/another/path/2'
      query: foo+bar
    - path: '/another/path/1'
      query: foo+bar+baz
    - path: '/another/path/3'
      query: foo

--- expected
- path: '/some/path/3'
  count: 12 
- path: '/some/path/2'
  count: 3 
- path: '/some/path/1'
  count: 2 

===
--- config
from_result_key: URI
to_result_key: ranking
limit: 3

--- result
URI:
    - path: '/some/path/1'
    - path: '/some/path/1'
    - path: '/some/path/2'
    - path: '/some/path/2'
    - path: '/some/path/2'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/another/path/2'
    - path: '/another/path/1'
    - path: '/another/path/3'

--- expected
- path: '/some/path/3'
  count: 12 
- path: '/some/path/2'
  count: 3 
- path: '/some/path/1'
  count: 2 

===
--- config
from_result_key: URI
to_result_key: ranking
mincount: 3

--- result
URI:
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/1'
    - path: '/some/path/1'
    - path: '/some/path/2'
    - path: '/some/path/3'
    - path: '/some/path/2'
    - path: '/some/path/2'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/some/path/3'
    - path: '/another/path/2'
    - path: '/another/path/1'
    - path: '/another/path/3'

--- expected
- path: '/some/path/3'
  count: 12 
- path: '/some/path/2'
  count: 3 

=== 
--- config
from_result_key: URI
to_result_key: ranking

--- result
URI:
    - path: '/some/path/1'
      query: foo
    - path: '/some/path/1'
      query: foo+bar
    - path: '/some/path/2'
      query: foo+bar+baz
    - path: '/some/path/2'
      query: foo+bar+baz
    - path: '/some/path/2'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar+baz
    - path: '/some/path/3'
      query: foo+bar
    - path: '/some/path/3'
      query: foo
    - path: '/another/path/2'
      query: foo+bar
    - path: '/another/path/1'
      query: foo+bar+baz
    - path: '/another/path/3'
      query: foo

--- expected
- path: '/some/path/3'
  query: foo
  count: 5
- path: '/some/path/3'
  query: foo+bar+baz
  count: 3
- path: '/some/path/3'
  query: foo+bar
  count: 3 
- path: '/some/path/2'
  query: foo+bar+baz
  count: 2
- path: '/another/path/1'
  query: foo+bar+baz
  count: 1
- path: '/some/path/2'
  query: foo+bar
  count: 1
- path: '/some/path/1'
  query: foo+bar
  count: 1
- path: '/another/path/2'
  query: foo+bar
  count: 1
- path: '/some/path/1'
  query: foo
  count: 1
- path: '/another/path/3'
  query: foo
  count: 1
