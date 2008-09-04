use strict;
use warnings;
use Test::More tests => 11;
use App::Hachero;

BEGIN { 
    use_ok 'App::Hachero::Plugin::Analyze::UA';
};

{
    my $config = {
        plugins => [
            {module => 'Analyze::UA'},
        ]
    };

    my $app = App::Hachero->new({config => $config});
    for my $i (1 .. 10) {
        $app->currentlog({
                ua => 'Mozilla'
            });
        $app->run_hook('analyze');
        is $app->result->{'App::Hachero::Plugin::Analyze::UA'}->{'Mozilla'}, $i;
    }
}