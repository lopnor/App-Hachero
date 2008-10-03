package App::Hachero::Plugin::Classify::UserAgent;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use HTTP::DetectUserAgent;

sub init {
    my ($self, $context) = @_;
}

sub classify : Hook {
    my ($self, $context, $args) = @_;
    my $ua = $context->currentlog->{ua} or return;
    my $browser = HTTP::DetectUserAgent->new($ua);
    $context->currentinfo->{useragent} = $browser;
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Classify::UserAgent - sets useragent information for the request

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS
    
=head2 classify

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<HTTP::DetectUserAgent>

=cut
