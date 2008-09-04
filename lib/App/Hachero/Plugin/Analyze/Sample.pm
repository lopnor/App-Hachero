package App::Hachero::Plugin::Analyze::Sample;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub analyze : Hook {
    my ($self, $context,$args) = @_;
    push @{$context->result->{ref $self}}, $context->currentline;
}

1;