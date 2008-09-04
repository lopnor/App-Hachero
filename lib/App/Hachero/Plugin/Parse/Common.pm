package App::Hachero::Plugin::Parse::Common;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Regexp::Log::Common;

sub init {
    my ($self, $context) = @_;
    my $regexp = Regexp::Log::Common->new(
        format => $self->config->{config}->{format} || ':extended',
    );
    $self->{re} = $regexp->regexp;
    @{$self->{capture}} = $regexp->capture;
}

sub parse : Hook {
    my ($self, $context, $args) = @_;
    my %data;
    @data{@{$self->{capture}}} = $context->currentline =~ /$self->{re}/;
    $context->currentlog(\%data);
}

1;