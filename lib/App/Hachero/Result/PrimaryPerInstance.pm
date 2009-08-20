package App::Hachero::Result::PrimaryPerInstance;
use strict;
use warnings;
use base qw(App::Hachero::Result);
__PACKAGE__->mk_accessors(qw(primary sort_key sort_reverse));

1;

__END__

=pod

=head1 NAME

App::Hachero::Result::PrimaryPerInstance - represents a series of result of App::Hachero

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result::Data>

L<App::Hachero::Result>

=cut
