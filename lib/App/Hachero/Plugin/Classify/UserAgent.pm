package App::Hachero::Plugin::Classify::UserAgent;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use HTTP::BrowserDetect;

sub init {
    my ($self, $context) = @_;
}

sub classify : Hook {
    my ($self, $context, $args) = @_;
    my $ua = $context->currentlog->{ua} or return;
    my $browser = HTTP::BrowserDetect->new($ua);
    $context->currentinfo->{useragent} = $browser;
}

1;
