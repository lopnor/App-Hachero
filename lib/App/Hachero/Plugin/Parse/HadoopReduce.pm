package App::Hachero::Plugin::Parse::HadoopReduce;
use strict;
use warnings;
use base 'App::Hachero::Plugin::Base';
use JSON;

sub parse : Hook {
    my ( $self, $context, $args ) = @_;
    my $line = $context->currentline;
    chomp $line;
    my ($key, $value) = split(/\t/,$line);
    $value = JSON->new->decode($value);
    my ($prime, $second) = split('-',$key);
    my $record = $context->result->{$prime}->{$second};
    if ($record) {
        $record->{count} += $value->{count};
    } else {
        $context->result->{$prime}->{$second} = $value;
    }
}

1;
