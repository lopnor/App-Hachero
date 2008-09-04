use strict;
use warnings;
use Test::Base;
use App::Hachero;

plan tests =>  (1 * blocks);

filters {
    config => [qw(yaml)],
    input => [qw(chomp)],
    expected => [qw(yaml)],
};

run {
    my $block = shift;
    my $app = App::Hachero->new({config => $block->config});
    $app->currentline($block->input);
    $app->run_hook('parse');
    is_deeply $app->currentlog, $block->expected;
}

__END__
=== common
--- config
plugins:
    - module: 'Parse::Common'
      config:
          format: ':common'

--- input
192.168.0.1 - - [04/Sep/2008:10:50:50 +0900] "GET /feed HTTP/1.1" 200 9117

--- expected
authuser: -
bytes: 9117
date: '[04/Sep/2008:10:50:50 +0900]'
host: 192.168.0.1
req: GET /feed HTTP/1.1
request: '"GET /feed HTTP/1.1"'
rfc: -
status: 200
ts: 04/Sep/2008:10:50:50 +0900

=== extended
--- config
plugins:
    - module: 'Parse::Common'
      config:
          format: ':extended'

--- input
122.1.9.166 - - [04/Sep/2008:10:57:30 +0900] "GET / HTTP/1.1" 200 5316 "http://reader.livedoor.com/reader/" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_4; ja-jp) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.2 Safari/525.20.1"

--- expected
authuser: -
bytes: 5316
date: '[04/Sep/2008:10:57:30 +0900]'
host: 122.1.9.166 
ref: 'http://reader.livedoor.com/reader/'
referer: '"http://reader.livedoor.com/reader/"'
req: GET / HTTP/1.1
request: '"GET / HTTP/1.1"'
rfc: -
status: 200
ts: 04/Sep/2008:10:57:30 +0900
ua: 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_4; ja-jp) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.2 Safari/525.20.1'
useragent: '"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_4; ja-jp) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.2 Safari/525.20.1"'

