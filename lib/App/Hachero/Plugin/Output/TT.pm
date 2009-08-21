package App::Hachero::Plugin::Output::TT;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Template;

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $config = $self->config->{config};
    my $tt_file = $config->{template};
    my $out_file = $config->{out};
    my $tt = Template->new(
        ABSOLUTE => 1,
        ENCODING => 'utf8',
    ) or die $Template::ERROR;
    my $vars;
    if ($config->{stash_key} && $config->{result_key}) {
        $vars = {$config->{stash_key} => $context->result->{$config->{result_key}}};
    } else {
        $vars = $context;
    }
    my $ok = $tt->process($tt_file, $vars, $out_file, {binmode => ':utf8'});
    $ok or die $tt->error;
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
