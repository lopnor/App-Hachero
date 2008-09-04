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
