package App::Hachero::Plugin::Input::Stdin;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub input : Hook {
    my ($self, $context, $args) = @_;
    my $fh = *STDIN;
    my $line = <$fh>;
    $context->currentline( $line );
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Input::Stdin - reads logs from STDIN

=head1 SYNOPSYS

  ---
  plugins:
    module: Input::Stdin

=head1 DESCRIPTION

reads logs from STDIN.

=head2 implemented hooks

=over 4

=item * input 

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut

