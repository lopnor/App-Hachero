package App::Hachero::Plugin::Output::Baz;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use YAML;

sub output : Hook {
    my ($self, $context) = @_;
    my $fh = \*STDOUT;


    for my $key (keys %{$context->result}) {
        print $fh $key,"\n";
        my $result = $context->result->{$key};
        for my $value ($result->values) {
            print $fh Dump $value->hashref;
        }
    }
}
1;
