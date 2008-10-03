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
            module => 'Classify::UserAgent',
        },
        {
            module => 'Analyze::UserAgent',
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
    $app->run_hook('classify');
    $app->run_hook('analyze');
    my $res = $app->result->{UserAgent};
    my $value = (values %{$app->result->{UserAgent}->data})[0];
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
ua: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)
useragent: '"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)"'

--- expected
datetime: '2008-08-07 00:00:00'
useragent: 'Internet Explorer'
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
ua: 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1'
useragent: '"Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1"'

--- expected
datetime: '2008-08-06 15:00:00'
useragent: 'Firefox'
count: 1
