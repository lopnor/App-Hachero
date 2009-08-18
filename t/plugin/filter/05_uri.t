use strict;
use warnings;
use Test::Base;
use URI;
use App::Hachero;

plan tests => 1 * blocks;

filters {
    config => [qw(yaml)],
    request => [qw(create_uri)],
    expected => [qw(chomp)],
};

sub create_uri { $_ = URI->new($_) }
my $app = App::Hachero->new(
    {
        config => {
            global => { log => {level => 'error'} },
            plugins => [ { module => 'Filter::URI' } ],
        }
    }
);

run {
    my $block = shift;
    $app->conf->{plugins}->[0]->{config} = $block->config;
    $app->currentline('1');
    $app->currentinfo({request => {uri => $block->request}});
    $app->run_hook('filter');
    is $app->currentline, $block->expected;
}

__END__
===
--- config
- exclude: all

--- request
http://www.yahoo.com/

--- expected

===
--- config
- include: all

--- request
http://www.yahoo.com/

--- expected
1
===
--- config
- exclude: all
- include:
    path: !!perl/regexp (?-xism:^/some/path)
--- request
http://www.yahoo.com/some/path/foobar?ref=rss
--- expected
1
===
--- config
- exclude: all
- include:
    path: /some/path
--- request
http://www.yahoo.com/some/path/foobar?ref=rss
--- expected

===
--- config
- exclude: all
- include:
    path: /some/path
--- request
http://www.yahoo.com/some/path?ref=rss
--- expected
1
===
--- config
- exclude: all
- include:
    path: /some/path
- exclude:
    query_form:
        ref: rss
--- request
http://www.yahoo.com/some/path?ref=rss
--- expected

===
--- config
- exclude: all
- include:
    path: /some/path
- exclude:
    query_form:
        ref: rss
        foo: bar
--- request
http://www.yahoo.com/some/path?ref=rss
--- expected
1
===
--- config
- exclude: all
- include:
    path: /some/path
- exclude:
    query_form:
        ref: rss
        foo: bar
--- request
http://www.yahoo.com/some/path?ref=rss&foo=bar&hoge=fuga
--- expected

