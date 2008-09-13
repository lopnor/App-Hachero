use strict;
use warnings;
use Test::Base;
use App::Hachero;

plan tests => (1 * blocks);

my $config = {
    plugins => [
        {
            module => 'Parse::Normalize',
            config => {time_zone => 'Asia/Tokyo'},
        },
        {
            module => 'Analyze::AccessCount',
            config => {truncate_to => 'hour'},
        }
    ]
};

my $app = App::Hachero->new({config => $config});

filters {
    input => [qw(yaml)],
    expected => [qw(yaml)],
};

run {
    my $block = shift;
    $app->result({});
    $app->currentinfo({});
    $app->currentlog($block->input);
    $app->run_hook('parse');
    $app->run_hook('analyze');
    my $value = (values %{$app->result->{AccessCount}})[0];
    is_deeply $value, $block->expected;
}

__END__
=== test1
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
datetime: '2008-08-07 00:00:00'
count: 1

=== test2
--- input
authuser: -
bytes: 5567
date: '[06/Aug/2008:14:05:45 +0800]'
referer: '""'
req: GET /mizuno_takaaki HTTP/1.0
request: '"GET /mizuno_takaaki HTTP/1.0"'
rfc: -
status: 200
ts: 06/Aug/2008:14:05:45 +0800
ua: ''
useragent: '""'

--- expected
datetime: '2008-08-06 15:00:00'
count: 1

