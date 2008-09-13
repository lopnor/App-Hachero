package App::Hachero::Plugin::Analyze::AccessCount;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime::Format::MySQL;
use Digest::MD5;

sub analyze : Hook {
    my ($self, $context, $args) = @_;
    my $req = $context->currentinfo->{request} or return;
    my $truncate = $self->config->{config}->{truncate_to} || 'minute';
    my $time = DateTime::Format::MySQL->format_datetime(
        $req->{datetime}->clone->truncate(to => $truncate)
    );
    my $hash = Digest::MD5::md5_base64($time);
    $context->result->{'AccessCount'}->{$hash} = {
        datetime => $time,
        count => ($context->result->{'AccessCount'}->{$hash}->{count} || 0) + 1,
    }
}

1;
