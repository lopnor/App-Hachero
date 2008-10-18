package App::Hachero::Plugin::Output::Dump;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use YAML;

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $fh = \*STDOUT;
    print $fh $context->result;
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Output::Dump - dumps result to STDOUT (for debug)

=head1 SYNOPSYS

  ---
  plugins:
    - module: Output::Dump

=head1 DESCRIPTION

dumps result to STDOUT (for debug)

=head2 implemented hooks

=over 4
    
=item * output

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<YAML>

=cut
