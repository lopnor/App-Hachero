package App::Hachero::Plugin::Analyze::UA;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
__PACKAGE__->mk_accessors(qw(result));

sub analyze : Hook {
    my ($self, $context,$args) = @_;
    my $log = $context->currentlog or return;
    $context->result->{ref $self}->{$log->{ua}}++;
}

1;