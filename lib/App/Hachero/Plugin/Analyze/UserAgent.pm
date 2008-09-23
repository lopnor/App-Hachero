package App::Hachero::Plugin::Analyze::UserAgent;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime::Format::MySQL;

__PACKAGE__->mk_accessors(qw(result));

sub analyze : Hook {
    my ($self, $context,$args) = @_;
    my $req = $context->currentinfo->{request} or return;
    my $browser = $context->currentinfo->{useragent} or return;
    my $browser_string = $browser->browser_string || '';
    my $truncate = $self->config->{config}->{truncate_to} || 'hour';
    my $time = $req->{datetime}->clone->truncate(to => $truncate);
    my $key = $time->epoch.$browser_string;

    $context->result->{UserAgent} ||= App::Hachero::Result::UserAgent->new;
    
    $context->result->{UserAgent}->push(
        {
            datetime => DateTime::Format::MySQL->format_datetime($time),
            useragent => $browser_string,
        }
    );
}

package App::Hachero::Result::UserAgent;
use base qw(App::Hachero::Result);
__PACKAGE__->mk_classdata('primary' => [qw(datetime useragent)]);

1;
