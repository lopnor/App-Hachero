package App::Hachero::Plugin::Parse::HadoopReduce;
use strict;
use warnings;
use base 'App::Hachero::Plugin::Base';

sub parse : Hook {
    my ( $self, $context, $args ) = @_;
    my ($key, $value) = split(/\t/,$context->currentline);
    my $VAR1; # for Data::Dumper;
    eval $value;
    (my $package = ref $VAR1) =~ s/Result\:\:/Plugin::Analyze::/;
    $package->require;
    my ($prime, $second) = split('-',$key);
    my $result = $context->result->{$prime};
    if ($result) {
        my ($value) = $VAR1->values;
        $result->push($value->hashref);
    } else {
        $context->result->{$prime} = $VAR1;
    }
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Parse::HadoopReduce - parses line from A::H::P::OutputLine::HadoopMap

=head1 SYNOPSYS

  ---
  plugins:
    - module: Parse::HadoopReduce

=head1 DESCRIPTION

parses line from A::H::P::OutputLine::HadoopMap

=head2 implemented hooks

=over 4

=item * parse

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

Hadoop L<http://hadoop.apache.org/>

=cut
