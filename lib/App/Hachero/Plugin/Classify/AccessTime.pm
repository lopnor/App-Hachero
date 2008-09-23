package App::Hachero::Plugin::Classify::AccessTime;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime;

sub init {
    my ($self, $context) = @_;
    my $time_zone = $self->config->{config}->{time_zone} || 'local';
    my $dt = DateTime->now(time_zone => $time_zone)->truncate(to => 'day');
    for my $key ('from', 'to') {
        if ($self->config->{config}->{$key}) {
            my ($action,$value) = %{$self->config->{config}->{$key}};
            $self->{$key} = $dt->clone->$action(%{$value});
        } else {
            $self->{$key} = $dt->clone;
        }
    }
}

sub classify : Hook {
    my ($self, $context, $args) = @_;

    my $date = $context->currentinfo->{request}->{datetime} or return;

    $context->currentline('') if $date < $self->{from};
    $context->currentline('') if $date >= $self->{to};
    $context->log(debug => 'skip') unless $context->currentline;
}

1;
