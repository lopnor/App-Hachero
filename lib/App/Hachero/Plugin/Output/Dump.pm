package App::Hachero::Plugin::Output::Dump;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use YAML;

sub init {

}

sub output : Hook {
    my ($self, $context, $args) = @_;
    warn Dump $context->result;
}

1;