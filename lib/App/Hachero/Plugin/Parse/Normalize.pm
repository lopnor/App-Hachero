package App::Hachero::Plugin::Parse::Normalize;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime::Format::HTTP;
use URI;
use URI::QueryParam;

sub parse : Hook {
    my ($self, $context, $args) = @_;
    my $log  = $context->currentlog;
    my $info = $context->currentinfo;
    $log->{req} or return;
    $log->{ts} or return;
    my @req = split( /\s+/,$log->{req});
    my $datetime = DateTime::Format::HTTP->parse_datetime($log->{ts});
    if (my $tz = $context->conf->{global}->{time_zone}) {
        $datetime->set_time_zone($tz);
    }
    $info->{request} = {
        method   => $req[0],
        uri      => URI->new($req[1], 'http'),
        protocol => $req[2] || 'HTTP/0.9',
        datetime => $datetime,
    };
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Parse::Normalize - normalizes request informations set by Parse::Common

=head1 SYNOPSYS

  ---
  global:
    time_zone: Asia/Tokyo
  plugins:
    - module: Parse::Normalize

=head1 DESCRIPTION

normalizes request informations set by Parse::Common

=head2 implemented hooks

=over 4
    
=item * parse

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
