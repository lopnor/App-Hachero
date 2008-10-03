package App::Hachero::Plugin::Output::TT;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Template;
use IO::All;

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $tt_file = $self->config->{config}->{template};
    my $out_file = $self->config->{config}->{out};
    my $tt = Template->new;
    my $template < io $tt_file;
    $tt->process(\$template, $context, \my $out);
    $out > io $out_file;
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Output::TT - writes results via template toolkit

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS
    
=head2 output

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<Template>

=cut
