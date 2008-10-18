package App::Hachero::Plugin::Output::TT;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Template;

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $tt_file = $self->config->{config}->{template};
    my $out_file = $self->config->{config}->{out};
    my $tt = Template->new;
    open my $fh_in, '<', $tt_file;
    my $template = do {local $/; <$fh_in>};
    close $fh_in;
    $tt->process(\$template, $context, \my $out);
    open my $fh_out, '>', $out_file;
    print $fh_out $out;
    close $fh_out;
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Output::TT - writes results via template toolkit

=head1 SYNOPSYS

  ---
  plugins:
    - module: Output::TT
      config:
        template: /path/to/your/template
        out: /path/to/output

=head1 DESCRIPTION

writes results via template toolkit

=head2 implemented hooks

=over 4

=item * output

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<Template>

=cut
