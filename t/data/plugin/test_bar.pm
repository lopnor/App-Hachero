package App::Hachero::Plugin::Analyze::Bar;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub analyze : Hook {
    my ($self, $context) = @_;
    $context->result->{Bar} = App::Hachero::Plugin::Analyze::Bar::Result->new;
    $context->result->{Bar}->push(
        {
            baz => 'hoge',
        }
    );
}

package App::Hachero::Plugin::Analyze::Bar::Result;
use base qw(App::Hachero::Result);
__PACKAGE__->primary([qw(baz)]);

1;
