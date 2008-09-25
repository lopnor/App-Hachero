package App::Hachero::Result;
use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::Inheritable);
use Digest::MD5 qw(md5_hex);
use App::Hachero::Result::Data;
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
    for my $value (sort _cmp CORE::values %{$self->data}) {
        CORE::push @{$self->arrayref}, $value;
    }
}

sub _cmp {
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

1;
