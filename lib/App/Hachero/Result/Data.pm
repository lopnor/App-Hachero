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
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Result::Data - a class to store analyzed data of Hachero

=head1 SYNOPSYS

  my $data = App::Hachero::Result::Data->new(
      {
          foo => 'bar',
          hoge => 'fuga',
      }
  );
  $data->count_up;

  my @keys = $data->keys;
  # qw(foo hoge count)

  my $value = $data->value('count');
  # 1
  $data->count_up(4)
  $value = $data->value('count');
  # 5

  my $hashref = $data->hashref;
  # { foo => 'bar', hoge => 'fuga', count => 5 }

=head1 DESCRIPTION

A class to store analyzed data of Hachero.

=head1 METHODS

=head2 new($hashref)

creates result data. 

=head2 keys

returns keys in this data objects.

=head2 value($key)

returns data value of specified key.

=head2 count_up($count)

increments 'count' value with specified number. default number is 1.

=head2 hashref

returns data hashref of this object.

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result>

=cut
