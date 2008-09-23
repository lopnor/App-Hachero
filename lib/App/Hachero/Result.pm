package App::Hachero::Result;
use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);
use Digest::MD5 qw(md5_hex);
__PACKAGE__->mk_classdata('primary');
__PACKAGE__->mk_accessors(qw(data arrayref));

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->data({});
    bless $self, $class;
}

sub push {
    my ($self, $args) = @_;
    my $key = $self->key($args);
    $self->data->{$key} ||= App::Hachero::Result::Data->new($args);
    $self->data->{$key}->count_up;
}

sub values {
    my $self = shift;
    $self->sort;
    return @{$self->arrayref};
}

sub sort {
    my $self = shift;
    $self->arrayref([]);
    my $package = ref $self;
    no strict 'refs';
    my $cmp = *{"$package\::cmp"};
    for my $value (sort $cmp CORE::values %{$self->data}) {
        CORE::push @{$self->arrayref}, $value;
    }
}

sub cmp {
    for (@{__PACKAGE__->primary}) {
        if (my $res = $a->{$_} cmp $b->{$_}) {
            return $res;
        }
    }
}

sub key {
    my ($self, $args) = @_;
    md5_hex (map {$args->{$_}} @{$self->primary});
}

package App::Hachero::Result::Data;

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

1;
