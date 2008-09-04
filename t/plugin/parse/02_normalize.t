use strict;
use warnings;
use Test::Base;
use App::Hachero;

plan tests =>  (6 * blocks);

my $config = {
    plugins => [
        {module => 'Parse::Normalize'},
    ],
};
my $app = App::Hachero->new({config => $config});

filters {
    input => [qw(yaml)],
    expected => [qw(yaml)],
};

run {
    my $block = shift;
    $app->currentinfo( {} );
    $app->currentlog($block->input);
    $app->run_hook('parse');
    my $info = $app->currentinfo;

#    use YAML;
#    warn Dump($info);
    

    my $expected = $block->expected;
    for my $name ( qw/method uri protocol datetime/ ){
        is $info->{request}->{$name}, $expected->{$name};
    }
    isa_ok $info->{request}->{uri}, 'URI';
    isa_ok $info->{request}->{datetime}, 'DateTime';
}

__END__
=== logn
--- input
authuser: -
bytes: 5567
date: '[06/Aug/2008:23:00:04 +0800]'
host: 192.168.0.1
ref: http://localhost/
referer: '"http://localhost/"'
req: GET / HTTP/1.1
request: '"GET / HTTP/1.1"'
rfc: -
status: 200
ts: 06/Aug/2008:23:00:04 +0800
ua: LWP/Simple
useragent: '"LWP/Simple"'

--- expected
method: 'GET'
uri: '/'
protocol: 'HTTP/1.1'
datetime: '2008-08-06T23:00:04'

=== short
--- input
authuser: -
bytes: 15712
date: '[06/Aug/2008:23:00:00 +0800]'
host: 172.19.1.2
ref: ''
referer: '""'
req: GET /mizuno_takaaki HTTP/1.0
request: '"GET /mizuno_takaaki HTTP/1.0"'
rfc: -
status: 200
ts: 06/Aug/2008:23:00:00 +0800
ua: ''
useragent: '""'

--- expected
method: 'GET'
uri: '/mizuno_takaaki'
protocol: 'HTTP/1.0'
datetime: '2008-08-06T23:00:00'
