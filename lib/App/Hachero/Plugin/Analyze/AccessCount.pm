package App::Hachero::Plugin::Analyze::AccessCount;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime::Format::MySQL;

sub analyze : Hook {
    my ($self, $context, $args) = @_;
    my $req = $context->currentinfo->{request} or return;
    my $time = DateTime::Format::MySQL->format_datetime(
        $req->{datetime}->clone->truncate(to => 'minute')
    );
    $context->result->{'AccessCount'}->{$time} = {
        datetime => $time,
        count => ($context->result->{'AccessCount'}->{$time}->{count} || 0) + 1,
    }
}

1;