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
    my $time = $req->{datetime}->clone->truncate(to => $truncate);
    my $key = $time->epoch;
    $context->result->{AccessCount} ||= App::Hachero::Result::AccessCount->new;
    $context->result->{AccessCount}->push(
        {
            datetime => DateTime::Format::MySQL->format_datetime($time),
        }
    );
}

package App::Hachero::Result::AccessCount;
use base qw(App::Hachero::Result);
__PACKAGE__->mk_classdata(primary => ['datetime']);

1;
