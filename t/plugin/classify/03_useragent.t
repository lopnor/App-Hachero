use strict;
use warnings;
use Test::Base;
use App::Hachero;

BEGIN {
    eval { require 'HTTP::DetectUserAgent' };
    if ($!) {
        plan skip_all => 'no HTTP::DetectUserAgent found';
    } else {
        plan tests =>  (1 * blocks);
    }
}

my $config = {
    plugins => [
        {module => 'Classify::UserAgent'},
    ],
};
my $app = App::Hachero->new({config => $config});

filters {
    input    => [qw(yaml)],
    expected => [qw(chomp)],
};

run {
    my $block = shift;
    $app->currentlog($block->input);
    $app->currentinfo( {} );
    $app->run_hook('classify');
    is $app->currentinfo->{useragent}->name, $block->expected;
}

__END__
=== InternetExplorer
--- input
ua: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)
--- expected
Internet Explorer

=== Firefox
--- input
ua: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1
--- expected
Firefox

=== Opera
--- input
ua: Opera/9.52 (Windows NT 5.1; U; ja)
--- expected
Opera
