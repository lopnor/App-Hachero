use strict;
use warnings;
use Test::Base;
use App::Hachero;
use App::Hachero::Result::PrimaryPerInstance;
use Test::MockModule;

eval {require Web::Scraper};
if ($@) {
    plan skip_all => 'no Web::Scraper found';
    exit;
} else {
    plan tests => 1 * blocks;
}

filters {
    config => [qw(yaml)],
    result => [qw(yaml create_result)],
    response => [qw(chomp)],
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
    { config => { plugins => [ { module => 'Summarize::Scraper' } ] } }
);

run {
    my $block = shift;
    my $ua = Test::MockModule->new('LWP::UserAgent');
    $ua->mock(
        get => sub {
            my ($self, $url) = @_;
            return HTTP::Response->parse($block->response);
        }
    );
    $app->conf->{plugins}->[0]->{config} = $block->config;
    $app->run_hook('initialize');
    $app->result($block->result);
    $app->run_hook('summarize');
    is_deeply [ $app->result->{$block->config->{result_key}}->values ], $block->expected;
};

__END__
===
--- config
result_key: URI
result:
    uri_from: path
    result_to: title
uri:
    scheme: 'http'
    host: 'www.yahoo.com'
scraper:
    process:
        - '//title'
        - 'title'
        - 'TEXT'
    result: 'title'

--- result
URI:
    - path: '/some/path'
--- response
200 OK
Content-Type: text/html

<html>
    <head>
        <title>foobarbaz</title>
    </head>
    <body>
    </body>
</html>
--- expected
- path: '/some/path'
  title: foobarbaz
  count: 1
