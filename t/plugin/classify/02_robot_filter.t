use strict;
use warnings;
use Test::Base;
use App::Hachero;

plan tests =>  (1 * blocks);

my $config = {
    plugins => [
        {
            module => 'Classify::Robot',
            config => {
                filter => 1,
            },
        },
    ],
};
my $app = App::Hachero->new({config => $config});

filters {
    input => [qw(yaml)],
    expected => [qw(chomp)],
};

run {
    my $block = shift;
    $app->currentlog($block->input);
    $app->currentline( 'did not filterd' );
    $app->currentinfo( {} );
    $app->run_hook('classify');
    is $app->currentline, $block->expected;
}

__END__
=== googlebot
--- input
ua: Googlebot/2.1 (+http://www.googlebot.com/bot.html)
--- expected


=== yahoo sulrp
--- input
ua: Mozilla/5.0 (compatible; Yahoo! Slurp/3.0; http://help.yahoo.com/help/us/ysearch/slurp)
--- expected


=== IE
--- input
ua: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)
--- expected
did not filterd
