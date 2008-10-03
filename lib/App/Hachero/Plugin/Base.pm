package App::Hachero::Plugin::Base;
use strict;
use warnings;
use base qw/Class::Component::Plugin Class::Accessor::Fast/;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self;
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Base - base class of plugin for App::Hachero

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

constructor.

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
