package App::Hachero::Plugin::Summarize::NarrowDown;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub summarize :Hook {
    my ($self, $context) = @_;
    my $config = $self->config->{config};
    my $tmp = App::Hachero::Result::PrimaryPerInstance->new(
        { 
            primary => $config->{primary},
            sort_key => 'count',
            sort_reverse => 1,
        }
    );
    for my $r ( $context->result->{$config->{from_result_key}}->values ) {
        $tmp->push(
            { map { $_ => $r->{$_} } ('count', @{$config->{primary}}) }
        );
    }
    my $count = 0;
    my $result = App::Hachero::Result::PrimaryPerInstance->new(
        { 
            primary => $config->{primary},
            sort_key => 'count',
            sort_reverse => 1,
        }
    );
    $context->result->{$config->{to_result_key}} = $result;
    for my $r ($tmp->values) {
        last if $config->{limit} && ($count++ == $config->{limit});
        last if $config->{mincount} && ($r->count < $config->{mincount});
        $result->push($r);
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
        primary:
            - path
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
