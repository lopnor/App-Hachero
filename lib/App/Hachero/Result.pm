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
    if ($self->data->{$key}) {
        $self->data->{$key}->count_up($args->{count} || 1);
    } else {
        $self->data->{$key} = App::Hachero::Result::Data->new($args);
        $self->data->{$key}->count_up unless $args->{count};
    }
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

  my $r = App::Hachero::Result->new;
  $r->push(
    {
        'some_key' => 'some_value',
        'another_key' => 'another_value',
    }
  );

  my @result = $r->values;

=head1 DESCRIPTION

A class to store analyzed data from Hachero. You can override
this result class in your analyze plugin class like this:

  package App::Hachero::Plugin::Analyze::MyAnalyzer;
  use base 'App::Hachero::Plugin::Base';

  sub analyze : Hook {
      my ($self, $context) = @_;
      $context->result->{MyAnalyzer} = App::Hachero::Result::MyAnalyzer->new;
      $context->result->{MyAnalizer}->push(
        {
            mykey => 'hoo',
        }
      );
  }

  package App::Hachero::Result::MyAnalyzer;
  use base 'App::Hachero::Result';
  __PACKAGE__->mk_classdata('primary' => [qw(mykey)]);

  1;

You need to specify 'primary' arrayref classdata in your subclass.

=head1 METHODS

=head2 new

constructor.

=head2 push($hashref)

pushes new data hashref to the result and counts up the data.

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
