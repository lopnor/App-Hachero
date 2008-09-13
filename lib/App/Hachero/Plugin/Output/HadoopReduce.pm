package App::Hachero::Plugin::Output::HadoopReduce;
use strict;
use warnings;
use base 'App::Hachero::Plugin::Base';

sub output : Hook {
    my ( $self, $context ) = @_;
    for my $prime_key (keys %{$context->result}) {
        my $result = $context->result->{$prime_key};
        for my $second_key (keys %{$result}) {
            $self->_writeline(
                $prime_key, 
                map {$result->{$second_key}->{$_}} sort keys %{$result->{$second_key}}
            );

        }
    }
}

sub _writeline {
    my ($self, $key, @value) = @_;
    my $fh = \*STDOUT;
    printf $fh "%s\t%s\n", $key, join ("\t", @value);
}

1;
