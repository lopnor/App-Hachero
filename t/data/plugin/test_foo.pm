package App::Hachero::Plugin::Test::Foo;
use strict;
use warnings;
use base 'App::Hachero::Plugin::Base';

sub input : Hook {
    my ($self, $context) = @_;
    $context->currentline('ok');
}

1;
