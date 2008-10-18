package App::Hachero::Plugin::Filter::AccessTime;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DateTime;

sub initialize: Hook {
    my ($self, $context) = @_;
    my $time_zone = $context->conf->{global}->{time_zone} || 'local';
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

sub filter : Hook {
    my ($self, $context, $args) = @_;

    my $date = $context->currentinfo->{request}->{datetime} or return;

    $context->currentline('') if $date < $self->{from};
    $context->currentline('') if $date >= $self->{to};
    $context->log(debug => 'skip') unless $context->currentline;
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Filter::AccessTime - excludes requests in specified time

=head1 SYNOPSYS

  ---
  global:
    - time_zone: Asia/Tokyo
  plugins:
    - module: Filter::AccessTime
      config:
        from:
            subtract:
                days: 1
        to:
            subtract:
                days: 0

=head1 DESCRIPTION

excludes requests in specified time.

=head2 implemented hooks

=over 4
    
=item * filter

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
