package App::Hachero::Plugin::Classify::Robot;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub init {
    my ($self, $context) = @_;
}

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

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Classify::Robot - plugin that marks robot request

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS
    
=head2 classify

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut

