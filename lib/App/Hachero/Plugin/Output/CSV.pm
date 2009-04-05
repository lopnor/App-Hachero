package App::Hachero::Plugin::Output::CSV;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Text::CSV_XS;

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $fh = \*STDOUT;
    my $csv = Text::CSV_XS->new($self->config->{config}->{csv} || {binary => 1, eol => "\n"});
            use Data::Dumper;
    for my $output (@{$self->config->{config}->{output}}) {
        my ($key, $fields);
        if (ref $output eq 'HASH') {
            ($key, $fields) = each %$output;
        } else {
            $key = $output;
        }
        my $result = $context->result->{$key};

        for my $data ($result->values) {
            my @cols;
            for my $key ($fields ? @$fields : $data->keys) {
                push @cols, $data->value($key);
            }
            $csv->print($fh, \@cols);
        }
    }
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Output::CSV - Outputs result to STDOUT as CSV

=head1 SYNOPSYS

  ---
  plugins:
    - module: Output::CSV

=head1 DESCRIPTION

outpus result to STDOUT as CSV

=head2 implemented hooks

=over 4
    
=item * output

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
