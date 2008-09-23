use strict;
use warnings;
use Test::Base;
use App::Hachero;
use DateTime;

plan tests => 1 * blocks;

filters {
    input => [qw(yaml)],
    expected => [qw(chomp)],
};

my $config = {
    global => {log => {level => 'error'}},
    plugins => [
        {
            module => 'Classify::AccessTime',
            config => {
                time_zone => 'local',
                from => {
                    subtract => {days => 1}
                },
                to => {
                    subtract => {days => 0}
                },
            },
        },
    ]
};
my $app = App::Hachero->new({config => $config});

run {
    my $block = shift;
    $app->currentline('1');
    my $dt = DateTime->now( time_zone => 'local' )
                     ->truncate( to => 'day' )
                     ->subtract(%{$block->input});
    $app->currentinfo({request => {datetime => $dt}});
    $app->run_hook('classify');
    is $app->currentline, $block->expected;
};

__END__
=== 
--- input
hours: 5
--- expected
1
=== 
--- input
minutes: 1
--- expected
1
=== 
--- input
minutes: 0
--- expected

=== 
--- input
hours: 24
--- expected
1
=== 
--- input
minutes: 1441
--- expected

