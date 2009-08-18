use strict;
use warnings;
use Test::Base;
use App::Hachero;
use URI;

plan tests => (1 * blocks);

filters {
    config => [qw(yaml)],
    request => [qw(create_uri)],
    expected => [qw(yaml)],
};

sub create_uri { $_ = URI->new($_) }

my $app = App::Hachero->new(
    {
        config => { plugins => [ { module => 'Analyze::URI' } ] }
    }
);

run {
    my $block = shift;
    $app->result({});
    my $config = $block->config;
    $app->conf->{plugins}->[0]->{config} = $config;
    $app->run_hook('initialize');
    $app->currentinfo({request => {uri => $block->request}});
    $app->run_hook('analyze');
    is_deeply $app->result->{$config->{result_key} || 'URI'}->values, $block->expected;
}

__END__
===
--- config
result_key: foobar

--- request
http://www.yahoo.com/

--- expected
URI: http://www.yahoo.com/
count: 1

===
--- config

--- request
http://www.yahoo.com/

--- expected
URI: http://www.yahoo.com/
count: 1

===
--- config
result:
    foo: path
--- request
http://www.yahoo.com/some/path?foo=bar
--- expected
foo: /some/path
count: 1
===
--- config
result:
    path: path
    keyword:
        query_param: foo
--- request
http://www.yahoo.com/some/path?foo=bar
--- expected
path: /some/path
keyword: bar
count: 1
===
--- config
result:
    foo: host
--- request
http://www.yahoo.com/some/path?foo=bar
--- expected
foo: www.yahoo.com
count: 1
