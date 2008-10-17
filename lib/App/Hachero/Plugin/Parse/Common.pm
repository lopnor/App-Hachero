package App::Hachero::Plugin::Parse::Common;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Regexp::Log::Common;

sub initialize : Hook {
    my ($self, $context) = @_;
    my $regexp = Regexp::Log::Common->new(
        format => $self->config->{config}->{format} || ':extended',
    );
    $self->{re} = $regexp->regexp;
    @{$self->{capture}} = $regexp->capture;
}

sub parse : Hook {
    my ($self, $context, $args) = @_;
    my %data;
    @data{@{$self->{capture}}} = $context->currentline =~ /$self->{re}/;
    $context->currentlog(\%data);
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Parse::Common - parses common apache logs

=head1 SYNOPSYS

  ---
  plugins:
    - module: Parse::Common
      config:
        format: ':common'

=head1 DESCRIPTION

parses common apache logs

=head2 implemented hooks

=over 4

=item * parse

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<Regexp::Log::Common>

=cut
