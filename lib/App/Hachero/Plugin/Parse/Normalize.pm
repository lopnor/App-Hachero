package App::Hachero::Plugin::Parse::Normalize;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime::Format::HTTP;
use URI;

sub parse : Hook {
    my ($self, $context, $args) = @_;
    my $log  = $context->currentlog;
    my $info = $context->currentinfo;
    $log->{req} or return;
    $log->{ts} or return;
    my @req = split( /\s+/,$log->{req});
    my $datetime = DateTime::Format::HTTP->parse_datetime($log->{ts});
    if (my $tz = $self->config->{config}->{time_zone}) {
        $datetime->set_time_zone($tz);
    }
    $info->{request} = {
        method   => $req[0],
        uri      => URI->new($req[1]),
        protocol => $req[2] || 'HTTP/0.9',
        datetime => $datetime,
    };
}

1;
