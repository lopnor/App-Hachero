package App::Hachero::Plugin::Parse::HadoopReduce;
use strict;
use warnings;
use base 'App::Hachero::Plugin::Base';
use App::Hachero::Result;

sub parse : Hook {
    my ( $self, $context, $args ) = @_;
    my ($key, $value) = split(/\t/,$context->currentline);
    my $VAR1; # for Data::Dumper;
    eval $value;
    my ($prime, $second) = split('-',$key);
    my $record = $context->result->{$prime}->{$second};
    if ($record) {
        $record->count_up($VAR1->{count});
    } else {
        $context->result->{$prime}->{$second} = $VAR1;
    }
}

1;
