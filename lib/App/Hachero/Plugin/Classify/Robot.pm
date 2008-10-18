package App::Hachero::Plugin::Classify::Robot;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub classify : Hook {
    my ($self, $context, $args) = @_;
    my $ua = $context->currentlog->{ua} or return;
    $context->currentinfo->{is_robot} = $ua =~ /googlebot|slurp/ ? 1 : 0;
    if( $context->currentinfo->{is_robot} ){
        if( $self->config->{config} && 
                $self->config->{config}->{filter} == 1 ){
            $context->currentline( '' );
        }
    }
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Classify::Robot - plugin that marks robot request

=head1 SYNOPSYS

  ---
  plugins:
    - module: Classify::Robot
      config:
        filter: 1

=head1 DESCRIPTION

A plugin that marks robot request. excludes robot request if you pass 1 to filter configuration.

=head2 implemented hooks

=over 4
    
=item * classify

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut

