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
    my $cmp = sub {
        for (@{$self->primary}) {
            if (my $res = $a->{$_} cmp $b->{$_}) {
                return $res;
            }
        }
    };
    for my $value (sort $cmp CORE::values %{$self->data}) {
        CORE::push @{$self->arrayref}, $value;
    }
}

sub key {
    my ($self, $args) = @_;
    md5_hex (map {$args->{$_}} @{$self->primary});
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Result - represents a series of result of App::Hachero

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head2 push($hashref)

pushes new data hashref to the result and set count of the data to 1.

=head2 values

returns data array of this result.

=head2 sort

sorts data array for values method. you can override this method for your result class.

=head2 key($data) (internal use only)

returns md5_hex key for the result data.

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result::Data>

=cut
