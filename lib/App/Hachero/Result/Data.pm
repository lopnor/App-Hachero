package App::Hachero::Result::Data;
use strict;
use warnings;

sub new {
    my ($class, $self) = @_;
    bless $self, $class;
}

sub keys {
    my $self = shift;
    return sort {$a eq 'count' ? 1 : 0} keys %{$self};
}

sub value {
    my ($self, $arg) = @_;
    return $self->{$arg};
}

sub count_up {
    my ($self, $n) = @_;
    $n ||= 1;
    shift->{count} += $n;
}

sub hashref {
    my $self = shift;
    return { %{$self} };
}

1;
