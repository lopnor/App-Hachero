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
    $context->result->{AccessCount} ||= App::Hachero::Plugin::Analyze::AccessCount::Result->new;
    $context->result->{AccessCount}->push(
        {
            datetime => DateTime::Format::MySQL->format_datetime($time),
        }
    );
}

package  # hide from PAUSE
    App::Hachero::Plugin::Analyze::AccessCount::Result;
use base qw(App::Hachero::Result);
__PACKAGE__->mk_classdata(primary => ['datetime']);

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Analyze::AccessCount - simple analyzer for App::Hachero

=head1 SYNOPSYS

  ---
  plugins:
    - module: Analyze::AccessCount
      config:
        truncate_to: minute

=head1 DESCRIPTION

=head2 implemented hooks

=over 4

=item * analyze

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result>

=cut
