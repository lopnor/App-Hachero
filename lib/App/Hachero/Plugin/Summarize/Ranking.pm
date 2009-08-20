package App::Hachero::Plugin::Summarize::Ranking;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub initialize :Hook {
    my ($self, $context) = @_;
    my $config = $self->config->{config};
    $context->result->{$config->{to_result_key}} 
        = App::Hachero::Result::PrimaryPerInstance->new;
}

sub summarize :Hook {
    my ($self, $context) = @_;
    for ( $context->result->{$config->{from_result_key}}->values ) {

    }
}

1;
__END__

=pod 

=head1 NAME

App::Hachero::Plugin::Summarize::Ranking - cuts up and sorts results 

=head1 SYNOPSIS

  ---
  plugins:
    - module: Summarize::Ranking
      config:
        from_result_key: URI
        to_result_key: ranking
        order_by:
            - count: desc
        limit: 10

=head1 DESCRIPTION

cuts up and sorts results 

=head2 implemented hooks

=over 4

=item * initialize

=item * summarize

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result>

=cut
