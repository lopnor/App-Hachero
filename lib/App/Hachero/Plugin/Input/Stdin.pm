package App::Hachero::Plugin::Input::Stdin;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub init {
    my ($self, $context) = @_;
    $self->{fh} = *STDIN;
}

sub input : Hook {
    my ($self, $context, $args) = @_;
    my $fh = $self->{fh};
    my $line = <$fh>;
    $context->currentline( $line );
}

1;
