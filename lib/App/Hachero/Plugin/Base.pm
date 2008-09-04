package App::Hachero::Plugin::Base;
use strict;
use warnings;
use base qw/Class::Component::Plugin Class::Accessor::Fast/;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self;
}

1;
