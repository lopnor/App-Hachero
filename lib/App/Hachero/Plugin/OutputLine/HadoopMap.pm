package App::Hachero::Plugin::OutputLine::HadoopMap;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use JSON;

sub output_line : Hook {
    my ($self, $context) = @_;
    for my $prime_key (keys %{$context->result}) {
        my $result = $context->result->{$prime_key};
        for my $second_key (keys %{$result}) {
            my $value = JSON->new->allow_blessed->encode($result->{$second_key});
            $self->_writeline("$prime_key-$second_key", $value);
        }
    }
    $context->result( {} );
}

sub _writeline {
    my ($self, $key, $value) = @_;
    my $fh = \*STDOUT;
    printf $fh "%s\t%s\n", $key, $value;
}

1;
